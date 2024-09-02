import 'package:mongo_chat_dart/src/helpers/mongo_setup.dart';
import 'package:mongo_chat_dart/src/models/data_filter.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoHelper {
  late Db _db;
  MongoHelper(MongoConfig mongoConfig) {
    _db = mongoConfig.getInstance();
  }
  SelectorBuilder? _processFilters(
      List<BasicDataFilter> filters, DataFilterWrapperType type,
      {SelectorBuilder? selectorBuilder}) {
    List<SelectorBuilder?> builders = [];

    if (filters.isEmpty) {
      return null;
    }
    print(filters.runtimeType);
    if (filters.every((e) => e is DataFilterWrapper)) {
      for (var e in filters) {
        if (e is DataFilterWrapper) {
          builders.add(_processFilters(e.filters, e.filterType));
        }
      }
    } else if (filters.every((e) => e is DataFilter)) {
      for (var e in filters) {
        e = e as DataFilter;
        builders.add(switch (e.filterType) {
          DataFilterType.isEqualTo => where.eq(e.fieldName, e.value),
          DataFilterType.isNotEqualTo => where.ne(e.fieldName, e.value),
          DataFilterType.isLessThan => where.lt(e.fieldName, e.value),
          DataFilterType.isLessThanOrEqualTo => where.lte(e.fieldName, e.value),
          DataFilterType.isGreaterThan => where.gt(e.fieldName, e.value),
          DataFilterType.isGreaterThanOrEqualTo =>
            where.gte(e.fieldName, e.value),
          DataFilterType.arrayContains => where.oneFrom(e.fieldName, e.value),
          DataFilterType.regex => where.match(e.fieldName, e.value),
          DataFilterType.arrayContainsNone => where.nin(e.fieldName, e.value),
        });
      }
    }
    print('builders: ${builders.map((e) => e?.map.toString())}');
    builders.removeWhere((element) => element == null);
    return builders.isEmpty
        ? null
        : builders.length < 2
            ? builders[0]
            : builders.sublist(1).fold(
                builders[0],
                (previousValue, element) => switch (type) {
                      DataFilterWrapperType.or => previousValue!.or(element!),
                      DataFilterWrapperType.and => previousValue!.and(element!),
                    });
  }

  Future<void> _checkDB() async {
    if (!_db.isConnected) {
      throw Exception('Mongo db isnt initialized!');
    }
  }

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

  Future<String?> addData(
      String collectionName, Map<String, dynamic> data) async {
    await _checkDB();
    try {
      var res = await _db.collection(collectionName).insertOne(data);
      
      if(res.hasWriteErrors){
        throw Exception(res.writeError?.errmsg);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getData(String collectionName,
      {List<DataFilterWrapper>? filters}) async {
    await _checkDB();
    var processedFilter = (filters != null && filters.isNotEmpty)
        ? _processFilters(filters, DataFilterWrapperType.and)
        : null;
    return await _db.collection(collectionName).find(processedFilter).toList();
  }

  Stream<dynamic> getDataStream(String collectionName,
      {List<DataFilterWrapper>? filters}) async* {
    var processedFilter = (filters != null && filters.isNotEmpty)
        ? _processFilters(filters, DataFilterWrapperType.and)
        : null;
    print(processedFilter);
    var res = _db.collection(collectionName).find(processedFilter);
    print(res);
    yield* res;
  }

  Future<void> updateDocument(
      String collectionName, dynamic update, String id) async {
    _db
        .collection(collectionName)
        .update(where.id(ObjectId.fromHexString(id)), update);
  }

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

  Stream<Map<String, dynamic>> getSingleDocumentStream(
      String collectionName, String docId) {
    var res = _db
        .collection(collectionName)
        .find(where.id(ObjectId.fromHexString(docId)));
    return res;
  }

  Future<void> deleteDocument(String collectionName, String docId) async {
    await _db
        .collection(collectionName)
        .deleteOne(where.id(ObjectId.fromHexString(docId)));
  }
}
