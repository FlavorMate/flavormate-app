import 'package:flavormate/core/cache/cache_image_provider.dart';
import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/core/utils/u_image.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/components/buttons/m3e_buttons.dart';
import 'package:material_ui/material_ui.dart';

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

    final image = account.avatar
        ?.url(resolution)
        .let((it) => ref.watch(pCachedImageProvider(it)));

    return _buildWidget(context, image, initials);
  }

  Widget _buildWidget(
    BuildContext context,
    CacheImageProvider? image,
    String initials,
  ) {
    return SizedBox(
      height: radius * 2,
      width: radius * 2,
      child: M3EButton(
        onPressed: onTap,
        decoration: .styleFrom(
          backgroundBuilder: (_, _, _) => Material(
            color: context.colorScheme.primary,
            child: Stack(
              fit: .expand,
              children: [
                Center(
                  child: Text(
                    initials,
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontSize: radius,
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ),
                ?image?.let(
                  (it) => Image(
                    image: it,
                    fit: .cover,
                  ),
                ),
                ?child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
