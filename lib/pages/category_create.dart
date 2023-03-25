import 'package:fb/providers/category.dart';
import 'package:fb/ui/color_picker.dart';
import 'package:fb/ui/currency_picker.dart';
import 'package:fb/ui/icon_picker.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';

class CategoryCreatePage extends StatefulWidget {
  const CategoryCreatePage({super.key});

  @override
  State<CategoryCreatePage> createState() => _CategoryCreatePageState();
}

class _CategoryCreatePageState extends State<CategoryCreatePage> {
  IconData icon = Icons.hourglass_empty;
  Color color = Colors.blue;
  Currency currency = CommonCurrencies().euro;
  final _nameInput = TextEditingController();

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
                  provider.add(_nameInput.text, icon, color, currency.symbol);
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
