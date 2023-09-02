// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'positioned_building_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPositionedBuildingRecordCollection on Isar {
  IsarCollection<PositionedBuildingRecord> get positionedBuildingRecords =>
      this.collection();
}

const PositionedBuildingRecordSchema = CollectionSchema(
  name: r'PositionedBuildingRecord',
  id: 127219079478823485,
  properties: {
    r'x': PropertySchema(
      id: 0,
      name: r'x',
      type: IsarType.long,
    ),
    r'y': PropertySchema(
      id: 1,
      name: r'y',
      type: IsarType.long,
    )
  },
  estimateSize: _positionedBuildingRecordEstimateSize,
  serialize: _positionedBuildingRecordSerialize,
  deserialize: _positionedBuildingRecordDeserialize,
  deserializeProp: _positionedBuildingRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'buildingRecord': LinkSchema(
      id: 7129305407711639514,
      name: r'buildingRecord',
      target: r'BuildingIsarRecord',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _positionedBuildingRecordGetId,
  getLinks: _positionedBuildingRecordGetLinks,
  attach: _positionedBuildingRecordAttach,
  version: '3.1.0+1',
);

int _positionedBuildingRecordEstimateSize(
  PositionedBuildingRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _positionedBuildingRecordSerialize(
  PositionedBuildingRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.x);
  writer.writeLong(offsets[1], object.y);
}

PositionedBuildingRecord _positionedBuildingRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PositionedBuildingRecord();
  object.id = id;
  object.x = reader.readLongOrNull(offsets[0]);
  object.y = reader.readLongOrNull(offsets[1]);
  return object;
}

P _positionedBuildingRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _positionedBuildingRecordGetId(PositionedBuildingRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _positionedBuildingRecordGetLinks(
    PositionedBuildingRecord object) {
  return [object.buildingRecord];
}

void _positionedBuildingRecordAttach(
    IsarCollection<dynamic> col, Id id, PositionedBuildingRecord object) {
  object.id = id;
  object.buildingRecord.attach(
      col, col.isar.collection<BuildingIsarRecord>(), r'buildingRecord', id);
}

extension PositionedBuildingRecordQueryWhereSort on QueryBuilder<
    PositionedBuildingRecord, PositionedBuildingRecord, QWhere> {
  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PositionedBuildingRecordQueryWhere on QueryBuilder<
    PositionedBuildingRecord, PositionedBuildingRecord, QWhereClause> {
  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterWhereClause> idBetween(
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

extension PositionedBuildingRecordQueryFilter on QueryBuilder<
    PositionedBuildingRecord, PositionedBuildingRecord, QFilterCondition> {
  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> xIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'x',
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> xIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'x',
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> xEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'x',
        value: value,
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> xGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'x',
        value: value,
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> xLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'x',
        value: value,
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> xBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'x',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> yIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'y',
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> yIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'y',
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> yEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'y',
        value: value,
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> yGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'y',
        value: value,
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> yLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'y',
        value: value,
      ));
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> yBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'y',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PositionedBuildingRecordQueryObject on QueryBuilder<
    PositionedBuildingRecord, PositionedBuildingRecord, QFilterCondition> {}

extension PositionedBuildingRecordQueryLinks on QueryBuilder<
    PositionedBuildingRecord, PositionedBuildingRecord, QFilterCondition> {
  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> buildingRecord(FilterQuery<BuildingIsarRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'buildingRecord');
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord,
      QAfterFilterCondition> buildingRecordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'buildingRecord', 0, true, 0, true);
    });
  }
}

extension PositionedBuildingRecordQuerySortBy on QueryBuilder<
    PositionedBuildingRecord, PositionedBuildingRecord, QSortBy> {
  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QAfterSortBy>
      sortByX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'x', Sort.asc);
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QAfterSortBy>
      sortByXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'x', Sort.desc);
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QAfterSortBy>
      sortByY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'y', Sort.asc);
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QAfterSortBy>
      sortByYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'y', Sort.desc);
    });
  }
}

extension PositionedBuildingRecordQuerySortThenBy on QueryBuilder<
    PositionedBuildingRecord, PositionedBuildingRecord, QSortThenBy> {
  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QAfterSortBy>
      thenByX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'x', Sort.asc);
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QAfterSortBy>
      thenByXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'x', Sort.desc);
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QAfterSortBy>
      thenByY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'y', Sort.asc);
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QAfterSortBy>
      thenByYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'y', Sort.desc);
    });
  }
}

extension PositionedBuildingRecordQueryWhereDistinct on QueryBuilder<
    PositionedBuildingRecord, PositionedBuildingRecord, QDistinct> {
  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QDistinct>
      distinctByX() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'x');
    });
  }

  QueryBuilder<PositionedBuildingRecord, PositionedBuildingRecord, QDistinct>
      distinctByY() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'y');
    });
  }
}

extension PositionedBuildingRecordQueryProperty on QueryBuilder<
    PositionedBuildingRecord, PositionedBuildingRecord, QQueryProperty> {
  QueryBuilder<PositionedBuildingRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PositionedBuildingRecord, int?, QQueryOperations> xProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'x');
    });
  }

  QueryBuilder<PositionedBuildingRecord, int?, QQueryOperations> yProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'y');
    });
  }
}
