import 'dart:convert';

abstract class BasicDataFilter {}

enum DataFilterType {
  isEqualTo,
  isNotEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  arrayContains,
  arrayContainsNone,
  regex
}

class DataFilter extends BasicDataFilter {
  String fieldName;
  dynamic value;
  DataFilterType filterType;
  DataFilter({
    required this.fieldName,
    required this.value,
    required this.filterType,
  });

  DataFilter copyWith({
    String? fieldName,
    dynamic? value,
    DataFilterType? filterType,
  }) {
    return DataFilter(
      fieldName: fieldName ?? this.fieldName,
      value: value ?? this.value,
      filterType: filterType ?? this.filterType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fieldName': fieldName,
      'value': value,
      'filterType': filterType.index,
    };
  }

  factory DataFilter.fromMap(Map<String, dynamic> map) {
    return DataFilter(
      fieldName: map['fieldName'] as String,
      value: map['value'] as dynamic,
      filterType: DataFilterType.values[map['filterType'] as int],
    );
  }

  String toJson() => json.encode(toMap());

  factory DataFilter.fromJson(String source) =>
      DataFilter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DataFilter(fieldName: $fieldName, value: $value, filterType: $filterType)';

  @override
  bool operator ==(covariant DataFilter other) {
    if (identical(this, other)) return true;

    return other.fieldName == fieldName &&
        other.value == value &&
        other.filterType == filterType;
  }

  @override
  int get hashCode => fieldName.hashCode ^ value.hashCode ^ filterType.hashCode;
}

enum DataFilterWrapperType {
  or,
  and,
}

class DataFilterWrapper extends BasicDataFilter {
  DataFilterWrapperType filterType;
  List<BasicDataFilter> filters;

  DataFilterWrapper({required this.filterType, required this.filters});
}
