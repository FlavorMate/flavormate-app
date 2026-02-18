import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

enum FThemeTone {
  material,
  vivid,
  chroma
  ;

  FlexTones Function(Brightness) get tone => switch (this) {
    FThemeTone.material => FlexTones.material,
    FThemeTone.vivid => FlexTones.vividSurfaces,
    FThemeTone.chroma => FlexTones.chroma,
  };

  String l10n(BuildContext context) => switch (this) {
    FThemeTone.material => 'Material',
    FThemeTone.vivid => 'Vivid',
    FThemeTone.chroma => 'Chroma',
  };
}
