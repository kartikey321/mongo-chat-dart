import 'package:mongo_chat_dart/src/models/data_filter.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoHelper {
  late Db db;
  MongoHelper(String mongoUrl) {
    db = Db(mongoUrl);
  }
  SelectorBuilder? _processFilters(
      List<BasicDataFilter> filters, DataFilterWrapperType type,
      {SelectorBuilder? selectorBuilder}) {
    List<SelectorBuilder?> builders = [];
    if (filters.isEmpty) {
      return null;
    }
    print(filters.runtimeType);
    if (filters.every((e) => e is List<DataFilterWrapper>)) {
      for (var e in filters) {
        if (e is DataFilterWrapper) {
          builders.add(_processFilters(e.filters, e.filterType));
        }
      }
    } else if (filters.every((e) => e is List<DataFilter>)) {
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
    builders.removeWhere((element) => element == null);
    return builders.length < 2
        ? builders[0]
        : builders.sublist(1).fold(
            builders[0],
            (previousValue, element) => switch (type) {
                  DataFilterWrapperType.or => previousValue!.or(element!),
                  DataFilterWrapperType.and => previousValue!.and(element!),
                });
  }

  initialize() async {
    await db.open();
  }

  Future<void> _checkDB() async {
    if (!db.isConnected) {
      initialize();
    }
  }

  Future<void> addData(String collectionName, Map<String, dynamic> data) async {
    await _checkDB();
    try {
      var res = await db.collection(collectionName).insertOne(data);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> getData(
      String collectionName, List<DataFilterWrapper>? filters) async {
    await _checkDB();
    var processedFilter = (filters != null && filters.isNotEmpty)
        ? _processFilters(filters, DataFilterWrapperType.and)
        : null;
    return await db.collection(collectionName).find(processedFilter).toList();
  }

  Stream<dynamic> getDataStream(String collectionName,
      {List<DataFilterWrapper>? filters}) {
    var processedFilter = (filters != null && filters.isNotEmpty)
        ? _processFilters(filters, DataFilterWrapperType.and)
        : null;
    return db.collection(collectionName).find(processedFilter);
  }

  Future<Map<String, dynamic>?> getSingleDocument(
      String collectionName, String docId) async {
    var res =
        db.collection(collectionName).findOne(where.id(ObjectId.parse(docId)));
    return res;
  }

  Stream<Map<String, dynamic>> getSingleDocumentStream(
      String collectionName, String docId) {
    var res =
        db.collection(collectionName).find(where.id(ObjectId.parse(docId)));
    return res;
  }

  Future<void> deleteDocument(String collectionName, String docId) async {
    await db
        .collection(collectionName)
        .deleteOne(where.id(ObjectId.parse(docId)));
  }
}
