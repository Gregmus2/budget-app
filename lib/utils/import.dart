import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:csv/csv.dart';
import 'package:fb/db/account.dart';
import 'package:fb/db/category.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/providers/state.dart';
import 'package:fb/providers/transaction.dart';
import 'package:fb/ui/color_picker.dart';
import 'package:fb/ui/icon_picker.dart';
import 'package:fb/utils/currency.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

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

  void importAccounts(PlatformFile file) async {
    await EasyLoading.show(status: 'loading...');

    Stream<List<int>> stream = File(file.path!).openRead();
    stream
        .transform(utf8.decoder)
        .transform(const CsvToListConverter(eol: "\n", shouldParseNumbers: false))
        .skip(1)
        .listen((record) {
      record[0] = record[0].toString().trim();
      record[2] = record[2].toString().trim();
      addAccount(record[0], record[2], false);
    }, onDone: () async {
      await EasyLoading.showSuccess('Imported successfully!');
      await EasyLoading.dismiss();
    }, onError: (error) {
      EasyLoading.showError(error).then((value) => EasyLoading.dismiss());
    });
  }

  void importTransactions(PlatformFile file) async {
    await EasyLoading.show(status: 'loading...');

    List<Future> futures = [];
    int totalLines = await File(file.path!).openRead().transform(utf8.decoder).transform(const LineSplitter()).length - 1;
    int processedLines = 0;

    Stream<List<int>> stream = File(file.path!).openRead();
    stream
        .transform(utf8.decoder)
        .transform(const CsvToListConverter(eol: "\n", shouldParseNumbers: false))
        .skip(1)
        .listen((record) {
      record[_indexType] = record[_indexType].toString().trim();
      record[_indexFrom] = record[_indexFrom].toString().trim();
      record[_indexTo] = record[_indexTo].toString().trim();
      record[_indexCurrencyFrom] = record[_indexCurrencyFrom].toString().trim();
      record[_indexCurrencyTo] = record[_indexCurrencyTo].toString().trim();

      TransferTarget from, to;
      switch (record[_indexType]) {
        case "Income":
          from = getAccount(record[_indexFrom], record[_indexCurrencyFrom]);
          to = getTransferTarget(record[_indexTo], record[_indexCurrencyTo], CategoryType.income);

          break;

        case "Expense":
          from = getAccount(record[_indexFrom], record[_indexCurrencyFrom]);
          to = getTransferTarget(record[_indexTo], record[_indexCurrencyTo], CategoryType.expenses);

          break;

        case "Transfer":
          from = getAccount(record[_indexFrom], record[_indexCurrencyFrom]);
          to = getAccount(record[_indexTo], record[_indexCurrencyTo]);

          break;

        case "":
          return;

        default:
          throw Exception('Unknown transaction type: ${record[_indexType]}');
      }

      Future future = transactionProvider.addOnly(record[_indexNote], from, to, double.parse(record[_indexAmountFrom]),
          double.parse(record[_indexAmountTo]), Jiffy.parse(record[_indexDate], pattern: "MM/dd/yy").dateTime);
      futures.add(future);
      future.then((value) {
        processedLines++;
        double progress = processedLines / totalLines;
        EasyLoading.showProgress(progress, status: 'Importing... $processedLines/$totalLines');
      });
    }, onDone: () async {
      await Future.wait(futures);
      await transactionProvider.updateRange();
      await EasyLoading.showSuccess('Imported successfully!');
      Future.delayed(const Duration(seconds: 3), () => EasyLoading.dismiss());
    }, onError: (error) {
      EasyLoading.showError(error.toString());
      Future.delayed(const Duration(seconds: 3), () => EasyLoading.dismiss());
    });
  }

  TransferTarget getTransferTarget(String nameField, String currencyField, CategoryType type) {
    final accounts = accountProvider.items.where((element) => element.name == nameField);
    if (accounts.isNotEmpty) {
      return accounts.first;
    }

    String? subCategory;
    List<String> parts = nameField.split('(');
    if (parts.length > 1) {
      subCategory = parts[1].substring(0, parts[1].length - 1);
      nameField = parts[0].trim();
    }

    Category? category;
    if (categoryProvider.isNotExists(nameField)) {
      Currency? currency = Currency.fromISOCode(currencyField);
      currency ??= stateProvider.defaultCurrency;
      category = categoryProvider.add(nameField, IconPicker.icons.first, Colors.blue, currency, type, [], false);
    }

    String parentID = categoryProvider.findCategoryByName(nameField)!.id;
    if (subCategory != null && categoryProvider.isSubCategoryNotExists(subCategory, parentID)) {
      category =
          categoryProvider.addSubcategory(const UuidV4().generate(), subCategory, IconPicker.icons.first, parentID);
    }

    if (category == null) {
      if (subCategory != null) {
        return categoryProvider.findSubcategoryByName(subCategory, parentID)!;
      }

      return categoryProvider.findCategoryByName(nameField)!;
    }

    return category;
  }

  void addAccount(String nameField, String currencyField, bool archived) {
    Currency? currency = Currency.fromISOCode(currencyField);
    currency ??= stateProvider.defaultCurrency;
    accountProvider.add(
        nameField,
        Icons.account_balance_wallet,
        ColorPicker.primaryColors[(Random()).nextInt(ColorPicker.primaryColors.length)],
        currency,
        AccountType.regular,
        0.0,
        archived);
  }

  Account getAccount(String name, String currencyField) {
    return accountProvider.items.firstWhere(
        (element) => element.name == name && currencyField.toLowerCase() == element.currency.isoCode.toLowerCase(),
        orElse: () {
      return accountProvider.items.last;
    });
  }
}
