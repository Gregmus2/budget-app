import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {
  static const List<IconData> icons = <IconData>[
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
  Color color;
  IconData icon;
  Function(IconData) onChange;

  IconPicker(
      {super.key,
      required this.color,
      required this.onChange,
      this.icon = Icons.shopping_cart});

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: IconPicker.icons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, crossAxisSpacing: 10, mainAxisExtent: 100),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlinedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  (widget.icon == IconPicker.icons[index])
                      ? widget.color
                      : Colors.transparent),
              shape: MaterialStateProperty.all(const CircleBorder())),
          onPressed: () {
            setState(() {
              widget.icon = IconPicker.icons[index];
            });
            widget.onChange(IconPicker.icons[index]);
          },
          child: Icon(
            IconPicker.icons[index],
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
