import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/destination.dart';
import 'package:flavormate/presentation/common/layouts/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

/// Duplicate of [MainLayout] but without the GoRouter dependency
class MainTestLayout extends StatefulWidget {
  final Widget child;
  final int activeIndex;

  const MainTestLayout({
    super.key,
    required this.child,
    required this.activeIndex,
  });

  @override
  State<StatefulWidget> createState() => MainTestLayoutState();
}

class MainTestLayoutState extends State<MainTestLayout> {
  bool wideScreen = false;

  final double _drawerWidth = 250;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width - _drawerWidth > 600;
  }

  List<Destination> buildDestinations(BuildContext context) => [
    Destination(icon: MdiIcons.home, label: context.l10n.main_layout__home),
    Destination(
      icon: MdiIcons.bookshelf,
      label: context.l10n.main_layout__library,
    ),
    Destination(
      icon: MdiIcons.shape,
      label: context.l10n.main_layout__more,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final destinations = buildDestinations(context);
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (wideScreen)
              SizedBox(
                width: _drawerWidth,
                child: NavigationDrawer(
                  onDestinationSelected: (_) {},
                  selectedIndex: widget.activeIndex,
                  children: [
                    const SizedBox(height: 12),
                    for (var destination in destinations)
                      NavigationDrawerDestination(
                        icon: Icon(destination.icon),
                        label: Text(destination.label),
                      ),
                  ],
                ),
              ),
            Expanded(child: widget.child),
          ],
        ),
      ),
      bottomNavigationBar: wideScreen
          ? null
          : NavigationBar(
              selectedIndex: widget.activeIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations: [
                for (var destination in destinations)
                  NavigationDestination(
                    label: destination.label,
                    icon: Icon(destination.icon),
                  ),
              ],
              onDestinationSelected: (_) {},
            ),
    );
  }
}
