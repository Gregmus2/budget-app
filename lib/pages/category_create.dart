import 'package:fb/db/category.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/ui/custom_button.dart';
import 'package:fb/ui/color_picker.dart';
import 'package:fb/ui/currency_picker.dart';
import 'package:fb/ui/dialog_button.dart';
import 'package:fb/ui/icon_picker.dart';
import 'package:fb/ui/subcategory.dart';
import 'package:fb/ui/text_input.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';

class CategoryCreatePage extends StatefulWidget {
  final Category? category;

  const CategoryCreatePage({super.key, this.category});

  @override
  State<CategoryCreatePage> createState() => _CategoryCreatePageState();
}

class _CategoryCreatePageState extends State<CategoryCreatePage> {
  late IconData icon;
  late Color color;
  late Currency currency;
  late CategoryType type;
  late final TextEditingController _nameInput;
  late List<Category> subcategories;

  @override
  void initState() {
    super.initState();

    icon = widget.category?.icon ?? Icons.hourglass_empty;
    color = widget.category?.color ?? Colors.blue;
    currency = widget.category?.currency ?? CommonCurrencies().euro;
    type = widget.category?.type ?? CategoryType.expenses;
    _nameInput = TextEditingController(text: widget.category?.name);
    subcategories = widget.category?.subCategories ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);
    List<Widget> subcategoriesCards = _buildSubCategoriesCards(context, subcategories);
    subcategoriesCards.add(SubCategory(
      label: "Add",
      color: color,
      icon: Icons.add,
      inverse: true,
      onPressed: () {
        _showSubcategoryDialog(
          (name, icon) {
            if (widget.category != null) {
              provider.addSubcategory(name, icon, widget.category!.id);
            } else {
              setState(() {
                subcategories.add(Category(
                    id: provider.length,
                    name: name,
                    icon: icon,
                    color: color,
                    currency: currency,
                    type: type,
                    order: subcategories.isEmpty ? 0 : subcategories.last.order + 1,
                    parent: widget.category?.id));
              });
            }
          },
        );
      },
    ));

    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: color,
            foregroundColor: Colors.white,
            toolbarHeight: 100,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("New category"),
                EntityNameTextInput(nameInput: _nameInput, items: provider.items),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    provider.upsert(widget.category, _nameInput.text, icon, color, currency, type, subcategories);

                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check, color: Colors.white)),
              // create delete button
              if (widget.category != null)
                IconButton(
                    onPressed: () {
                      provider.remove(widget.category!);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete, color: Colors.white)),
            ],
          ),
          body: ListView(
            children: [
              keyStringValueCustomButton("Type", type.name.toUpperCase(), type == CategoryType.expenses ? Colors.red : Colors.green, () {
                setState(() {
                  if (type == CategoryType.expenses) {
                    type = CategoryType.income;
                  } else {
                    type = CategoryType.expenses;
                  }
                });
              }),
              keyStringValueCustomButton("Currency", currency.code, color, () {
                showCurrencyDialog(context, (currency) {
                  setState(() {
                    this.currency = currency;
                  });
                }, );
              }, subtitle: currency.name),
              keyValueCustomButton("Icon", Icon(icon, color: color), color, () {
                showIconDialog(context, color, icon, (icon) {
                  setState(() {
                    this.icon = icon;
                  });
                });
              }),
              keyValueCustomButton("Color", Icon(Icons.circle, color: color), color, () {
                showColorDialog(context, color, (color) {
                  setState(() {
                    this.color = color;
                  });
                });
              }),
              // todo show subcategories in the same way as in transactions, rounded boxes one by one with cross on edge to delete and plus icon for the last box
              Column(
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Subcategories",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  Wrap(
                    children: subcategoriesCards,
                  ),
                ],
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    _nameInput.dispose();
    super.dispose();
  }

  Future<void> _showSubcategoryDialog(Function(String name, IconData icon) onSubmit) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController subcategoryNameInput = TextEditingController();
        IconData icon = Icons.shopping_cart;
        CategoryProvider provider = Provider.of<CategoryProvider>(context);

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.symmetric(vertical: 0),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  EntityNameTextInput(nameInput: subcategoryNameInput, items: provider.items),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 0.69,
                    child: IconPicker(
                      color: color,
                      icon: icon,
                      onChange: (pickedIcon) {
                        setState(() {
                          icon = pickedIcon;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: <Widget>[
              DialogButton(
                  text: 'OK',
                  onPressed: () {
                    onSubmit(subcategoryNameInput.text, icon);
                    Navigator.pop(context);
                  },
                  color: Colors.green),
              DialogButton(
                  text: 'CANCEL',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.red)
            ],
          );
        });
      },
    );
  }
}

List<Widget> _buildSubCategoriesCards(BuildContext context, List<Category> subcategories) {
  return List<Widget>.generate(
    subcategories.length,
    (index) {
      Category subcategory = subcategories[index];

      return SubCategory(
        icon: subcategory.icon,
        color: subcategory.color,
        label: subcategory.name,
        onPressed: () {
          // todo subcategory edit (local if new category and provider if existing)
          // todo add 'Convert to category', 'Merge with subcategory', 'archive', 'delete' options there
        },
      );
    },
  );
}
