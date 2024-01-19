import 'package:flutter/material.dart';

class ContextMenu {
  static showMenu(BuildContext context, List<ContextMenuItem> items) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.4,
          children: List.generate(
            items.length,
            (index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: items[index].onPressed,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(
                          items[index].color.red, items[index].color.green, items[index].color.blue, 0.3)),
                      shape: MaterialStateProperty.all(const CircleBorder(eccentricity: 0)),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(13)),
                    ),
                    child: Icon(items[index].icon, color: items[index].color, size: 25),
                  ),
                  const SizedBox(height: 5),
                  Text(items[index].title,
                      style: const TextStyle(color: Colors.white70, fontSize: 13), overflow: TextOverflow.ellipsis),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ContextMenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final Function() onPressed;

  const ContextMenuItem({required this.title, required this.icon, required this.color, required this.onPressed});
}
