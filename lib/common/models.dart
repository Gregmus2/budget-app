import 'package:fb/models/category.dart';

class CategoryStat {
  final Category category;
  final double spent;
  final double? total;
  final String currency;

  CategoryStat(this.category, this.spent, this.total, this.currency);
}
