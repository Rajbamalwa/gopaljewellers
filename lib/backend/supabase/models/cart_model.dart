import 'package:gopaljewellers/backend/supabase/models/tables.dart';

import '../supabase_data_row/row.dart';

class CartTable extends SupabaseTable<CartRow> {
  @override
  String get tableName => 'user_carts';

  @override
  CartRow createRow(Map<String, dynamic> data) => CartRow(data);
}

class CartRow extends SupabaseDataRow {
  CartRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CartTable();

  int get id => getField<int>('id')!;

  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');

  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get product_id => getField<String>('product_id');

  set product_id(String? value) => setField<String>('product_id', value);

  String get product_name => getField<String>('product_name')!;

  set product_name(String value) => setField<String>('product_name', value);

  String? get product_material => getField<String?>('product_material');

  set product_material(String? value) =>
      setField<String?>('product_material', value);

  String? get product_type => getField<String>('product_type');

  set product_type(String? value) => setField<String>('product_type', value);

  String? get product_weight => getField<String>('product_weight');

  set product_weight(String? value) =>
      setField<String>('product_weight', value);
  String? get product_image => getField<String>('product_image');

  set product_image(String? value) => setField<String>('product_image', value);

  get product_quantity => getField('product_quantity');

  set product_quantity(value) => setField('product_quantity', value);

  String? get product_price => getField<String?>('product_price');

  set product_price(String? value) => setField<String?>('product_price', value);

  String? get user_name => getField<String>('user_name');

  set user_name(String? value) => setField<String>('user_name', value);

  String? get user_uid => getField<String>('user_uid');

  set user_uid(String? value) => setField<String>('user_uid', value);

  String? get user_phone => getField<String>('user_phone');

  set user_phone(String? value) => setField<String>('user_phone', value);
  String? get added_time => getField<String>('added_time');

  set added_time(String? value) => setField<String>('added_time', value);
}
