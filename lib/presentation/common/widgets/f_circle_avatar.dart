import 'package:cached_network_image/cached_network_image.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
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

    final resolution = UImage.getResolution(ref, context, .Plane, radius * 2);

    final image = ref.watch(
      pCachedImageProvider(account.avatar?.url(resolution)),
    );

    if (onTap != null) {
      return InkWell(
        borderRadius: .circular(radius),
        onTap: onTap,
        child: _buildWidget(context, image.value, initials),
      );
    } else {
      return _buildWidget(context, image.value, initials);
    }
  }

  Widget _buildWidget(
    BuildContext context,
    CachedNetworkImageProvider? image,
    String initials,
  ) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: context.colorScheme.primary,
          radius: radius,
          child: CircleAvatar(
            minRadius: radius - (radius * 0.075),
            maxRadius: radius - (radius * 0.075),
            foregroundImage: image,
            child: Text(
              initials,
              style: context.textTheme.bodyMedium!.copyWith(
                fontSize: radius,
              ),
            ),
          ),
        ),
        ?child,
      ],
    );
  }
}
