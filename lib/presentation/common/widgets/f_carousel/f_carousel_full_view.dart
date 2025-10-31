import 'package:cached_network_image/cached_network_image.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_jwt.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

class FCarouselFullView extends ConsumerWidget {
  final String url;
  final FImageType imageType;

  const FCarouselFullView({
    super.key,
    required this.url,
    required this.imageType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(pSPJwtProvider);
    final server = ref.watch(pSPCurrentServerProvider);

    return Dialog.fullscreen(
      child: Material(
        color: Colors.black,
        child: SafeArea(
          child: Stack(
            children: [
              PhotoView(
                imageProvider: switch (imageType) {
                  FImageType.asset => AssetImage(url),

                  FImageType.network => CachedNetworkImageProvider(
                    '$server$url',
                  ),

                  FImageType.memory => throw UnimplementedError(),

                  FImageType.secure => CachedNetworkImageProvider(
                    '$server$url',
                    headers: {'Authorization': 'Bearer ${token!.accessToken}'},
                  ),
                },
              ),
              Positioned(
                top: PADDING,
                right: PADDING,
                child: FloatingActionButton(
                  onPressed: () => context.pop(),
                  child: const Icon(MdiIcons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
