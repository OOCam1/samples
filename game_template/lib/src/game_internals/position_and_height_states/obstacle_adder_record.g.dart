// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obstacle_adder_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetObstacleAdderRecordCollection on Isar {
  IsarCollection<ObstacleAdderRecord> get obstacleAdderRecords =>
      this.collection();
}

const ObstacleAdderRecordSchema = CollectionSchema(
  name: r'ObstacleAdderRecord',
  id: 9176959553776390845,
  properties: {
    r'downYPositions': PropertySchema(
      id: 0,
      name: r'downYPositions',
      type: IsarType.longList,
    ),
    r'leftXPositions': PropertySchema(
      id: 1,
      name: r'leftXPositions',
      type: IsarType.longList,
    ),
    r'rightXPositions': PropertySchema(
      id: 2,
      name: r'rightXPositions',
      type: IsarType.longList,
    ),
    r'upYPositions': PropertySchema(
      id: 3,
      name: r'upYPositions',
      type: IsarType.longList,
    )
  },
  estimateSize: _obstacleAdderRecordEstimateSize,
  serialize: _obstacleAdderRecordSerialize,
  deserialize: _obstacleAdderRecordDeserialize,
  deserializeProp: _obstacleAdderRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _obstacleAdderRecordGetId,
  getLinks: _obstacleAdderRecordGetLinks,
  attach: _obstacleAdderRecordAttach,
  version: '3.1.0+1',
);

int _obstacleAdderRecordEstimateSize(
  ObstacleAdderRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.downYPositions;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.leftXPositions;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.rightXPositions;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.upYPositions;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  return bytesCount;
}

void _obstacleAdderRecordSerialize(
  ObstacleAdderRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.downYPositions);
  writer.writeLongList(offsets[1], object.leftXPositions);
  writer.writeLongList(offsets[2], object.rightXPositions);
  writer.writeLongList(offsets[3], object.upYPositions);
}

ObstacleAdderRecord _obstacleAdderRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ObstacleAdderRecord();
  object.downYPositions = reader.readLongList(offsets[0]);
  object.id = id;
  object.leftXPositions = reader.readLongList(offsets[1]);
  object.rightXPositions = reader.readLongList(offsets[2]);
  object.upYPositions = reader.readLongList(offsets[3]);
  return object;
}

P _obstacleAdderRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset)) as P;
    case 1:
      return (reader.readLongList(offset)) as P;
    case 2:
      return (reader.readLongList(offset)) as P;
    case 3:
      return (reader.readLongList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _obstacleAdderRecordGetId(ObstacleAdderRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _obstacleAdderRecordGetLinks(
    ObstacleAdderRecord object) {
  return [];
}

void _obstacleAdderRecordAttach(
    IsarCollection<dynamic> col, Id id, ObstacleAdderRecord object) {
  object.id = id;
}

extension ObstacleAdderRecordQueryWhereSort
    on QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QWhere> {
  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ObstacleAdderRecordQueryWhere
    on QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QWhereClause> {
  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterWhereClause>
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

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterWhereClause>
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

extension ObstacleAdderRecordQueryFilter on QueryBuilder<ObstacleAdderRecord,
    ObstacleAdderRecord, QFilterCondition> {
  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'downYPositions',
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'downYPositions',
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downYPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downYPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downYPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downYPositions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'downYPositions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'downYPositions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'downYPositions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'downYPositions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'downYPositions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      downYPositionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'downYPositions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
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

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
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

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
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

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'leftXPositions',
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'leftXPositions',
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leftXPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leftXPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leftXPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leftXPositions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leftXPositions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leftXPositions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leftXPositions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leftXPositions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leftXPositions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      leftXPositionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leftXPositions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rightXPositions',
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rightXPositions',
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rightXPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rightXPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rightXPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rightXPositions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rightXPositions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rightXPositions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rightXPositions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rightXPositions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rightXPositions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      rightXPositionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rightXPositions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'upYPositions',
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'upYPositions',
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'upYPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'upYPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'upYPositions',
        value: value,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'upYPositions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upYPositions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upYPositions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upYPositions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upYPositions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upYPositions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterFilterCondition>
      upYPositionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'upYPositions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ObstacleAdderRecordQueryObject on QueryBuilder<ObstacleAdderRecord,
    ObstacleAdderRecord, QFilterCondition> {}

extension ObstacleAdderRecordQueryLinks on QueryBuilder<ObstacleAdderRecord,
    ObstacleAdderRecord, QFilterCondition> {}

extension ObstacleAdderRecordQuerySortBy
    on QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QSortBy> {}

extension ObstacleAdderRecordQuerySortThenBy
    on QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QSortThenBy> {
  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ObstacleAdderRecordQueryWhereDistinct
    on QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QDistinct> {
  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QDistinct>
      distinctByDownYPositions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downYPositions');
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QDistinct>
      distinctByLeftXPositions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leftXPositions');
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QDistinct>
      distinctByRightXPositions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rightXPositions');
    });
  }

  QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QDistinct>
      distinctByUpYPositions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'upYPositions');
    });
  }
}

extension ObstacleAdderRecordQueryProperty
    on QueryBuilder<ObstacleAdderRecord, ObstacleAdderRecord, QQueryProperty> {
  QueryBuilder<ObstacleAdderRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ObstacleAdderRecord, List<int>?, QQueryOperations>
      downYPositionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downYPositions');
    });
  }

  QueryBuilder<ObstacleAdderRecord, List<int>?, QQueryOperations>
      leftXPositionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leftXPositions');
    });
  }

  QueryBuilder<ObstacleAdderRecord, List<int>?, QQueryOperations>
      rightXPositionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rightXPositions');
    });
  }

  QueryBuilder<ObstacleAdderRecord, List<int>?, QQueryOperations>
      upYPositionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'upYPositions');
    });
  }
}
