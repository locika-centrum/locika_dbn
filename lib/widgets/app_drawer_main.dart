import 'package:flutter/material.dart';

import '../model/app_menu_item.dart';

class AppBarDrawer extends StatelessWidget {
  final List<AppMenuItem>? menuItems;
  final Function menuItemsCallback;

  const AppBarDrawer(this.menuItems, this.menuItemsCallback, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      elevation: 0,
      width: 250.0,
      child: ListView.builder(
        itemCount: menuItems?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: ListTile(
              leading: SizedBox(
                width: 24.0,
                height: 24.0,
                child: menuItems?[index].icon,
              ),
              iconColor: Colors.white,
              textColor: Colors.white,
              title: Text(menuItems?[index].title ?? ''),
              onTap: () {
                menuItemsCallback(index);
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
