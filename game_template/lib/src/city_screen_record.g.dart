// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_screen_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCityScreenRecordCollection on Isar {
  IsarCollection<CityScreenRecord> get cityScreenRecords => this.collection();
}

const CityScreenRecordSchema = CollectionSchema(
  name: r'CityScreenRecord',
  id: -3090783001995214858,
  properties: {
    r'blue': PropertySchema(
      id: 0,
      name: r'blue',
      type: IsarType.long,
    ),
    r'genreName': PropertySchema(
      id: 1,
      name: r'genreName',
      type: IsarType.string,
    ),
    r'green': PropertySchema(
      id: 2,
      name: r'green',
      type: IsarType.long,
    ),
    r'opacity': PropertySchema(
      id: 3,
      name: r'opacity',
      type: IsarType.double,
    ),
    r'red': PropertySchema(
      id: 4,
      name: r'red',
      type: IsarType.long,
    )
  },
  estimateSize: _cityScreenRecordEstimateSize,
  serialize: _cityScreenRecordSerialize,
  deserialize: _cityScreenRecordDeserialize,
  deserializeProp: _cityScreenRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _cityScreenRecordGetId,
  getLinks: _cityScreenRecordGetLinks,
  attach: _cityScreenRecordAttach,
  version: '3.1.0+1',
);

int _cityScreenRecordEstimateSize(
  CityScreenRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.genreName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _cityScreenRecordSerialize(
  CityScreenRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.blue);
  writer.writeString(offsets[1], object.genreName);
  writer.writeLong(offsets[2], object.green);
  writer.writeDouble(offsets[3], object.opacity);
  writer.writeLong(offsets[4], object.red);
}

CityScreenRecord _cityScreenRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CityScreenRecord();
  object.blue = reader.readLongOrNull(offsets[0]);
  object.genreName = reader.readStringOrNull(offsets[1]);
  object.green = reader.readLongOrNull(offsets[2]);
  object.id = id;
  object.opacity = reader.readDoubleOrNull(offsets[3]);
  object.red = reader.readLongOrNull(offsets[4]);
  return object;
}

P _cityScreenRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cityScreenRecordGetId(CityScreenRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cityScreenRecordGetLinks(CityScreenRecord object) {
  return [];
}

void _cityScreenRecordAttach(
    IsarCollection<dynamic> col, Id id, CityScreenRecord object) {
  object.id = id;
}

extension CityScreenRecordQueryWhereSort
    on QueryBuilder<CityScreenRecord, CityScreenRecord, QWhere> {
  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CityScreenRecordQueryWhere
    on QueryBuilder<CityScreenRecord, CityScreenRecord, QWhereClause> {
  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CityScreenRecordQueryFilter
    on QueryBuilder<CityScreenRecord, CityScreenRecord, QFilterCondition> {
  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      blueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blue',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      blueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blue',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      blueEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blue',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      blueGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blue',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      blueLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blue',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      blueBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'genreName',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'genreName',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'genreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'genreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'genreName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'genreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'genreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'genreName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'genreName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genreName',
        value: '',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      genreNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'genreName',
        value: '',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      greenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'green',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      greenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'green',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      greenEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'green',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      greenGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'green',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      greenLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'green',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      greenBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'green',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      opacityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'opacity',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      opacityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'opacity',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      opacityEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'opacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      opacityGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'opacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      opacityLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'opacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      opacityBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'opacity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      redIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'red',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      redIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'red',
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      redEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'red',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      redGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'red',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      redLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'red',
        value: value,
      ));
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterFilterCondition>
      redBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'red',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CityScreenRecordQueryObject
    on QueryBuilder<CityScreenRecord, CityScreenRecord, QFilterCondition> {}

extension CityScreenRecordQueryLinks
    on QueryBuilder<CityScreenRecord, CityScreenRecord, QFilterCondition> {}

extension CityScreenRecordQuerySortBy
    on QueryBuilder<CityScreenRecord, CityScreenRecord, QSortBy> {
  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy> sortByBlue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blue', Sort.asc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      sortByBlueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blue', Sort.desc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      sortByGenreName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'genreName', Sort.asc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      sortByGenreNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'genreName', Sort.desc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy> sortByGreen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'green', Sort.asc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      sortByGreenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'green', Sort.desc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      sortByOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opacity', Sort.asc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      sortByOpacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opacity', Sort.desc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy> sortByRed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'red', Sort.asc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      sortByRedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'red', Sort.desc);
    });
  }
}

extension CityScreenRecordQuerySortThenBy
    on QueryBuilder<CityScreenRecord, CityScreenRecord, QSortThenBy> {
  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy> thenByBlue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blue', Sort.asc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      thenByBlueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blue', Sort.desc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      thenByGenreName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'genreName', Sort.asc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      thenByGenreNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'genreName', Sort.desc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy> thenByGreen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'green', Sort.asc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      thenByGreenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'green', Sort.desc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      thenByOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opacity', Sort.asc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      thenByOpacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'opacity', Sort.desc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy> thenByRed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'red', Sort.asc);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QAfterSortBy>
      thenByRedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'red', Sort.desc);
    });
  }
}

extension CityScreenRecordQueryWhereDistinct
    on QueryBuilder<CityScreenRecord, CityScreenRecord, QDistinct> {
  QueryBuilder<CityScreenRecord, CityScreenRecord, QDistinct> distinctByBlue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blue');
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QDistinct>
      distinctByGenreName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genreName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QDistinct>
      distinctByGreen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'green');
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QDistinct>
      distinctByOpacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'opacity');
    });
  }

  QueryBuilder<CityScreenRecord, CityScreenRecord, QDistinct> distinctByRed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'red');
    });
  }
}

extension CityScreenRecordQueryProperty
    on QueryBuilder<CityScreenRecord, CityScreenRecord, QQueryProperty> {
  QueryBuilder<CityScreenRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CityScreenRecord, int?, QQueryOperations> blueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blue');
    });
  }

  QueryBuilder<CityScreenRecord, String?, QQueryOperations>
      genreNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genreName');
    });
  }

  QueryBuilder<CityScreenRecord, int?, QQueryOperations> greenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'green');
    });
  }

  QueryBuilder<CityScreenRecord, double?, QQueryOperations> opacityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'opacity');
    });
  }

  QueryBuilder<CityScreenRecord, int?, QQueryOperations> redProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'red');
    });
  }
}
