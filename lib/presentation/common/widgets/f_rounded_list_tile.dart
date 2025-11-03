import 'package:flavormate/core/constants/constants.dart';
import 'package:flutter/material.dart';

class FRoundedListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget title;
  final Function()? onTap;

  const FRoundedListTile({
    super.key,
    this.leading,
    this.trailing,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      trailing: trailing,
      title: title,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
      ),
    );
  }
}
