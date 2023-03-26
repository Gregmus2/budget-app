import 'package:fb/providers/category.dart';
import 'package:fb/repository.dart';
import 'package:fb/ui/color_picker.dart';
import 'package:fb/ui/currency_picker.dart';
import 'package:fb/ui/icon_picker.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';

class CategoryCreatePage extends StatefulWidget {
  Category? category;

  CategoryCreatePage({super.key, this.category});

  @override
  State<CategoryCreatePage> createState() => _CategoryCreatePageState();
}

class _CategoryCreatePageState extends State<CategoryCreatePage> {
  late IconData icon;
  late Color color;
  late Currency currency;
  late final TextEditingController _nameInput;

  @override
  void initState() {
    super.initState();

    icon = widget.category?.icon ?? Icons.hourglass_empty;
    color = widget.category?.color ?? Colors.blue;
    currency = widget.category?.currency ?? CommonCurrencies().euro;
    _nameInput = TextEditingController(text: widget.category?.name);
  }

  @override
  Widget build(BuildContext context) {
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color,
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
                    provider.add(_nameInput.text, icon, color, currency);
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
                icon: const Icon(Icons.check))
          ],
          bottom: const TabBar(
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
}
