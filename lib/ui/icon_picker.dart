import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {
  static const List<IconData> icons = <IconData>[
    Icons.list,
    Icons.shopping_cart,
    Icons.accessibility,
    Icons.accessible,
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.account_box,
    Icons.account_circle,
    Icons.account_tree,
    Icons.ad_units,
    Icons.adb,
    Icons.add,
    Icons.add_comment,
    Icons.air,
    Icons.airplanemode_active,
    Icons.airplay,
    Icons.airport_shuttle,
    Icons.align_horizontal_center,
    Icons.all_inbox,
    Icons.all_inclusive,
    Icons.alt_route,
    Icons.alternate_email,
    Icons.amp_stories,
    Icons.anchor,
    Icons.apps,
    Icons.directions_bus,
    Icons.phone,
    Icons.gamepad,
    Icons.videogame_asset,
    Icons.kitchen,
    Icons.house,
    Icons.face,
    Icons.healing,
    Icons.card_giftcard,
    Icons.airplane_ticket,
    Icons.restaurant,
  ];

  final Color color;
  final IconData icon;
  final Function(IconData) onChange;

  const IconPicker({super.key, required this.color, required this.onChange, this.icon = Icons.shopping_cart});

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  late IconData icon;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    icon = widget.icon;
  }

  List<IconData> _getFilteredIcons() {
    if (_searchQuery.isEmpty) {
      return IconPicker.icons;
    }

    return IconPicker.icons
        .where((icon) => icon.toString().toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredIcons = _getFilteredIcons();
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search Icons',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              filteredIcons.length,
                  (index) {
                return OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        (icon == filteredIcons[index]) ? widget.color : Colors.transparent
                    ),
                    shape: const WidgetStatePropertyAll(CircleBorder()),
                    padding: const WidgetStatePropertyAll(EdgeInsets.all(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      icon = filteredIcons[index];
                    });
                    widget.onChange(filteredIcons[index]);
                  },
                  child: Icon(
                    filteredIcons[index],
                    color: (icon == filteredIcons[index]) ? colorScheme.onPrimary : colorScheme.onSurface,
                    size: 24,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showIconDialog(BuildContext context, Color color, IconData icon, Function(IconData) onChange) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.69,
          child: IconPicker(
              color: color,
              onChange: (icon) {
                onChange(icon);
                Navigator.pop(context);
              },
              icon: icon),
        ),
      );
    },
  );
}
