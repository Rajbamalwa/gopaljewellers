import 'package:gopaljewellers/backend/supabase/models/tables.dart';

import '../supabase_data_row/row.dart';

class AdminTable extends SupabaseTable<AdminRow> {
  @override
  String get tableName => 'admin';

  @override
  AdminRow createRow(Map<String, dynamic> data) => AdminRow(data);
}

class AdminRow extends SupabaseDataRow {
  AdminRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AdminTable();

  int get id => getField<int>('id')!;

  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');

  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get admin => getField<String>('admin');

  set admin(String? value) => setField<String>('admin', value);

  get token => getField('firebase_token');

  set token(value) => setField('firebase_token', value);
}
