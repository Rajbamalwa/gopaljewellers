import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/src/supabase_stream_builder.dart';

import '../Supabase.dart';
import '../supabase_data_row/row.dart';

abstract class SupabaseTable<T extends SupabaseDataRow> {
  String get tableName;
  T createRow(Map<String, dynamic> data);

  PostgrestFilterBuilder<T> _select<T>() =>
      SupaFlow.client.from(tableName).select<T>();

  SupabaseStreamBuilder _stream<T>() =>
      SupaFlow.client.from(tableName).stream(primaryKey: ["id"]);

  Future<List<T>> queryRows({
    required PostgrestTransformBuilder Function(PostgrestFilterBuilder) queryFn,
    int? limit,
  }) {
    final select = _select<PostgrestList>();
    var query = queryFn(select);
    query = limit != null ? query.limit(limit) : query;
    return query
        .select<PostgrestList>()
        .then((rows) => rows.map(createRow).toList());
  }

  Stream<List<Map<String, dynamic>>> getStreamRow({
    required Stream Function(SupabaseStreamBuilder) queryFn,
  }) {
    final select = _stream<SupabaseStreamBuilder>();
    var query = queryFn(select);
    return query.cast();
  }

  Future<List<T>> querySingleRow({
    required PostgrestTransformBuilder Function(PostgrestFilterBuilder) queryFn,
  }) =>
      queryFn(_select<PostgrestMap>())
          .limit(1)
          .select<PostgrestMap?>()
          .maybeSingle()
          .then((r) => [if (r != null) createRow(r)]);

  Future<T> insert(Map<String, dynamic> data) => SupaFlow.client
      .from(tableName)
      .insert(data)
      .select<PostgrestMap>()
      .limit(1)
      .single()
      .then(createRow);

  Future<List<T>> update({
    required Map<String, dynamic> data,
    required PostgrestTransformBuilder Function(PostgrestFilterBuilder)
        matchingRows,
    bool returnRows = false,
  }) async {
    final update = matchingRows(SupaFlow.client.from(tableName).update(data));
    if (!returnRows) {
      await update;
      return [];
    }
    return update
        .select<PostgrestList>()
        .then((rows) => rows.map(createRow).toList());
  }

  Future<List<T>> delete({
    required PostgrestTransformBuilder Function(PostgrestFilterBuilder)
        matchingRows,
    bool returnRows = false,
  }) async {
    final delete = matchingRows(SupaFlow.client.from(tableName).delete());
    if (!returnRows) {
      await delete;
      return [];
    }
    return delete
        .select<PostgrestList>()
        .then((rows) => rows.map(createRow).toList());
  }
}

class PostgresTime {
  PostgresTime(this.time);
  DateTime? time;

  static PostgresTime? tryParse(String formattedString) {
    final datePrefix = DateTime.now().toIso8601String().split('T').first;
    return PostgresTime(DateTime.tryParse('${datePrefix}T$formattedString'));
  }

  String? toIso8601String() {
    return time?.toIso8601String().split('T').last;
  }

  @override
  String toString() {
    return toIso8601String() ?? '';
  }
}
