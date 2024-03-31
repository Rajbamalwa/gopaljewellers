import 'package:gopaljewellers/backend/supabase/models/tables.dart';

import '../supabase_data_row/row.dart';

class FeedBacktable extends SupabaseTable<FeedbackRows> {
  @override
  String get tableName => 'feedbacks';

  @override
  FeedbackRows createRow(Map<String, dynamic> data) => FeedbackRows(data);
}

class FeedbackRows extends SupabaseDataRow {
  FeedbackRows(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FeedBacktable();

  int get id => getField<int>('id')!;

  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');

  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get user_name => getField<String>('name');

  set user_name(String? value) => setField<String>('name', value);

  String? get user_email => getField<String>('email');

  set user_email(String? value) => setField<String>('email', value);

  String? get user_phone => getField<String>('phone');

  set user_phone(String? value) => setField<String>('phone', value);
  String? get user_id => getField<String>('user_uid');

  set user_id(String? value) => setField<String>('user_uid', value);

  String? get message => getField<String>('message');

  set message(String? value) => setField<String>('message', value);

  String? get subject => getField<String>('subject');

  set subject(String? value) => setField<String>('subject', value);
}
