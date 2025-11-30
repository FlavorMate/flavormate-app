import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_image/p_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FCircleAvatar extends ConsumerWidget {
  final AccountDto account;
  final double radius;

  const FCircleAvatar({super.key, required this.account, this.radius = 20});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initials = account.displayName[0];

    final resolution = UImage.getSquareResolution(context, radius);

    final image = ref.watch(
      pCachedImageProvider(account.avatar?.url(resolution)),
    );

    return CircleAvatar(
      minRadius: radius,
      maxRadius: radius,
      foregroundImage: image.value,
      child: Text(initials),
    );
  }
}
