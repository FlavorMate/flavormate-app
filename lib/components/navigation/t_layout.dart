import 'package:collection/collection.dart';
import 'package:flavormate/components/navigation/t_section.dart';
import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/models/Destination.dart';
import 'package:flutter/material.dart';

class TLayout extends StatefulWidget {
  final String title;
  final List<Destination> destinations;
  final List<Widget> sections;
  final List<Widget>? actions;

  const TLayout({
    super.key,
    required this.destinations,
    required this.title,
    required this.sections,
    this.actions,
  });

  final double _drawerWidth = 250;

  @override
  State<StatefulWidget> createState() => TLayoutState();
}

class TLayoutState extends State<TLayout> {
  bool wideScreen = false;
  int currentIndex = 0;

  @override
  void initState() {
    if (widget.destinations.length < 3) {
      throw Exception('Provide at least 3 destinations!');
    }
    if (widget.sections.length < 3) {
      throw Exception('Provide at least 3 sections!');
    }

    if (widget.sections.length != widget.destinations.length) {
      throw Exception(
          'Provided ${widget.destinations.length} destinations but ${widget.sections.length} sections!');
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width - widget._drawerWidth > 600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: widget.title,
        actions: widget.actions,
      ),
      body: Row(
        children: [
          if (wideScreen)
            SizedBox(
              width: widget._drawerWidth,
              child: NavigationDrawer(
                onDestinationSelected: _setSection,
                selectedIndex: currentIndex,
                backgroundColor: Colors.white,
                children: [
                  const SizedBox(height: 12),
                  for (var destination in widget.destinations)
                    NavigationDrawerDestination(
                      icon: Icon(destination.icon),
                      label: Text(destination.label),
                    )
                ],
              ),
            ),
          Expanded(
            child: Stack(
              children: widget.sections
                  .mapIndexed((index, child) => TSection(
                        active: index == currentIndex,
                        child: child,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: wideScreen
          ? null
          : NavigationBar(
              selectedIndex: currentIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations: [
                for (var destination in widget.destinations)
                  NavigationDestination(
                    label: destination.label,
                    icon: Icon(destination.icon),
                  ),
              ],
              onDestinationSelected: _setSection,
            ),
    );
  }

  void _setSection(int value) {
    setState(() {
      currentIndex = value;
    });
  }
}
