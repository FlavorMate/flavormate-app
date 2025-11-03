import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/generated/flutter_gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FLogo extends StatelessWidget {
  final double size;

  const FLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: SvgPicture.asset(
        Assets.icons.logoDynamic.path,
        colorFilter: ColorFilter.mode(
          context.colorScheme.primary,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
