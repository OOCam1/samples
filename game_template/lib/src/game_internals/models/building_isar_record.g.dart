// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_isar_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBuildingIsarRecordCollection on Isar {
  IsarCollection<BuildingIsarRecord> get buildingIsarRecords =>
      this.collection();
}

const BuildingIsarRecordSchema = CollectionSchema(
  name: r'BuildingIsarRecord',
  id: -5695563226860927389,
  properties: {
    r'artistId': PropertySchema(
      id: 0,
      name: r'artistId',
      type: IsarType.string,
    ),
    r'artistName': PropertySchema(
      id: 1,
      name: r'artistName',
      type: IsarType.string,
    ),
    r'genreNames': PropertySchema(
      id: 2,
      name: r'genreNames',
      type: IsarType.stringList,
    ),
    r'score': PropertySchema(
      id: 3,
      name: r'score',
      type: IsarType.double,
    )
  },
  estimateSize: _buildingIsarRecordEstimateSize,
  serialize: _buildingIsarRecordSerialize,
  deserialize: _buildingIsarRecordDeserialize,
  deserializeProp: _buildingIsarRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _buildingIsarRecordGetId,
  getLinks: _buildingIsarRecordGetLinks,
  attach: _buildingIsarRecordAttach,
  version: '3.1.0+1',
);

int _buildingIsarRecordEstimateSize(
  BuildingIsarRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.artistId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.artistName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.genreNames;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _buildingIsarRecordSerialize(
  BuildingIsarRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.artistId);
  writer.writeString(offsets[1], object.artistName);
  writer.writeStringList(offsets[2], object.genreNames);
  writer.writeDouble(offsets[3], object.score);
}

BuildingIsarRecord _buildingIsarRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BuildingIsarRecord();
  object.artistId = reader.readStringOrNull(offsets[0]);
  object.artistName = reader.readStringOrNull(offsets[1]);
  object.genreNames = reader.readStringList(offsets[2]);
  object.id = id;
  object.score = reader.readDoubleOrNull(offsets[3]);
  return object;
}

P _buildingIsarRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringList(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _buildingIsarRecordGetId(BuildingIsarRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _buildingIsarRecordGetLinks(
    BuildingIsarRecord object) {
  return [];
}

void _buildingIsarRecordAttach(
    IsarCollection<dynamic> col, Id id, BuildingIsarRecord object) {
  object.id = id;
}

extension BuildingIsarRecordQueryWhereSort
    on QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QWhere> {
  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BuildingIsarRecordQueryWhere
    on QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QWhereClause> {
  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterWhereClause>
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

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterWhereClause>
      idBetween(
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

extension BuildingIsarRecordQueryFilter
    on QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QFilterCondition> {
  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'artistId',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'artistId',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'artistId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'artistId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistId',
        value: '',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'artistId',
        value: '',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'artistName',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'artistName',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'artistName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'artistName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistName',
        value: '',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      artistNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'artistName',
        value: '',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'genreNames',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'genreNames',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'genreNames',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'genreNames',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'genreNames',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genreNames',
        value: '',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'genreNames',
        value: '',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      genreNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
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

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
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

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
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

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      scoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'score',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      scoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'score',
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      scoreEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'score',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      scoreGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'score',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      scoreLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'score',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterFilterCondition>
      scoreBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension BuildingIsarRecordQueryObject
    on QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QFilterCondition> {}

extension BuildingIsarRecordQueryLinks
    on QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QFilterCondition> {}

extension BuildingIsarRecordQuerySortBy
    on QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QSortBy> {
  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      sortByArtistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.asc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      sortByArtistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.desc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      sortByArtistName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.asc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      sortByArtistNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.desc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }
}

extension BuildingIsarRecordQuerySortThenBy
    on QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QSortThenBy> {
  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      thenByArtistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.asc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      thenByArtistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.desc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      thenByArtistName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.asc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      thenByArtistNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.desc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QAfterSortBy>
      thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }
}

extension BuildingIsarRecordQueryWhereDistinct
    on QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QDistinct> {
  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QDistinct>
      distinctByArtistId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artistId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QDistinct>
      distinctByArtistName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artistName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QDistinct>
      distinctByGenreNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genreNames');
    });
  }

  QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QDistinct>
      distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }
}

extension BuildingIsarRecordQueryProperty
    on QueryBuilder<BuildingIsarRecord, BuildingIsarRecord, QQueryProperty> {
  QueryBuilder<BuildingIsarRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BuildingIsarRecord, String?, QQueryOperations>
      artistIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artistId');
    });
  }

  QueryBuilder<BuildingIsarRecord, String?, QQueryOperations>
      artistNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artistName');
    });
  }

  QueryBuilder<BuildingIsarRecord, List<String>?, QQueryOperations>
      genreNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genreNames');
    });
  }

  QueryBuilder<BuildingIsarRecord, double?, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }
}
