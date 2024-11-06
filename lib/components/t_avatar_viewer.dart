import 'package:flavormate/models/user/user.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvatarViewer extends ConsumerWidget {
  final User user;

  final double fontSize;

  final bool border;
  final double borderRadius;
  final double height;
  final double width;

  const AvatarViewer({
    super.key,
    required this.user,
    this.fontSize = 36,
    this.border = false,
    this.borderRadius = BORDER_RADIUS,
    this.height = 64,
    this.width = 64,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (user.avatar == null) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(borderRadius),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Center(
          child: Text(
            user.displayName[0],
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: fontSize,
            ),
          ),
        ),
      );
    } else {
      final server = ref.read(pServerProvider);

      return SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.network(user.avatar!.path(server)),
        ),
      );
    }
  }
}
