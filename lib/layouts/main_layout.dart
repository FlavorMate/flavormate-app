import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/destination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<StatefulWidget> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  bool wideScreen = false;

  final double _drawerWidth = 250;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width - _drawerWidth > 600;
  }

  List<Destination> buildDestinations(BuildContext context) => [
        Destination(
          icon: MdiIcons.home,
          label: L10n.of(context).l_main_home,
        ),
        Destination(
          icon: MdiIcons.bookshelf,
          label: L10n.of(context).l_main_library,
        ),
        Destination(
          icon: MdiIcons.shape,
          label: L10n.of(context).l_main_more,
        ),
        Destination(
          icon: MdiIcons.cog,
          label: L10n.of(context).l_main_settings,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final destinations = buildDestinations(context);
    return Scaffold(
      appBar: TAppBar(
        title: L10n.of(context).app_title,
        showHome: false,
      ),
      body: Row(
        children: [
          if (wideScreen)
            SizedBox(
              width: _drawerWidth,
              child: NavigationDrawer(
                onDestinationSelected: _goBranch,
                selectedIndex: widget.navigationShell.currentIndex,
                children: [
                  const SizedBox(height: 12),
                  for (var destination in destinations)
                    NavigationDrawerDestination(
                      icon: Icon(destination.icon),
                      label: Text(destination.label),
                    )
                ],
              ),
            ),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: wideScreen
          ? null
          : NavigationBar(
              selectedIndex: widget.navigationShell.currentIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations: [
                for (var destination in destinations)
                  NavigationDestination(
                    label: destination.label,
                    icon: Icon(destination.icon),
                  ),
              ],
              onDestinationSelected: _goBranch,
            ),
    );
  }
}
