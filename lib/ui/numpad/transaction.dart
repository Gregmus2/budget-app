import 'package:fb/db/account.dart';
import 'package:fb/db/category.dart';
import 'package:fb/db/transaction.dart';
import 'package:fb/db/transfer_target.dart';
import 'package:fb/providers/account.dart';
import 'package:fb/ui/account_card.dart';
import 'package:fb/ui/categories_popup.dart';
import 'package:fb/ui/numpad/basic.dart';
import 'package:fb/ui/subcategory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// todo implement double currencies if transfer targets has different currencies
class TransactionNumPad extends StatefulWidget {
  final TransferTarget from;
  final TransferTarget to;
  final Transaction? transaction;
  final Function(double value, DateTime date, TransferTarget from,
      TransferTarget to, String note) onDoneFunc;

  const TransactionNumPad(
      {super.key,
        required this.onDoneFunc,
        required this.from,
        required this.to,
        this.transaction});

  @override
  State<TransactionNumPad> createState() => _TransactionNumPadState();
}

class _TransactionNumPadState extends State<TransactionNumPad> {
  DateTime selectedDate = DateTime.now();
  late TransferTarget from;
  late TransferTarget to;
  TransferTarget? toSubCategory;
  TransferTarget? fromSubCategory;
  final TextEditingController _nameInput = TextEditingController();

  @override
  void initState() {
    from = widget.from;
    to = widget.to;
    if (widget.transaction != null) {
      _nameInput.text = widget.transaction!.note;
      selectedDate = widget.transaction!.date;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Category? parentCategory;
    if (from is Category && (from as Category).subCategories.isNotEmpty) {
      parentCategory = from as Category;
    }
    if (to is Category && (to as Category).subCategories.isNotEmpty) {
      parentCategory = to as Category;
    }

    return Column(
      children: [
        SimpleNumPad(
          number: widget.transaction?.amountTo ?? 0,
          currency: from.currency,
          additionalButtons: [
            NumPadButtonModel(5, 2, "Date", "D"),
          ],
          handler: (char, context) {
            if (char == 'D') {
              showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100))
                  .then((value) {
                if (value != null) {
                  setState(() {
                    selectedDate = value;
                  });
                }
              });
            }
          },
          underBalance: parentCategory != null
              ? Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: SizedBox(
              height: 25,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  parentCategory.activeSubCategories.length,
                      (index) {
                    Category subcategory =
                    parentCategory!.activeSubCategories[index];

                    return SubCategory(
                        label: subcategory.name,
                        color: subcategory.color,
                        icon: subcategory.icon,
                        inverse: (toSubCategory == subcategory ||
                            fromSubCategory == subcategory),
                        onPressed: () {
                          setState(() {
                            if (toSubCategory == subcategory) {
                              toSubCategory = null;
                            } else if (fromSubCategory == subcategory) {
                              fromSubCategory = null;
                            } else if (parentCategory == from) {
                              fromSubCategory = subcategory;
                            } else {
                              toSubCategory = subcategory;
                            }
                          });
                        });
                  },
                ),
              ),
            ),
          )
              : Container(),
          leftGuy: FromToButton(
              entity: from,
              onSelected: (target) {
                setState(() {
                  from = target;
                });
              }),
          rightGuy: FromToButton(
              entity: to,
              onSelected: (target) {
                setState(() {
                  to = target;
                });
              }),
          middle: Column(
            children: [
              const Divider(
                height: 1,
              ),
              TextField(
                style: const TextStyle(fontSize: 14),
                controller: _nameInput,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: 'Notes...',
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none),
              ),
            ],
          ),
          onDone: (number) => widget.onDoneFunc(number, selectedDate,
              fromSubCategory ?? from, toSubCategory ?? to, _nameInput.text),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Text(DateFormat().format(selectedDate)),
        )
      ],
    );
  }
}

class FromToButton extends StatelessWidget {
  final TransferTarget entity;
  final Function(TransferTarget) onSelected;

  const FromToButton({
    super.key,
    required this.entity,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(
          shape: WidgetStatePropertyAll(BeveledRectangleBorder())),
      onPressed: () {
        showGeneralDialog(
          context: context,
          barrierLabel: "Barrier",
          barrierDismissible: true,
          pageBuilder: (context, animation, secondaryAnimation) {
            return Center(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height * 0.7,
                child: entity is Account
                    ? AccountSelectionPopup(onPressed: (account) {
                  onSelected(account);

                  Navigator.pop(context);
                })
                    : CategorySelectionPopup(onPressed: (category) {
                  onSelected(category);

                  Navigator.pop(context);
                }),
              ),
            );
          },
        );
      },
      child: Column(
        children: [
          Icon(
            entity.icon,
            color: entity.color,
          ),
          Text(entity.name,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class AccountSelectionPopup extends StatefulWidget {
  const AccountSelectionPopup({
    super.key,
    required this.onPressed,
  });

  final Function(Account) onPressed;

  @override
  State<AccountSelectionPopup> createState() => _AccountSelectionPopupState();
}

class _AccountSelectionPopupState extends State<AccountSelectionPopup> {
  Set<Account> filters = <Account>{};

  @override
  Widget build(BuildContext context) {
    AccountProvider provider =
    Provider.of<AccountProvider>(context, listen: false);

    return SingleChildScrollView(
      child: ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: List.generate(provider.length, (index) {
            Account account = provider.get(index)!;

            return AccountCard(
              key: ValueKey(index),
              account: account,
              onPressed: () {
                widget.onPressed(account);
              },
            );
          })),
    );
  }
}

