import 'package:gopaljewellers/backend/supabase/models/tables.dart';

import '../supabase_data_row/row.dart';

class OrdersTable extends SupabaseTable<OrdersRow> {
  @override
  String get tableName => 'orders';

  @override
  OrdersRow createRow(Map<String, dynamic> data) => OrdersRow(data);
}

class OrdersRow extends SupabaseDataRow {
  OrdersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrdersTable();

  int get id => getField<int>('id')!;

  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');

  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get product_id => getField<String>('product_id');

  set product_id(String? value) => setField<String>('product_id', value);

  String get product_name => getField<String>('product_name')!;

  set product_name(String value) => setField<String>('product_name', value);

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

  String? get user_number => getField<String>('user_number');

  set user_number(String? value) => setField<String>('user_number', value);
  bool? get delivered => getField<bool>('delivered');

  set delivered(bool? value) => setField<bool>('delivered', value);
  String? get delievery_date => getField<String>('delievery_date');

  set delievery_date(String? value) =>
      setField<String>('delievery_date', value);

  bool? get cancel => getField<bool>('cancel');

  set cancel(bool? value) => setField<bool>('cancel', value);

  String? get order_id => getField<String>('order_id');

  set order_id(String? value) => setField<String>('order_id', value);
  String? get remark => getField<String>('remark');

  set remark(String? value) => setField<String>('remark', value);
}
