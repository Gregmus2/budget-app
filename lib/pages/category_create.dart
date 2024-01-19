import 'package:fb/models/category.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/ui/color_picker.dart';
import 'package:fb/ui/currency_picker.dart';
import 'package:fb/ui/custom_button.dart';
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
  late IconData _icon;
  late Color _color;
  late Currency _currency;
  late CategoryType _type;
  late final TextEditingController _nameInput;
  late List<Category> _subcategories;
  Offset? _longPressOffset;
  final ContextMenuController _contextMenuController = ContextMenuController();

  @override
  void initState() {
    super.initState();

    _icon = widget.category?.icon ?? Icons.hourglass_empty;
    _color = widget.category?.color ?? Colors.blue;
    _currency = widget.category?.currency ?? CommonCurrencies().euro;
    _type = widget.category?.type ?? CategoryType.expenses;
    _nameInput = TextEditingController(text: widget.category?.name);
    _subcategories = widget.category?.subCategories ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);
    List<Widget> subcategoriesCards = _buildSubCategoriesCards(context, _subcategories);
    subcategoriesCards.add(SubCategory(
      label: "Add",
      color: _color,
      icon: Icons.add,
      inverse: true,
      onPressed: () {
        _showSubcategoryDialog(
          widget.category?.id,
          null,
          (name, icon) {
            if (widget.category != null) {
              provider.addSubcategory(Object().toString(), name, icon, widget.category!.id);
            } else {
              setState(() {
                _subcategories.add(Category(
                    name: name,
                    icon: icon,
                    color: _color,
                    currency: _currency,
                    type: _type,
                    order: _subcategories.isEmpty ? 0 : _subcategories.last.order + 1,
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
            backgroundColor: _color,
            foregroundColor: Colors.white,
            toolbarHeight: 100,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.category != null ? "Update category" : "New category"),
                EntityNameTextInput(nameInput: _nameInput, isUnique: provider.isNotExists),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    provider.upsert(widget.category, _nameInput.text, _icon, _color, _currency, _type, _subcategories);

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
              keyStringValueCustomButton(
                  "Type", _type.name.toUpperCase(), _type == CategoryType.expenses ? Colors.red : Colors.green, () {
                setState(() {
                  if (_type == CategoryType.expenses) {
                    _type = CategoryType.income;
                  } else {
                    _type = CategoryType.expenses;
                  }
                });
              }),
              keyStringValueCustomButton("Currency", _currency.code, _color, () {
                showCurrencyDialog(
                  context,
                  (currency) {
                    setState(() {
                      this._currency = currency;
                    });
                  },
                );
              }, subtitle: _currency.name),
              keyValueCustomButton("Icon", Icon(_icon, color: _color), _color, () {
                showIconDialog(context, _color, _icon, (icon) {
                  setState(() {
                    this._icon = icon;
                  });
                });
              }),
              keyValueCustomButton("Color", Icon(Icons.circle, color: _color), _color, () {
                showColorDialog(context, _color, (color) {
                  setState(() {
                    this._color = color;
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

  Future<void> _showSubcategoryDialog(String? parentID, Category? subCategory, Function(String name, IconData icon) onSubmit) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController subcategoryNameInput = TextEditingController(text: subCategory?.name);
        IconData icon = subCategory != null ? subCategory.icon : Icons.shopping_cart;
        CategoryProvider provider = Provider.of<CategoryProvider>(context);

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.symmetric(vertical: 0),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  EntityNameTextInput(nameInput: subcategoryNameInput, isUnique: (value) => parentID == null ? true : provider.isSubCategoryNotExists(value, parentID)),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 0.69,
                    child: IconPicker(
                      color: _color,
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

  List<Widget> _buildSubCategoriesCards(BuildContext context, List<Category> subcategories) {
    return List<Widget>.generate(
      subcategories.length,
          (index) {
        Category subcategory = subcategories[index];

        return GestureDetector(
          child: SubCategory(
            icon: subcategory.icon,
            color: subcategory.color,
            label: subcategory.name,
          ),
            onTap: () {
              _showSubcategoryDialog(
                widget.category?.id,
                subcategory,
                    (name, icon) {
                  subcategory.name = name;
                  subcategory.icon = icon;
                  setState(() {
                    subcategories[index] = subcategory;
                  });
                },
              );
            },
          onLongPressStart: (details) {
            setState(() {
              _longPressOffset = details.globalPosition;
            });
          },
            onLongPress: () {
            // todo finish implementation https://api.flutter.dev/flutter/widgets/ContextMenuController-class.html or https://pub.dev/packages/context_menus
              _contextMenuController.show(
                context: context,
                contextMenuBuilder: (BuildContext context) {
                  return AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: TextSelectionToolbarAnchors(
                      primaryAnchor: _longPressOffset!,
                    ),
                    buttonItems: <ContextMenuButtonItem>[
                      ContextMenuButtonItem(
                        onPressed: () {
                          ContextMenuController.removeAny();
                          // todo implement
                        },
                        label: 'Convert to category',
                      ),
                      ContextMenuButtonItem(
                        onPressed: () {
                          ContextMenuController.removeAny();
                          // todo implement
                        },
                        label: 'Merge',
                      ),
                      ContextMenuButtonItem(
                        onPressed: () {
                          ContextMenuController.removeAny();
                          // todo implement
                        },
                        label: 'Archive',
                      ),
                      ContextMenuButtonItem(
                        onPressed: () {
                          ContextMenuController.removeAny();
                          // todo implement
                        },
                        label: 'Delete',
                      ),
                    ],
                  );
                },
              );
            },
        );
      },
    );
  }
}
