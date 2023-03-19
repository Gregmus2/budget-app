import 'package:fb/repository.dart';

class CategoryStat {
  final Category category;
  final int left;
  final int total;
  final String currency;

  CategoryStat(this.category, this.left, this.total, this.currency);
}