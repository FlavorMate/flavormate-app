import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_image/p_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FCircleAvatar extends ConsumerWidget {
  final AccountDto account;
  final double radius;
  final VoidCallback? onTap;
  final Widget? child;

  const FCircleAvatar({
    super.key,
    required this.account,
    this.radius = 20,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initials = account.displayName[0];

    final resolution = UImage.getSquareResolution(context, radius);

    final image = ref.watch(
      pCachedImageProvider(account.avatar?.url(resolution)),
    );

    return InkWell(
      borderRadius: .circular(128),
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            child: CircleAvatar(
              minRadius: radius - (radius * 0.075),
              maxRadius: radius - (radius * 0.075),
              foregroundImage: image.value,
              child: Text(initials),
            ),
          ),
          ?child,
        ],
      ),
    );
  }
}
