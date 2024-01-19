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

  @override
  void initState() {
    super.initState();
    icon = widget.icon;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return GridView.count(
        padding: const EdgeInsets.symmetric(vertical: 10),
        crossAxisCount: 4,
        crossAxisSpacing: (constraints.maxWidth / 100) / 4 * 10,
        mainAxisSpacing: (constraints.maxWidth / 100) / 4 * 16,
        children: List.generate(
          IconPicker.icons.length,
          (index) {
            return Padding(
              padding: EdgeInsets.all((constraints.maxWidth / 100) / 4 * 7),
              child: OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        (icon == IconPicker.icons[index]) ? widget.color : Colors.transparent),
                    shape: MaterialStateProperty.all(const CircleBorder())),
                onPressed: () {
                  setState(() {
                    icon = IconPicker.icons[index];
                  });
                  widget.onChange(IconPicker.icons[index]);
                },
                child: Icon(
                  IconPicker.icons[index],
                  color: Colors.white,
                  size: (constraints.maxWidth / 100) / 4 * 30,
                ),
              ),
            );
          },
        ),
      );
    });
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
