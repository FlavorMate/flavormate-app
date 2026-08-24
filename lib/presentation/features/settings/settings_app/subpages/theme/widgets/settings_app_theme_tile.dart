import 'package:flavormate/core/constants/color_constants.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class SettingsAppThemeTile extends StatelessWidget {
  final bool isSelected;
  final Color color;
  final String label;
  final void Function(Color) onTap;

  const SettingsAppThemeTile({
    super.key,
    required this.isSelected,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final contentColor = calcColorForText(color);

    return Material(
      color: color,
      child: ListTile(
        visualDensity: .standard,
        textColor: contentColor,
        leading: Icon(
          isSelected ? Symbols.check_circle_rounded : Symbols.circle_rounded,
          color: contentColor,
        ),
        title: Text(label),
        onTap: () => onTap.call(color),
      ),
    );
  }
}

class SettingsAppThemeTileData {
  final bool isSelected;
  final Color color;
  final String label;
  final void Function(Color) onTap;

  const SettingsAppThemeTileData({
    required this.isSelected,
    required this.color,
    required this.label,
    required this.onTap,
  });
}
