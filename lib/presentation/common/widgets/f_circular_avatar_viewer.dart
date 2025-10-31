import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flutter/material.dart';

class FCircularAvatarViewer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (account.avatar == null) {
      return FCircularAvatar(
        label: account.displayName,
        height: height,
        width: width,
        border: border,
        borderRadius: borderRadius,
      );
    } else {
      final factor = MediaQuery.devicePixelRatioOf(context);

      final quality = switch (width * factor) {
        <= 16 => ImageSquareResolution.P16,
        <= 32 => ImageSquareResolution.P32,
        <= 64 => ImageSquareResolution.P64,
        <= 128 => ImageSquareResolution.P128,
        <= 256 => ImageSquareResolution.P256,
        <= 512 => ImageSquareResolution.P512,
        <= 1024 => ImageSquareResolution.P1024,
        _ => ImageSquareResolution.Original,
      };

      return SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: FImage(
            imageSrc: account.avatar?.url(quality),
            type: FImageType.secure,
          ),
        ),
      );
    }
  }
}
