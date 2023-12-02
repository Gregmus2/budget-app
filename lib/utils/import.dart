import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fb/db/account.dart';
import 'package:fb/db/category.dart';
import 'package:fb/db/transaction.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/icon_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiffy/jiffy.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';

class DataImport {
  static const _indexDate = 0;
  static const _indexType = 1;
  static const _indexFrom = 2;
  static const _indexTo = 3;
  static const _indexAmountFrom = 4;
  static const _indexCurrencyFrom = 5;
  static const _indexAmountTo = 6;
  static const _indexCurrencyTo = 7;
  static const _indexTags = 8;
  static const _indexNote = 9;

  late AccountProvider accountProvider;
  late CategoryProvider categoryProvider;
  late TransactionProvider transactionProvider;
  late StateProvider stateProvider;

  DataImport(BuildContext context) {
    accountProvider = Provider.of<AccountProvider>(context, listen: false);
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    stateProvider = Provider.of<StateProvider>(context, listen: false);
  }

  void import(PlatformFile file) {
    EasyLoading.show(status: 'loading...');

    Stream<List<int>> stream = File(file.path!).openRead();
    stream.transform(utf8.decoder).transform(const CsvToListConverter(eol: "\n", shouldParseNumbers: false)).skip(1).listen((record) {
      // todo archive suggestions can be added globally
      TransferTarget from, to;
      switch (record[_indexType].toString().trim()) {
        case "Income":
          from = addCategoryIfNew(record[_indexFrom], record[_indexCurrencyFrom], CategoryType.income);
          to = addAccountIfNew(record[_indexTo], record[_indexCurrencyTo]);

          break;

        case "Expense":
          from = addAccountIfNew(record[_indexFrom], record[_indexCurrencyFrom]);
          to = addCategoryIfNew(record[_indexTo], record[_indexCurrencyTo], CategoryType.expenses);

          break;

        case "Transfer":
          from = addAccountIfNew(record[_indexFrom], record[_indexCurrencyFrom]);
          to = addAccountIfNew(record[_indexTo], record[_indexCurrencyTo]);

          break;

        case "":
          return;

        default:
          throw Exception('Unknown transaction type: ${record[_indexType]}');
      }

      transactionProvider.addDry(record[_indexNote], from, to, double.parse(record[_indexAmountFrom]),
          double.parse(record[_indexAmountTo]), Jiffy.parse(record[_indexDate], pattern: "MM/dd/yy").dateTime);
    }, onDone: () {
      transactionProvider.commitDries().then((_)  {
        stateProvider.update();

        EasyLoading.showSuccess('Imported successfully!');
        EasyLoading.dismiss();
      });
    }, onError: (error) {
      EasyLoading.showError(error);
      EasyLoading.dismiss();
    });
  }

  Category addCategoryIfNew(String nameField, String currencyField, CategoryType type) {
    String? subCategory;
    List<String> parts = nameField.split('(');
    if (parts.length > 1) {
      subCategory = parts[1].substring(0, parts[1].length - 1);
      nameField = parts[0].trim();
    }

    Category? category;
    if (categoryProvider.items.where((element) => element.name == nameField && element.parent == null).isEmpty) {
      Currency? currency = Currencies().findByCode(currencyField);
      category = categoryProvider.add(nameField, IconPicker.icons.first, Colors.blue, currency!, type, []);
    }
    if (subCategory != null && categoryProvider.items.where((element) => element.name == subCategory && element.parent != null).isEmpty) {
      category = categoryProvider.addSubcategory(subCategory, IconPicker.icons.first,
          categoryProvider.items.firstWhere((element) => element.name == nameField && element.parent == null).id);
    }

    if (category == null) {
      if (subCategory != null) {
        return categoryProvider.items.firstWhere((element) => element.name == subCategory && element.parent != null);
      }

      return categoryProvider.items.firstWhere((element) => element.name == nameField && element.parent == null);
    }

    return category;
  }

  Account addAccountIfNew(String nameField, String currencyField) {
    Account? account;
    if (accountProvider.items.where((element) => element.name == nameField).isEmpty) {
      Currency? currency = Currencies().findByCode(currencyField);
      currency ??= CommonCurrencies().euro;
      account =
          accountProvider.add(nameField, IconPicker.icons.first, Colors.blue, currency, AccountType.regular, 0.0);
    }

    if (account == null) {
      return accountProvider.items.firstWhere((element) => element.name == nameField);
    }

    return account;
  }
}
