// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manti_item_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMantiItemIsarCollection on Isar {
  IsarCollection<MantiItemIsar> get mantiItemIsars => this.collection();
}

const MantiItemIsarSchema = CollectionSchema(
  name: r'MantiItemIsar',
  id: 141775262145112793,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.byte,
      enumMap: _MantiItemIsarcategoryEnumValueMap,
    ),
    r'colorValue': PropertySchema(
      id: 1,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customCategory': PropertySchema(
      id: 3,
      name: r'customCategory',
      type: IsarType.string,
    ),
    r'iconName': PropertySchema(
      id: 4,
      name: r'iconName',
      type: IsarType.string,
    ),
    r'idLocal': PropertySchema(
      id: 5,
      name: r'idLocal',
      type: IsarType.string,
    ),
    r'idRemote': PropertySchema(
      id: 6,
      name: r'idRemote',
      type: IsarType.string,
    ),
    r'lastMaintenance': PropertySchema(
      id: 7,
      name: r'lastMaintenance',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 8,
      name: r'name',
      type: IsarType.string,
    ),
    r'nextMaintenance': PropertySchema(
      id: 9,
      name: r'nextMaintenance',
      type: IsarType.dateTime,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _mantiItemIsarEstimateSize,
  serialize: _mantiItemIsarSerialize,
  deserialize: _mantiItemIsarDeserialize,
  deserializeProp: _mantiItemIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _mantiItemIsarGetId,
  getLinks: _mantiItemIsarGetLinks,
  attach: _mantiItemIsarAttach,
  version: '3.1.0+1',
);

int _mantiItemIsarEstimateSize(
  MantiItemIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.customCategory;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.iconName.length * 3;
  bytesCount += 3 + object.idLocal.length * 3;
  {
    final value = object.idRemote;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _mantiItemIsarSerialize(
  MantiItemIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.category.index);
  writer.writeLong(offsets[1], object.colorValue);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.customCategory);
  writer.writeString(offsets[4], object.iconName);
  writer.writeString(offsets[5], object.idLocal);
  writer.writeString(offsets[6], object.idRemote);
  writer.writeDateTime(offsets[7], object.lastMaintenance);
  writer.writeString(offsets[8], object.name);
  writer.writeDateTime(offsets[9], object.nextMaintenance);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

MantiItemIsar _mantiItemIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MantiItemIsar();
  object.category =
      _MantiItemIsarcategoryValueEnumMap[reader.readByteOrNull(offsets[0])] ??
          MantiCategory.tech;
  object.colorValue = reader.readLong(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.customCategory = reader.readStringOrNull(offsets[3]);
  object.iconName = reader.readString(offsets[4]);
  object.id = id;
  object.idLocal = reader.readString(offsets[5]);
  object.idRemote = reader.readStringOrNull(offsets[6]);
  object.lastMaintenance = reader.readDateTimeOrNull(offsets[7]);
  object.name = reader.readString(offsets[8]);
  object.nextMaintenance = reader.readDateTimeOrNull(offsets[9]);
  object.updatedAt = reader.readDateTime(offsets[10]);
  return object;
}

P _mantiItemIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_MantiItemIsarcategoryValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MantiCategory.tech) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MantiItemIsarcategoryEnumValueMap = {
  'tech': 0,
  'vehicle': 1,
  'tool': 2,
  'home': 3,
  'other': 4,
};
const _MantiItemIsarcategoryValueEnumMap = {
  0: MantiCategory.tech,
  1: MantiCategory.vehicle,
  2: MantiCategory.tool,
  3: MantiCategory.home,
  4: MantiCategory.other,
};

Id _mantiItemIsarGetId(MantiItemIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mantiItemIsarGetLinks(MantiItemIsar object) {
  return [];
}

void _mantiItemIsarAttach(
    IsarCollection<dynamic> col, Id id, MantiItemIsar object) {
  object.id = id;
}

extension MantiItemIsarQueryWhereSort
    on QueryBuilder<MantiItemIsar, MantiItemIsar, QWhere> {
  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MantiItemIsarQueryWhere
    on QueryBuilder<MantiItemIsar, MantiItemIsar, QWhereClause> {
  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterWhereClause> idBetween(
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

extension MantiItemIsarQueryFilter
    on QueryBuilder<MantiItemIsar, MantiItemIsar, QFilterCondition> {
  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      categoryEqualTo(MantiCategory value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      categoryGreaterThan(
    MantiCategory value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      categoryLessThan(
    MantiCategory value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      categoryBetween(
    MantiCategory lower,
    MantiCategory upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      colorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      colorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      colorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      colorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customCategory',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customCategory',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customCategory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customCategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customCategory',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      customCategoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customCategory',
        value: '',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      iconNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      iconNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      iconNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      iconNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      iconNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      iconNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      iconNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'iconName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      iconNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'iconName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      iconNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconName',
        value: '',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      iconNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iconName',
        value: '',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
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

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idLocalEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idLocalGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idLocalLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idLocalBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idLocal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idLocalStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idLocalEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idLocalContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idLocal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idLocalMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idLocal',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idLocalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idLocal',
        value: '',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idLocalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idLocal',
        value: '',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idRemote',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idRemote',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idRemote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idRemote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idRemote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idRemote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idRemote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idRemote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idRemote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idRemote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idRemote',
        value: '',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      idRemoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idRemote',
        value: '',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      lastMaintenanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastMaintenance',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      lastMaintenanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastMaintenance',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      lastMaintenanceEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMaintenance',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      lastMaintenanceGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMaintenance',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      lastMaintenanceLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMaintenance',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      lastMaintenanceBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMaintenance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nextMaintenanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextMaintenance',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nextMaintenanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextMaintenance',
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nextMaintenanceEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextMaintenance',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nextMaintenanceGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextMaintenance',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nextMaintenanceLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextMaintenance',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      nextMaintenanceBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextMaintenance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MantiItemIsarQueryObject
    on QueryBuilder<MantiItemIsar, MantiItemIsar, QFilterCondition> {}

extension MantiItemIsarQueryLinks
    on QueryBuilder<MantiItemIsar, MantiItemIsar, QFilterCondition> {}

extension MantiItemIsarQuerySortBy
    on QueryBuilder<MantiItemIsar, MantiItemIsar, QSortBy> {
  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> sortByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByCustomCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByCustomCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> sortByIconName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByIconNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> sortByIdLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idLocal', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> sortByIdLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idLocal', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> sortByIdRemote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRemote', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByIdRemoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRemote', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByLastMaintenance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMaintenance', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByLastMaintenanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMaintenance', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByNextMaintenance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextMaintenance', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByNextMaintenanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextMaintenance', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MantiItemIsarQuerySortThenBy
    on QueryBuilder<MantiItemIsar, MantiItemIsar, QSortThenBy> {
  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByCustomCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByCustomCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customCategory', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenByIconName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByIconNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconName', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenByIdLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idLocal', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenByIdLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idLocal', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenByIdRemote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRemote', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByIdRemoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idRemote', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByLastMaintenance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMaintenance', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByLastMaintenanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMaintenance', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByNextMaintenance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextMaintenance', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByNextMaintenanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextMaintenance', Sort.desc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MantiItemIsarQueryWhereDistinct
    on QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct> {
  QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct> distinctByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category');
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct> distinctByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorValue');
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct>
      distinctByCustomCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customCategory',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct> distinctByIconName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct> distinctByIdLocal(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idLocal', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct> distinctByIdRemote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idRemote', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct>
      distinctByLastMaintenance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMaintenance');
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct>
      distinctByNextMaintenance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextMaintenance');
    });
  }

  QueryBuilder<MantiItemIsar, MantiItemIsar, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MantiItemIsarQueryProperty
    on QueryBuilder<MantiItemIsar, MantiItemIsar, QQueryProperty> {
  QueryBuilder<MantiItemIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MantiItemIsar, MantiCategory, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<MantiItemIsar, int, QQueryOperations> colorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorValue');
    });
  }

  QueryBuilder<MantiItemIsar, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MantiItemIsar, String?, QQueryOperations>
      customCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customCategory');
    });
  }

  QueryBuilder<MantiItemIsar, String, QQueryOperations> iconNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconName');
    });
  }

  QueryBuilder<MantiItemIsar, String, QQueryOperations> idLocalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idLocal');
    });
  }

  QueryBuilder<MantiItemIsar, String?, QQueryOperations> idRemoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idRemote');
    });
  }

  QueryBuilder<MantiItemIsar, DateTime?, QQueryOperations>
      lastMaintenanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMaintenance');
    });
  }

  QueryBuilder<MantiItemIsar, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<MantiItemIsar, DateTime?, QQueryOperations>
      nextMaintenanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextMaintenance');
    });
  }

  QueryBuilder<MantiItemIsar, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
