import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/destination.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<StatefulWidget> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  // Default Material 3 spec
  static const double _drawerWidth = 304;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width - _drawerWidth > FBreakpoint.smValue;
  }

  List<Destination> buildDestinations(BuildContext context) => [
    Destination(
      icon: Symbols.home_rounded,
      label: context.l10n.main_layout__home,
    ),
    Destination(
      icon: Symbols.newsstand_rounded,
      label: context.l10n.main_layout__library,
    ),
    Destination(
      icon: Symbols.shapes_rounded,
      label: context.l10n.main_layout__more,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cardTheme = M3ETheme.of(context).listTheme.cardList;

    final destinations = buildDestinations(context);

    return Scaffold(
      body: SafeArea(
        // prevent clipping issues with search bar dialog and navigation rail
        top: false,
        bottom: false,
        child: Row(
          children: [
            if (wideScreen)
              M3ENavigationRail(
                background: context.colorScheme.surfaceContainerLow,
                type: .alwaysExpand,
                onDestinationSelected: _goBranch,
                selectedIndex: widget.navigationShell.currentIndex,
                sections: [
                  M3ENavigationRailSection(
                    destinations: [
                      for (var destination in destinations)
                        M3ENavigationRailDestination(
                          icon: Icon(destination.icon),
                          label: destination.label,
                        ),
                    ],
                  ),
                ],
              ),
            Expanded(child: widget.navigationShell),
          ],
        ),
      ),
      bottomNavigationBar: wideScreen
          ? null
          : M3ENavigationBar(
              selectedIndex: widget.navigationShell.currentIndex,
              labelBehavior: .alwaysHide,
              destinations: [
                for (var destination in destinations)
                  M3ENavigationBarDestination(
                    label: destination.label,
                    icon: Icon(destination.icon),
                  ),
              ],
              onDestinationSelected: _goBranch,
            ),
    );
  }
}
