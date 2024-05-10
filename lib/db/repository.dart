import 'package:fb/db/account.dart';
import 'package:fb/db/budget.dart';
import 'package:fb/db/category.dart';
import 'package:fb/db/transaction.dart';
import 'package:fb/models/account.dart';
import 'package:fb/models/budget.dart';
import 'package:fb/models/category.dart';
import 'package:fb/models/model.dart';
import 'package:fb/models/transaction.dart' as model;
import 'package:fb/providers/state.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

const String tableCategories = 'categories';
const String tableAccounts = 'accounts';
const String tableTransactions = 'transactions';
const String tableBudgets = 'budgets';

class Repository {
  List<SchemaObject> schemas = [CategoryModel.schema, AccountModel.schema, TransactionModel.schema, BudgetModel.schema];
  StateProvider stateProvider;
  late Realm db;

  Repository(this.stateProvider);

  Future init(User user) async {
    db = Realm(Configuration.flexibleSync(user, schemas));
    // db = Realm(Configuration.local(schemas));

    // can be disabled for free users
    db.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(db.all<CategoryModel>());
      mutableSubscriptions.add(db.all<AccountModel>());
      mutableSubscriptions.add(db.all<TransactionModel>());
      mutableSubscriptions.add(db.all<BudgetModel>());
    });

    await db.subscriptions.waitForSynchronization();
  }

  Future<void> create(Model model) async {
    db.write(() => db.add(model.toRealmObject(stateProvider.userID!)));
  }

  List<Category> listCategories() {
    final RealmResults<CategoryModel> results = db.all<CategoryModel>();

    return List.generate(results.length, (i) {
      return Category.mapRealm(results[i]);
    });
  }

  List<Account> listAccounts() {
    final RealmResults<AccountModel> results = db.all<AccountModel>();

    return List.generate(results.length, (i) {
      return Account.mapRealm(results[i]);
    });
  }

  List<model.Transaction> listTransactions(DateTimeRange range) {
    final RealmResults<TransactionModel> results = db.query<TransactionModel>(
        'date >= \$0 AND date <= \$1 SORT(date ASC)',
        [range.start.millisecondsSinceEpoch ~/ 1000, range.end.millisecondsSinceEpoch ~/ 1000]);

    return List.generate(results.length, (i) {
      return model.Transaction.mapRealm(results[i]);
    });
  }

  List<Budget> listBudgets(int month, int year) {
    final RealmResults<BudgetModel> results = db.query<BudgetModel>('month = \$0 AND year = \$1', [month, year]);

    return List.generate(results.length, (i) {
      return Budget.mapRealm(results[i]);
    });
  }

  Future<void> update(Model model) async {
    db.write(() => db.add(model.toRealmObject(stateProvider.userID!), update: true));
  }

  Future<void> delete(Model model) async {
    db.write(() => db.delete(model.toRealmObject(stateProvider.userID!)));
  }

  Future<void> deleteAll<T extends RealmObject>() async {
    db.write(() => db.deleteAll<T>());
  }

  Future<void> createBatch<T extends RealmObject>(List<T> models) async {
    db.write(() => db.addAll<T>(models));
  }
}
