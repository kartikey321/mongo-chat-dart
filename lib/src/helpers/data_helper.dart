// This file is part of the mongo_chat_dart package.
//
// Licensed under the BSD 3-Clause License. See the LICENSE file in the root directory
// of this source tree for more information.
import 'package:mongo_chat_dart/src/helpers/mongo_helper.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';
import 'package:mongo_chat_dart/src/models/chat_user.dart';
import 'package:mongo_chat_dart/src/models/data_filter.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class RangeParam {
  int? lowerBound;
  int? upperBound;
  RangeParam({this.lowerBound, this.upperBound})
      :
        // Assert that lowerBound, if not null, is positive
        assert(lowerBound == null || lowerBound >= 0,
            'lowerBound should be positive or null'),

        // Assert that upperBound, if not null, is positive
        assert(upperBound == null || upperBound >= 0,
            'upperBound should be positive or null'),

        // Assert that if both are not null, lowerBound is less than upperBound
        assert(
            lowerBound == null || upperBound == null || lowerBound < upperBound,
            'lowerBound should be less than upperBound when both are not null');
}

class SortParam {
  String field;
  bool descending;
  SortParam({required this.field, this.descending = false});
}

/// A generic controller for managing data models with MongoDB.
///
/// This controller provides basic CRUD operations (Create, Read, Update, Delete) for a generic data model [T].
/// It requires a MongoDB configuration and a collection name to interact with the database.
class GenericDataController<T extends DataModel> {
  final MongoHelper mongoHelper;
  final String collectionName;
  final Map<String, bool> indexes;
  final T Function(Map<String, dynamic> map) fromMap;

  /// Constructor for [GenericDataController].
  ///
  /// The [collectionName] parameter specifies the name of the MongoDB collection.
  /// The [fromMap] parameter is a function that converts a map to an instance of [T].
  /// The [mongoConfig] parameter provides the MongoDB configuration.
  GenericDataController({
    required this.collectionName,
    required this.fromMap,
    Map<String, bool>? index,
    required MongoConfig mongoConfig,
  })  : indexes = index ?? {},
        mongoHelper = MongoHelper(mongoConfig);

  createIndex() async => await mongoHelper.createIndex(collectionName, indexes);

  /// Converts a stream of dynamic objects to a stream of a list of [T] objects.
  ///
  /// The [sourceStream] parameter is the source stream of dynamic objects.
  /// The [fromMap] parameter is a function that converts a map to an instance of [T].
  Stream<List<T>> _convertStream(
    Stream<dynamic> sourceStream,
    T Function(Map<String, dynamic>) fromMap,
  ) async* {
    await for (var mapData in sourceStream) {
      List<T> convertedList = [];
      if (mapData is List) {
        for (var innerMap in mapData) {
          if (innerMap is Map<String, dynamic>) {
            convertedList.add(fromMap(innerMap));
          }
        }
      }
      yield convertedList;
    }
  }

  /// Adds a new document to the collection and returns its ObjectId.
  ///
  /// The [data] parameter is an instance of [T] to be added to the collection.
  /// Returns a [String] representing the ObjectId of the newly added document.
  Future<String> addData(T data, {String? docId}) async {
    try {
      mongo.ObjectId fieldKey = docId != null
          ? mongo.ObjectId.fromHexString(docId)
          : mongo.ObjectId();
      var dataMap = data.toMap();
      dataMap['_id'] = fieldKey;
      await mongoHelper.addData(collectionName, dataMap);
      return fieldKey.oid;
    } catch (e) {
      print('Failed to add data to $collectionName: $e');
      rethrow;
    }
  }

  /// Updates a document in the collection by its ID.
  ///
  /// The [update] parameter specifies the update operation.
  /// The [id] parameter is the ID of the document to update.
  Future<void> updateData(dynamic update, String id) async {
    try {
      await mongoHelper.updateDocument(collectionName, update, id);
    } catch (e) {
      print('Failed to update document in $collectionName: $e');
    }
  }

  /// Retrieves a list of documents from the collection based on optional filters.
  ///
  /// The [filters] parameter is an optional list of [DataFilterWrapper] objects to filter results.
  /// Returns a [Future] list of [T] representing the matching documents.
  Future<List<T>> getData(
      {List<DataFilterWrapper>? filters,
      SortParam? sort,
      RangeParam? range}) async {
    try {
      return mongoHelper
          .getData(collectionName, filters: filters, sort: sort, range: range)
          .then((value) => value.map((e) => fromMap(e)).toList());
    } catch (e) {
      print('Failed to retrieve data from $collectionName: $e');
      return [];
    }
  }

  /// Retrieves a list of documents from the collection by their IDs.
  ///
  /// The [ids] parameter is a list of document IDs to retrieve.
  /// The [searchQuery] parameter is an optional map for additional search criteria.
  /// Returns a [Future] list of [T] representing the matching documents.
  Future<List<T>> getDataFromIds(List<String> ids,
      {Map<String, String>? searchQuery}) async {
    return await getData(filters: [
      DataFilterWrapper(filterType: DataFilterWrapperType.and, filters: [
        DataFilter(
            fieldName: '_id',
            value: ids.map((e) => mongo.ObjectId.fromHexString(e)).toList(),
            filterType: DataFilterType.arrayContains),
        if (searchQuery != null)
          DataFilter(
              fieldName: searchQuery.keys.first,
              value: searchQuery.values.first,
              filterType: DataFilterType.regex)
      ])
    ]);
  }

  /// Retrieves a stream of documents from the collection by their IDs.
  ///
  /// The [ids] parameter is a list of document IDs to retrieve.
  /// The [searchQuery] parameter is an optional map for additional search criteria.
  /// Returns a [Stream] of lists of [T] representing the matching documents.
  Stream<List<T>> getDataStreamFromIds(List<String> ids,
      {Map<String, String>? searchQuery}) {
    return getDataStream(filters: [
      DataFilterWrapper(filterType: DataFilterWrapperType.and, filters: [
        DataFilter(
            fieldName: '_id',
            value: ids.map((e) => mongo.ObjectId.fromHexString(e)).toList(),
            filterType: DataFilterType.arrayContains),
        if (searchQuery != null)
          DataFilter(
              fieldName: searchQuery.keys.first,
              value: searchQuery.values.first,
              filterType: DataFilterType.regex)
      ])
    ]);
  }

  /// Retrieves a stream of documents from the collection based on optional filters.
  ///
  /// The [filters] parameter is an optional list of [DataFilterWrapper] objects to filter results.
  /// Returns a [Stream] of lists of [T] representing the matching documents.
  Stream<List<T>> getDataStream(
      {List<DataFilterWrapper>? filters, SortParam? sort, RangeParam? range}) {
    return _convertStream(
        mongoHelper.getDataStream(collectionName,
            filters: filters, sort: sort, range: range),
        fromMap);
  }

  /// Retrieves a single document from the collection by its ID.
  ///
  /// The [docId] parameter is the ID of the document to retrieve.
  /// Returns a [Future] instance of [T] representing the matching document, or `null` if not found.
  Future<T?> getSingleDocument(String docId) async {
    try {
      return mongoHelper
          .getSingleDocument(collectionName, docId)
          .then((value) => value != null ? fromMap(value) : null);
    } catch (e) {
      print('Failed to retrieve document from $collectionName: $e');
      return null;
    }
  }

  /// Retrieves a stream of a single document from the collection by its ID.
  ///
  /// The [docId] parameter is the ID of the document to retrieve.
  /// Returns a [Stream] of [T] representing the matching document.
  Stream<T?> getSingleDocumentStream(String docId) {
    return mongoHelper
        .getSingleDocumentStream(collectionName, docId)
        .map((data) => data != null ? fromMap(data) : null);
  }

  /// Deletes a document from the collection by its ID.
  ///
  /// The [fieldKey] parameter is the ID of the document to delete.
  Future<void> deleteDocument(String fieldKey) async {
    try {
      await mongoHelper.deleteDocument(collectionName, fieldKey);
    } catch (e) {
      print('Failed to delete document from $collectionName: $e');
    }
  }
}
