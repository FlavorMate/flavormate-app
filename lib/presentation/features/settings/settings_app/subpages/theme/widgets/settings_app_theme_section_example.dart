import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_button.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class SettingsAppThemeSectionExample extends StatelessWidget {
  const SettingsAppThemeSectionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING,
      mainAxisAlignment: .center,
      children: [
        FText(
          context.l10n.settings_app_theme_section_example__title,
          style: .headlineMedium,
        ),
        Card.outlined(
          child: Column(
            spacing: PADDING,
            children: [
              ClipRRect(
                borderRadius: const .only(
                  topLeft: .circular(BORDER_RADIUS),
                  topRight: .circular(BORDER_RADIUS),
                ),
                child: FAppBar(
                  showHome: false,
                  title:
                      context.l10n.settings_app_theme_section_example__app_bar,
                  automaticallyImplyLeading: false,
                ),
              ),

              Padding(
                padding: const .only(
                  left: PADDING,
                  right: PADDING,
                  bottom: PADDING,
                ),
                child: Column(
                  spacing: PADDING,
                  children: [
                    FImageCard.maximized(
                      label: context
                          .l10n
                          .settings_app_theme_section_example__recipe_name,
                      coverSelector: (_) => null,
                      imageType: .asset,
                      width: 400,
                    ),
                    Row(
                      mainAxisAlignment: .center,
                      spacing: PADDING / 2,
                      children: [
                        for (int i = 1; i < 5; i++)
                          FPageableButton(
                            label: '$i',
                            width: FPageableBar.buttonWidth,
                            type: i == 1 ? .current : .other,
                            onPressed: () {},
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
