import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

enum FThemeTone {
  Material,
  Vivid,
  Chroma
  ;

  FlexTones Function(Brightness) get tone => switch (this) {
    FThemeTone.Material => FlexTones.material,
    FThemeTone.Vivid => FlexTones.vividSurfaces,
    FThemeTone.Chroma => FlexTones.chroma,
  };

  String l10n(BuildContext context) => switch (this) {
    FThemeTone.Material => 'Material',
    FThemeTone.Vivid => 'Vivid',
    FThemeTone.Chroma => 'Chroma',
  };
}
