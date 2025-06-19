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

  String? get user_name => getField<String>('display_name');

  set user_name(String? value) => setField<String>('display_name', value);

  String? get user_email => getField<String>('email');

  set user_email(String? value) => setField<String>('email', value);

  String? get user_phone => getField<String>('user_number');

  set user_phone(String? value) => setField<String>('user_number', value);
  String? get added_time => getField<String>('added_time');

  set uid(String? value) => setField<String>('uid', value);
  String? get uid => getField<String>('uid');

  set photo_url(String? value) => setField<String>('photo_url', value);

  String? get photo_url => getField<String>('photo_url');

  set added_time(String? value) => setField<String>('added_time', value);

  String? get users => getField<String>('users');

  set users(String? value) => setField<String>('users', value);
  get token => getField('firebase_token');

  set token(value) => setField('firebase_token', value);
}
