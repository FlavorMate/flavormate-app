import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/common/widgets/f_scrollable_h.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class SettingsThemeSectionExample extends StatelessWidget {
  const SettingsThemeSectionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FScrollableH(
          child: Row(
            spacing: PADDING,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(
                onPressed: () {},
                child: Text(
                  L10n.of(context).settings_theme_page__example,
                ),
              ),
              Slider(value: 0.5, onChanged: (_) {}),
              Chip(
                label: Text(
                  L10n.of(context).settings_theme_page__example,
                ),
              ),
            ],
          ),
        ),
        FCard(
          child: Column(
            spacing: PADDING,
            children: [
              FText(
                L10n.of(context).settings_theme_page__example,
                style: FTextStyle.headlineMedium,
              ),
              FIconButton(
                onPressed: () {},
                icon: MdiIcons.formatPaint,
                label: L10n.of(
                  context,
                ).settings_theme_page__example,
              ),
            ],
          ),
        ),
        Row(
          spacing: PADDING,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Switch(value: false, onChanged: (_) {}),
            Switch(value: true, onChanged: (_) {}),
            Checkbox(value: false, onChanged: (_) {}),
            Checkbox(value: true, onChanged: (_) {}),
          ],
        ),
        FTextFormField(
          controller: TextEditingController(),
          label: L10n.of(context).settings_theme_page__example,
        ),
        Row(
          spacing: PADDING,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Radio(
              value: false,
              groupValue: null,
              onChanged: (_) {},
            ),
            Radio(value: true, groupValue: true, onChanged: (_) {}),
            const CircularProgressIndicator(),
            const SizedBox(
              width: 48,
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ],
    );
  }
}
