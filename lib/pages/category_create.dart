import 'package:fb/db/category.dart';
import 'package:fb/providers/category.dart';
import 'package:fb/ui/card_button.dart';
import 'package:fb/ui/color_picker.dart';
import 'package:fb/ui/currency_picker.dart';
import 'package:fb/ui/icon_picker.dart';
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
  late final TextEditingController _nameInput;
  late List<Category> subcategories;

  @override
  void initState() {
    super.initState();

    icon = widget.category?.icon ?? Icons.hourglass_empty;
    color = widget.category?.color ?? Colors.blue;
    currency = widget.category?.currency ?? CommonCurrencies().euro;
    _nameInput = TextEditingController(text: widget.category?.name);
    subcategories = widget.category?.subCategories ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);
    List<Widget> subcategoriesCards = buildSubCategoriesCards(context, subcategories);
    subcategoriesCards.insert(
        0,
        CustomButton(
          child: const Center(
            child: Text(
              "+ Add subcategory",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          onPressed: () {
            _showSubcategoryDialog(
              (name, icon) {
                if (widget.category != null) {
                  provider.addSubcategory(name, icon, color, currency, widget.category!.id);
                } else {
                  setState(() {
                    subcategories.add(Category(
                        id: provider.length,
                        name: name,
                        icon: icon,
                        color: color,
                        currency: currency,
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
              TextFormField(
                controller: _nameInput,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                style: const TextStyle(color: Colors.white),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (widget.category == null) {
                    provider.add(_nameInput.text, icon, color, currency, subcategories);
                  } else {
                    widget.category!
                      ..name = _nameInput.text
                      ..icon = icon
                      ..color = color
                      ..currency = currency;
                    provider.update(widget.category!);
                  }

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
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: "CURRENCY",
              ),
              Tab(
                text: "ICON",
              ),
              Tab(
                text: "COLOR",
              ),
              Tab(
                text: "SUBCATEGORIES",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            CurrencyPicker(
              currency: currency,
              onChanged: (currency) {
                setState(() {
                  this.currency = currency!;
                });
              },
              color: color,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconPicker(
                color: color,
                icon: icon,
                onChange: (icon) {
                  setState(() {
                    this.icon = icon;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ColorPicker(
                color: color,
                onChange: (color) {
                  setState(() {
                    this.color = color;
                  });
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: subcategoriesCards,
                )),
          ],
        ),
      ),
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

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.symmetric(vertical: 0),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  TextFormField(
                    controller: subcategoryNameInput,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
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
              TextButton(
                  onPressed: () {
                    onSubmit(subcategoryNameInput.text, icon);
                    Navigator.pop(context);
                  },
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(BeveledRectangleBorder()),
                      alignment: AlignmentDirectional.center,
                      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 10, horizontal: 10))),
                  child: const Text('OK')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(BeveledRectangleBorder()),
                      alignment: AlignmentDirectional.center,
                      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 10, horizontal: 10))),
                  child: const Text('CANCEL')),
            ],
          );
        });
      },
    );
  }
}

List<Widget> buildSubCategoriesCards(BuildContext context, List<Category> subcategories) {
  return List.generate(subcategories.length, (index) {
    final subCategory = subcategories[index];

    return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(subCategory.icon),
            const SizedBox(width: 10),
            Text(subCategory.name, style: const TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            // TODO edit subcategory (local if new category and provider if existing)
            // TODO implement other
          },
          itemBuilder: (BuildContext context) {
            return {'Edit', 'Convert to category', 'Merge with subcategory', 'archive', 'delete'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  });
}
