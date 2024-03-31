import 'package:gopaljewellers/backend/supabase/models/tables.dart';

import '../supabase_data_row/row.dart';

class ProductTables extends SupabaseTable<ProductsRows> {
  @override
  String get tableName => 'all_products';

  @override
  ProductsRows createRow(Map<String, dynamic> data) => ProductsRows(data);
}

class ProductsRows extends SupabaseDataRow {
  ProductsRows(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductTables();

  int get id => getField<int>('id')!;

  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');

  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get product_id => getField<String?>('product_id');

  set product_id(String? value) => setField<String?>('product_id', value);

  String? get product_name => getField<String?>('product_name');

  set product_name(String? value) => setField<String?>('product_name', value);

  String? get product_description => getField<String>('product_description');

  set product_description(String? value) =>
      setField<String>('product_description', value);

  get product_images => getField('product_images');

  set product_images(value) => setField('product_images', value);

  String? get product_weight => getField<String>('product_weight');

  set product_weight(String? value) =>
      setField<String>('product_weight', value);

  String? get product_type => getField<String>('product_type');

  set product_type(String? value) => setField<String>('product_type', value);

  String? get product_price => getField<String>('product_price');

  set product_price(String? value) => setField<String>('product_price', value);

  String? get product_material => getField<String>('product_material');

  set product_material(String? value) =>
      setField<String>('product_material', value);

  get product_likes => getField('product_likes');

  set product_likes(value) => setField('product_likes', value);
}
