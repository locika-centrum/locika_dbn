import 'dart:math';

import 'package:flutter/material.dart';
import 'package:locika_dbn_test/widgets/app_drawer_main.dart';
import 'package:logging/logging.dart';

import '../model/app_menu_item.dart';
import '../widgets/bottom_navigation_bar_main.dart';

Logger _log = Logger('responsive_scaffold.dart');

class ResponsiveScaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget? panelMain;
  final Widget? panelOne;
  final Widget? panelTwo;
  final Color? backgroundColor;
  final List<AppMenuItem>? menuItems;
  final Function? menuItemsCallback;

  const ResponsiveScaffold(
      {Key? key,
      this.appBar,
      this.panelMain,
      this.panelOne,
      this.panelTwo,
      this.backgroundColor,
      this.menuItems,
      this.menuItemsCallback})
      : assert((panelOne != null && panelTwo != null) || panelMain != null,
            'Both panelOne and panelTwo need to be non null or panelMain need to be non null.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body;
    AppBar? appBarUpdated;

    return OrientationBuilder(
      builder: (context, orientation) {
        _log.finest(
            'Orientation: $orientation, Width: ${MediaQuery.of(context).size.width}, Height: ${MediaQuery.of(context).size.height}');

        double toolbarHeight = 62.0 + 16.0;
        double squareSize;

        appBarUpdated = AppBar(
          title: appBar,
          toolbarHeight: toolbarHeight,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: orientation == Orientation.landscape ? [] : null,
        );

        if (orientation == Orientation.portrait) {
          squareSize = min(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height -
                  toolbarHeight -
                  MediaQuery.of(context).padding.bottom);

          if (panelOne != null && panelTwo != null) {
            if (panelMain != null) {
              // Three panels with squarish main
              body = Container();
            } else {
              // Two panels
              body = Container();
            }
          } else {
            // only Main panel
            body = Container();
          }

          body = Column(
            children: [
              panelOne!,
              Container(
                color: Colors.greenAccent,
                child: SizedBox.square(
                  dimension: squareSize,
                  child: panelMain!,
                ),
              ),
              panelTwo!,
            ],
          );
        } else {
          squareSize = min(
              (MediaQuery.of(context).size.width -
                      MediaQuery.of(context).padding.left) /
                  2,
              MediaQuery.of(context).size.height -
                  toolbarHeight -
                  MediaQuery.of(context).padding.bottom);

          if (panelOne != null && panelTwo != null) {
            if (panelMain != null) {
              // Three panels with squarish main
              body = Row(
                children: [
                  Container(
                    color: Colors.blueGrey,
                    child: SizedBox.square(
                      dimension: squareSize,
                      child: panelMain!,
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(child: panelOne!),
                      Expanded(child: panelTwo!),
                    ],
                  ),
                ],
              );
            } else {
              // Two panels
              body = Container();
            }
          } else {
            // Only main panel
            body = Container();
          }
        }

        return Scaffold(
          appBar: appBarUpdated,
          endDrawer:
              orientation == Orientation.landscape && menuItemsCallback != null
                  ? AppBarDrawer(menuItems, menuItemsCallback!)
                  : null,
          bottomNavigationBar:
              orientation == Orientation.portrait && menuItemsCallback != null
                  ? BottomNavigationBarMain(menuItems, menuItemsCallback!)
                  : null,
          body: Container(
            color: backgroundColor,
            child: SafeArea(
              child: body,
            ),
          ),
        );
      },
    );
  }
}
