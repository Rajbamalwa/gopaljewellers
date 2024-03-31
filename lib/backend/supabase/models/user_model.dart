import 'package:gopaljewellers/backend/supabase/models/tables.dart';

import '../supabase_data_row/row.dart';

class UserTable extends SupabaseTable<UserRow> {
  @override
  String get tableName => 'users';

  @override
  UserRow createRow(Map<String, dynamic> data) => UserRow(data);
}

class UserRow extends SupabaseDataRow {
  UserRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserTable();

  int get id => getField<int>('id')!;

  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');

  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get user_name => getField<String>('user_name');

  set user_name(String? value) => setField<String>('user_name', value);

  String? get user_email => getField<String>('user_email');

  set user_email(String? value) => setField<String>('user_email', value);

  String? get user_phone => getField<String>('user_phone');

  set user_phone(String? value) => setField<String>('user_phone', value);
  String? get added_time => getField<String>('added_time');

  set added_time(String? value) => setField<String>('added_time', value);
}
