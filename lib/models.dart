import 'package:fb/db/category.dart';

class CategoryStat {
  final Category category;
  final double left;
  final double total;
  final String currency;

  CategoryStat(this.category, this.left, this.total, this.currency);
}