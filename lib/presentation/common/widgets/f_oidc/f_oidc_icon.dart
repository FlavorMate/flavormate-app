import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FOidcIcon extends ConsumerWidget {
  final OIDCProvider provider;
  final double height;
  final double width;

  const FOidcIcon({
    super.key,
    required this.provider,
    this.height = 50,
    this.width = 50,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.read(pSPCurrentServerProvider);

    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
        child: Image.network(
          '$server/${provider.iconPath!}',
          errorBuilder: (_, _, _) => FCircularAvatar(
            label: provider.name[0],
            border: true,
          ),
        ),
      ),
    );
  }
}
