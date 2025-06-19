import 'package:gopaljewellers/backend/supabase/models/tables.dart';

import '../supabase_data_row/row.dart';

class ProductTypeTable extends SupabaseTable<ProductTypeRows> {
  @override
  String get tableName => 'products_type';

  @override
  ProductTypeRows createRow(Map<String, dynamic> data) => ProductTypeRows(data);
}

class ProductTypeRows extends SupabaseDataRow {
  ProductTypeRows(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductTypeTable();

  int get id => getField<int>('id')!;

  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');

  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  int? get product_type_id => getField<int>('product_type_id');

  set product_type_id(int? value) => setField<int>('product_type_id', value);

  String? get type => getField<String>('type');

  set type(String? value) => setField<String>('type', value);

  get product_type => getField('product_type');
  set product_type(value) => setField('product_type', value);
}
