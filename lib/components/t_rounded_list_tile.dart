import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class TRoundedListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Function()? onTap;

  const TRoundedListTile({
    super.key,
    this.leading,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
      ),
    );
  }
}
