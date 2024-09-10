// This file is part of the mongo_chat_dart package.
// 
// Licensed under the BSD 3-Clause License. See the LICENSE file in the root directory
// of this source tree for more information.
import 'package:mongo_chat_dart/src/helpers/data_helper.dart';
import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';
import 'package:mongo_chat_dart/src/models/data_filter.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// A helper class for managing MongoDB operations.
/// It provides methods for CRUD operations, data streaming, filtering, sorting, and range limiting.
class MongoHelper {
  late Db _db;

  /// Constructor for initializing the MongoDB connection using the provided [MongoConfig].
  MongoHelper(MongoConfig mongoConfig) {
    _db = mongoConfig.getInstance();
  }

  /// Processes filters, sort parameters, and range limitations for MongoDB queries.
  /// This method generates a MongoDB query selector based on provided filters, sort parameters, and range.
  // ignore: non_constant_identifier_names
  SelectorBuilder? _processFilters_Sort_limit(
      {List<BasicDataFilter>? filters, SortParam? sort, RangeParam? range}) {
    /// Helper method to merge multiple selector builders based on [DataFilterWrapperType].
    SelectorBuilder? processBuilders(
            {required List<SelectorBuilder?> builders,
            required DataFilterWrapperType type}) =>
        builders.isEmpty
            ? null
            : builders.length < 2
                ? builders[0]
                : builders.sublist(1).fold(
                    builders[0],
                    (previousValue, element) => switch (type) {
                          DataFilterWrapperType.or =>
                            previousValue!.or(element!),
                          DataFilterWrapperType.and =>
                            previousValue!.and(element!),
                        });

    /// Processes individual filters based on their types and builds the selector accordingly.
    SelectorBuilder? processFilters(
        List<BasicDataFilter> filters, DataFilterWrapperType type,
        {SelectorBuilder? selectorBuilder}) {
      List<SelectorBuilder?> builders = [];

      if (filters.isEmpty) {
        return null;
      }

      // Handles DataFilterWrapper cases
      if (filters.every((e) => e is DataFilterWrapper)) {
        for (var e in filters) {
          if (e is DataFilterWrapper) {
            builders.add(processFilters(e.filters, e.filterType));
          }
        }
      }
      // Handles DataFilter cases
      else if (filters.every((e) => e is DataFilter)) {
        for (var e in filters) {
          e = e as DataFilter;
          builders.add(switch (e.filterType) {
            DataFilterType.isEqualTo => where.eq(e.fieldName, e.value),
            DataFilterType.isNotEqualTo => where.ne(e.fieldName, e.value),
            DataFilterType.isLessThan => where.lt(e.fieldName, e.value),
            DataFilterType.isLessThanOrEqualTo =>
              where.lte(e.fieldName, e.value),
            DataFilterType.isGreaterThan => where.gt(e.fieldName, e.value),
            DataFilterType.isGreaterThanOrEqualTo =>
              where.gte(e.fieldName, e.value),
            DataFilterType.arrayContains => where.oneFrom(e.fieldName, e.value),
            DataFilterType.regex => where.match(e.fieldName, e.value),
            DataFilterType.arrayContainsNone => where.nin(e.fieldName, e.value),
          });
        }
      }
      // Remove null builders
      builders.removeWhere((element) => element == null);
      return processBuilders(builders: builders, type: type);
    }

    // Initialize list of builders
    List<SelectorBuilder?> builders = [];

    // Process filters, if provided
    if (filters != null) {
      builders.add(processFilters(filters, DataFilterWrapperType.and));
    }

    // Apply sorting if provided
    if (sort != null) {
      builders.add(where.sortBy(sort.field, descending: sort.descending));
    }

    // Apply range (skip and limit) if provided
    if (range != null) {
      if (range.lowerBound != null) {
        builders.add(where.skip(range.lowerBound!));
      }
      if (range.upperBound != null) {
        builders.add(where.limit(range.upperBound!));
      }
    }

    // Return the processed filter
    var processedFilter =
        processBuilders(builders: builders, type: DataFilterWrapperType.and);
    return processedFilter;
  }

  /// Ensures that the MongoDB connection is active.
  Future<void> _checkDB() async {
    if (!_db.isConnected) {
      throw Exception('MongoDB is not initialized!');
    }
  }

  /// Creates an index for the given [collectionName] with specified [indexes].
  /// [indexes] is a map of field names and their uniqueness.
  Future<void> createIndex(
      String collectionName, Map<String, bool> indexes) async {
    await _checkDB();
    try {
      indexes.forEach((key, value) async =>
          await _db.createIndex(collectionName, key: key, unique: value));
    } catch (e) {
      print(e);
    }
  }

  /// Inserts [data] into the specified [collectionName].
  /// Returns the ID of the inserted document or null if an error occurs.
  Future<String?> addData(
      String collectionName, Map<String, dynamic> data) async {
    await _checkDB();
    try {
      var res = await _db.collection(collectionName).insertOne(data);

      if (res.hasWriteErrors) {
        throw Exception(res.writeError?.errmsg);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
    return null;
  }

  /// Retrieves data from the specified [collectionName] with optional [filters], [sort], and [range].
  /// Returns a list of documents.
  Future<List<Map<String, dynamic>>> getData(String collectionName,
      {List<DataFilterWrapper>? filters,
      SortParam? sort,
      RangeParam? range}) async {
    await _checkDB();
    var processedFilter = (filters != null && filters.isNotEmpty)
        ? _processFilters_Sort_limit(filters: filters, sort: sort, range: range)
        : null;
    if (sort != null) {
      if (processedFilter != null) {
        processedFilter =
            processedFilter.sortBy(sort.field, descending: sort.descending);
      }
    }
    return await _db.collection(collectionName).find(processedFilter).toList();
  }

  /// Streams data from the specified [collectionName] with optional [filters], [sort], and [range].
  /// Automatically updates the stream whenever there's a change in the collection.
  Stream<List<Map<String, dynamic>>> getDataStream(String collectionName,
      {List<DataFilterWrapper>? filters,
      SortParam? sort,
      RangeParam? range}) async* {
    await _checkDB();
    var processedFilter = (filters != null && filters.isNotEmpty)
        ? _processFilters_Sort_limit(filters: filters, sort: sort, range: range)
        : null;

    // Watch for changes in the collection
    var changeStream = _db.collection(collectionName).watch(
          processedFilter != null
              ? AggregationPipelineBuilder()
                  .addStage(Match(processedFilter.map))
              : AggregationPipelineBuilder(),
          changeStreamOptions:
              ChangeStreamOptions(fullDocument: 'updateLookup'),
        );

    // Yield initial data
    yield await _db.collection(collectionName).find(processedFilter).toList();

    // Listen for changes and update the stream
    await for (var change in changeStream) {
      if (['insert', 'update', 'delete', 'replace']
          .contains(change.operationType)) {
        var updatedData = await getData(collectionName, filters: filters);
        yield updatedData;
      }
    }
  }

  /// Updates a document in the [collectionName] identified by [id] with the provided [update] data.
  Future<void> updateDocument(
      String collectionName, dynamic update, String id) async {
    _db
        .collection(collectionName)
        .update(where.id(ObjectId.fromHexString(id)), update);
  }

  /// Retrieves a single document from the [collectionName] by its [docId].
  Future<Map<String, dynamic>?> getSingleDocument(
      String collectionName, String docId) async {
    print(collectionName);
    print(ObjectId.isValidHexId(docId));
    var res = await _db
        .collection(collectionName)
        .findOne(where.id(ObjectId.fromHexString(docId)));
    print(res);
    return res;
  }

  /// Streams a single document from the [collectionName] by its [docId].
  /// Automatically updates the stream whenever the document is modified.
  Stream<Map<String, dynamic>?> getSingleDocumentStream(
      String collectionName, String docId) async* {
    await _checkDB();

    // Verify if the provided docId is a valid ObjectId
    if (!ObjectId.isValidHexId(docId)) {
      throw ArgumentError('Invalid ObjectId: $docId');
    }

    final objectId = ObjectId.fromHexString(docId);

    // Create a change stream to watch for changes to the specific document
    var changeStream = _db.collection(collectionName).watch(
          AggregationPipelineBuilder()
              .addStage(Match(where.eq('_id', objectId).map)),
          changeStreamOptions:
              ChangeStreamOptions(fullDocument: 'updateLookup'),
        );

    // Yield the initial state of the document
    var initialDocument = await _db.collection(collectionName).findOne(
          where.id(objectId),
        );
    yield initialDocument;

    // Listen to changes and yield the updated document
    await for (var change in changeStream) {
      if (['insert', 'update', 'delete', 'replace']
          .contains(change.operationType)) {
        var updatedDocument = await getSingleDocument(collectionName, docId);
        yield updatedDocument;
      }
    }
  }

  /// Deletes a document from the [collectionName] identified by [id].
  /// Returns true if the deletion was successful, false otherwise.
  Future<bool> deleteDocument(String collectionName, String id) async {
    await _checkDB();

    // Verify if the provided id is a valid ObjectId
    if (!ObjectId.isValidHexId(id)) {
      throw ArgumentError('Invalid ObjectId: $id');
    }

    final objectId = ObjectId.fromHexString(id);

    try {
      var result =
          await _db.collection(collectionName).deleteOne(where.id(objectId));

      // Return true if the deletion was successful
      return result.isSuccess;
    } catch (e) {
      print('Error deleting document: $e');
      return false;
    }
  }
}
