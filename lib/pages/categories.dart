import 'dart:math';

import 'package:fb/pages/categories_edit.dart';
import 'package:fb/pages/categories_list.dart';
import 'package:fb/ui/no_animation_page_route.dart';
import 'package:flutter/material.dart';
import 'package:fb/pages/page.dart' as page;

class CategoryNavigatorRoutes {
  static const String root = '/';
  static const String categoriesEdit = '/edit';
}

class CategoriesTab extends StatelessWidget implements page.Page {
  const CategoriesTab({super.key});

  @override
  List<Widget>? getActions(BuildContext context) => null;

  @override
  bool ownAppBar() => true;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: CategoryNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return NoAnimationPageRoute(
          builder: (context) {
            switch (routeSettings.name) {
              case CategoryNavigatorRoutes.root:
                return const CategoriesListPage();
              case CategoryNavigatorRoutes.categoriesEdit:
                return const CategoriesEditPage();
              default:
                return const CategoriesListPage();
            }
          },
        );
      },
    );
  }
}
