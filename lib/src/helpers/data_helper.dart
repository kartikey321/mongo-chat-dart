import 'package:mongo_chat_dart/src/helpers/mongo_helper.dart';
import 'package:mongo_chat_dart/src/models/data_filter.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class DataHelper<T> {
  MongoHelper mongoHelper;
  String collectionName;
  final T Function(Map<String, dynamic> map) fromMap;
  final Map<String, dynamic> Function(T data) toMap;
  DataHelper(
      {required this.collectionName,
      required this.fromMap,
      required this.toMap,
      required this.mongoHelper});
  Stream<List<T>> _convertStream(
    Stream<dynamic> sourceStream,
    T Function(Map<String, dynamic>) fromMap,
  ) async* {
    sourceStream = sourceStream as Stream<List<dynamic>>;
    await for (var mapData in sourceStream) {
      List<T> convertedList = [];
      for (var innerMap in mapData) {
        convertedList.add(fromMap(innerMap));
      }
      yield convertedList;
    }
  }

  Future<mongo.ObjectId> addData(T data) async {
    mongo.ObjectId fieldKey = mongo.ObjectId();
    await mongoHelper.addData(collectionName, toMap(data));
    return fieldKey;
  }

  Future<List<T>> getData({List<DataFilterWrapper>? filters}) async =>
      mongoHelper
          .getData(collectionName, filters: filters)
          .then((value) => value.map((e) => fromMap(e)).toList());
  Stream<List<T>> getDataStream({List<DataFilterWrapper>? filters}) =>
      _convertStream(
          mongoHelper.getDataStream(collectionName, filters: filters), fromMap);

  Future<T?> getSingleDocument(String docId) async => mongoHelper
      .getSingleDocument(collectionName, docId)
      .then((value) => value != null ? fromMap(value) : null);
  Stream<T?> getSingleDocumentStream(String docId) => mongoHelper
      .getSingleDocumentStream(collectionName, docId)
      .map((data) => fromMap(data));

  Future<void> deleteDocument(String fieldKey) async =>
      await mongoHelper.deleteDocument(collectionName, fieldKey);
}
