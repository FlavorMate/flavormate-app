import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FCircularAvatarViewer extends ConsumerWidget {
  final AccountDto account;

  final bool border;
  final double borderRadius;
  final double height;
  final double width;

  const FCircularAvatarViewer({
    super.key,
    required this.account,
    this.border = false,
    this.borderRadius = BORDER_RADIUS,
    this.height = 64,
    this.width = 64,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (account.avatar == null) {
      return FCircularAvatar(
        label: account.displayName,
        height: height,
        width: width,
        border: border,
        borderRadius: borderRadius,
      );
    } else {
      final resolution = UImage.getResolution(ref, context, .Plane, width);

      return SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: FImage(
            imageSrc: account.avatar?.url(resolution),
            type: FImageType.secure,
          ),
        ),
      );
    }
  }
}
