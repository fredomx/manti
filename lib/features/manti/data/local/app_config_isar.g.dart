// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppConfigIsarCollection on Isar {
  IsarCollection<AppConfigIsar> get appConfigIsars => this.collection();
}

const AppConfigIsarSchema = CollectionSchema(
  name: r'AppConfigIsar',
  id: 8416701394798332806,
  properties: {
    r'completedTipIndices': PropertySchema(
      id: 0,
      name: r'completedTipIndices',
      type: IsarType.longList,
    ),
    r'hasSeededMantiItems': PropertySchema(
      id: 1,
      name: r'hasSeededMantiItems',
      type: IsarType.bool,
    )
  },
  estimateSize: _appConfigIsarEstimateSize,
  serialize: _appConfigIsarSerialize,
  deserialize: _appConfigIsarDeserialize,
  deserializeProp: _appConfigIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appConfigIsarGetId,
  getLinks: _appConfigIsarGetLinks,
  attach: _appConfigIsarAttach,
  version: '3.1.0+1',
);

int _appConfigIsarEstimateSize(
  AppConfigIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.completedTipIndices.length * 8;
  return bytesCount;
}

void _appConfigIsarSerialize(
  AppConfigIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.completedTipIndices);
  writer.writeBool(offsets[1], object.hasSeededMantiItems);
}

AppConfigIsar _appConfigIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppConfigIsar();
  object.completedTipIndices = reader.readLongList(offsets[0]) ?? [];
  object.hasSeededMantiItems = reader.readBool(offsets[1]);
  object.id = id;
  return object;
}

P _appConfigIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appConfigIsarGetId(AppConfigIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appConfigIsarGetLinks(AppConfigIsar object) {
  return [];
}

void _appConfigIsarAttach(
    IsarCollection<dynamic> col, Id id, AppConfigIsar object) {
  object.id = id;
}

extension AppConfigIsarQueryWhereSort
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QWhere> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppConfigIsarQueryWhere
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QWhereClause> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause> idBetween(
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

extension AppConfigIsarQueryFilter
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QFilterCondition> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      completedTipIndicesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedTipIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      completedTipIndicesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedTipIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      completedTipIndicesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedTipIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      completedTipIndicesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedTipIndices',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      completedTipIndicesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedTipIndices',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      completedTipIndicesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedTipIndices',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      completedTipIndicesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedTipIndices',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      completedTipIndicesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedTipIndices',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      completedTipIndicesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedTipIndices',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      completedTipIndicesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedTipIndices',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      hasSeededMantiItemsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasSeededMantiItems',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
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

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition> idBetween(
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
}

extension AppConfigIsarQueryObject
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QFilterCondition> {}

extension AppConfigIsarQueryLinks
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QFilterCondition> {}

extension AppConfigIsarQuerySortBy
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QSortBy> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy>
      sortByHasSeededMantiItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSeededMantiItems', Sort.asc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy>
      sortByHasSeededMantiItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSeededMantiItems', Sort.desc);
    });
  }
}

extension AppConfigIsarQuerySortThenBy
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QSortThenBy> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy>
      thenByHasSeededMantiItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSeededMantiItems', Sort.asc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy>
      thenByHasSeededMantiItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSeededMantiItems', Sort.desc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension AppConfigIsarQueryWhereDistinct
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QDistinct> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QDistinct>
      distinctByCompletedTipIndices() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedTipIndices');
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QDistinct>
      distinctByHasSeededMantiItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasSeededMantiItems');
    });
  }
}

extension AppConfigIsarQueryProperty
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QQueryProperty> {
  QueryBuilder<AppConfigIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppConfigIsar, List<int>, QQueryOperations>
      completedTipIndicesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedTipIndices');
    });
  }

  QueryBuilder<AppConfigIsar, bool, QQueryOperations>
      hasSeededMantiItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasSeededMantiItems');
    });
  }
}
