// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class MessageTbl extends Table with TableInfo<MessageTbl, MessageTblData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MessageTbl(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'PRIMARY KEY NOT NULL');
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _messageTypeMeta =
      const VerificationMeta('messageType');
  late final GeneratedColumn<String> messageType = GeneratedColumn<String>(
      'message_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'CHECK (message_type IN (\'imagine\', \'variation\', \'upscale\')) NOT NULL');
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT 0',
      defaultValue: const CustomExpression('0'));
  static const VerificationMeta _metaCreatedAtMeta =
      const VerificationMeta('metaCreatedAt');
  late final GeneratedColumn<int> metaCreatedAt = GeneratedColumn<int>(
      'meta_created_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  static const VerificationMeta _metaUpdatedAtMeta =
      const VerificationMeta('metaUpdatedAt');
  late final GeneratedColumn<int> metaUpdatedAt = GeneratedColumn<int>(
      'meta_updated_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT (strftime(\'%s\', \'now\'))',
      defaultValue: const CustomExpression('strftime(\'%s\', \'now\')'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        messageId,
        messageType,
        title,
        uri,
        progress,
        metaCreatedAt,
        metaUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'message_tbl';
  @override
  String get actualTableName => 'message_tbl';
  @override
  VerificationContext validateIntegrity(Insertable<MessageTblData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('message_type')) {
      context.handle(
          _messageTypeMeta,
          messageType.isAcceptableOrUnknown(
              data['message_type']!, _messageTypeMeta));
    } else if (isInserting) {
      context.missing(_messageTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('uri')) {
      context.handle(
          _uriMeta, uri.isAcceptableOrUnknown(data['uri']!, _uriMeta));
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('meta_created_at')) {
      context.handle(
          _metaCreatedAtMeta,
          metaCreatedAt.isAcceptableOrUnknown(
              data['meta_created_at']!, _metaCreatedAtMeta));
    }
    if (data.containsKey('meta_updated_at')) {
      context.handle(
          _metaUpdatedAtMeta,
          metaUpdatedAt.isAcceptableOrUnknown(
              data['meta_updated_at']!, _metaUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageTblData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageTblData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      messageType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      uri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uri']),
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      metaCreatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meta_created_at'])!,
      metaUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meta_updated_at'])!,
    );
  }

  @override
  MessageTbl createAlias(String alias) {
    return MessageTbl(attachedDatabase, alias);
  }

  @override
  bool get isStrict => true;
  @override
  bool get dontWriteConstraints => true;
}

class MessageTblData extends DataClass implements Insertable<MessageTblData> {
  final String id;
  final String messageId;
  final String messageType;
  final String? title;
  final String? uri;
  final int progress;

  /// created at
  final int metaCreatedAt;

  /// updated at
  final int metaUpdatedAt;
  const MessageTblData(
      {required this.id,
      required this.messageId,
      required this.messageType,
      this.title,
      this.uri,
      required this.progress,
      required this.metaCreatedAt,
      required this.metaUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['message_id'] = Variable<String>(messageId);
    map['message_type'] = Variable<String>(messageType);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || uri != null) {
      map['uri'] = Variable<String>(uri);
    }
    map['progress'] = Variable<int>(progress);
    map['meta_created_at'] = Variable<int>(metaCreatedAt);
    map['meta_updated_at'] = Variable<int>(metaUpdatedAt);
    return map;
  }

  MessageTblCompanion toCompanion(bool nullToAbsent) {
    return MessageTblCompanion(
      id: Value(id),
      messageId: Value(messageId),
      messageType: Value(messageType),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      uri: uri == null && nullToAbsent ? const Value.absent() : Value(uri),
      progress: Value(progress),
      metaCreatedAt: Value(metaCreatedAt),
      metaUpdatedAt: Value(metaUpdatedAt),
    );
  }

  factory MessageTblData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageTblData(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String>(json['message_id']),
      messageType: serializer.fromJson<String>(json['message_type']),
      title: serializer.fromJson<String?>(json['title']),
      uri: serializer.fromJson<String?>(json['uri']),
      progress: serializer.fromJson<int>(json['progress']),
      metaCreatedAt: serializer.fromJson<int>(json['meta_created_at']),
      metaUpdatedAt: serializer.fromJson<int>(json['meta_updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'message_id': serializer.toJson<String>(messageId),
      'message_type': serializer.toJson<String>(messageType),
      'title': serializer.toJson<String?>(title),
      'uri': serializer.toJson<String?>(uri),
      'progress': serializer.toJson<int>(progress),
      'meta_created_at': serializer.toJson<int>(metaCreatedAt),
      'meta_updated_at': serializer.toJson<int>(metaUpdatedAt),
    };
  }

  MessageTblData copyWith(
          {String? id,
          String? messageId,
          String? messageType,
          Value<String?> title = const Value.absent(),
          Value<String?> uri = const Value.absent(),
          int? progress,
          int? metaCreatedAt,
          int? metaUpdatedAt}) =>
      MessageTblData(
        id: id ?? this.id,
        messageId: messageId ?? this.messageId,
        messageType: messageType ?? this.messageType,
        title: title.present ? title.value : this.title,
        uri: uri.present ? uri.value : this.uri,
        progress: progress ?? this.progress,
        metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
        metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('MessageTblData(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('messageType: $messageType, ')
          ..write('title: $title, ')
          ..write('uri: $uri, ')
          ..write('progress: $progress, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, messageId, messageType, title, uri,
      progress, metaCreatedAt, metaUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageTblData &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.messageType == this.messageType &&
          other.title == this.title &&
          other.uri == this.uri &&
          other.progress == this.progress &&
          other.metaCreatedAt == this.metaCreatedAt &&
          other.metaUpdatedAt == this.metaUpdatedAt);
}

class MessageTblCompanion extends UpdateCompanion<MessageTblData> {
  final Value<String> id;
  final Value<String> messageId;
  final Value<String> messageType;
  final Value<String?> title;
  final Value<String?> uri;
  final Value<int> progress;
  final Value<int> metaCreatedAt;
  final Value<int> metaUpdatedAt;
  final Value<int> rowid;
  const MessageTblCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.messageType = const Value.absent(),
    this.title = const Value.absent(),
    this.uri = const Value.absent(),
    this.progress = const Value.absent(),
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageTblCompanion.insert({
    required String id,
    required String messageId,
    required String messageType,
    this.title = const Value.absent(),
    this.uri = const Value.absent(),
    this.progress = const Value.absent(),
    this.metaCreatedAt = const Value.absent(),
    this.metaUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        messageId = Value(messageId),
        messageType = Value(messageType);
  static Insertable<MessageTblData> custom({
    Expression<String>? id,
    Expression<String>? messageId,
    Expression<String>? messageType,
    Expression<String>? title,
    Expression<String>? uri,
    Expression<int>? progress,
    Expression<int>? metaCreatedAt,
    Expression<int>? metaUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (messageType != null) 'message_type': messageType,
      if (title != null) 'title': title,
      if (uri != null) 'uri': uri,
      if (progress != null) 'progress': progress,
      if (metaCreatedAt != null) 'meta_created_at': metaCreatedAt,
      if (metaUpdatedAt != null) 'meta_updated_at': metaUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageTblCompanion copyWith(
      {Value<String>? id,
      Value<String>? messageId,
      Value<String>? messageType,
      Value<String?>? title,
      Value<String?>? uri,
      Value<int>? progress,
      Value<int>? metaCreatedAt,
      Value<int>? metaUpdatedAt,
      Value<int>? rowid}) {
    return MessageTblCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      messageType: messageType ?? this.messageType,
      title: title ?? this.title,
      uri: uri ?? this.uri,
      progress: progress ?? this.progress,
      metaCreatedAt: metaCreatedAt ?? this.metaCreatedAt,
      metaUpdatedAt: metaUpdatedAt ?? this.metaUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (messageType.present) {
      map['message_type'] = Variable<String>(messageType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (metaCreatedAt.present) {
      map['meta_created_at'] = Variable<int>(metaCreatedAt.value);
    }
    if (metaUpdatedAt.present) {
      map['meta_updated_at'] = Variable<int>(metaUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageTblCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('messageType: $messageType, ')
          ..write('title: $title, ')
          ..write('uri: $uri, ')
          ..write('progress: $progress, ')
          ..write('metaCreatedAt: $metaCreatedAt, ')
          ..write('metaUpdatedAt: $metaUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final MessageTbl messageTbl = MessageTbl(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [messageTbl];
}
