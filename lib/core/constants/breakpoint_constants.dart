import 'package:flutter/material.dart';

enum FBreakpoint {
  xs(xsValue),
  sm(smValue),
  md(mdValue),
  lg(lgValue),
  xl(xlValue)
  ;

  static const double xsValue = 325;
  static const double smValue = 600;
  static const double mdValue = 900;
  static const double lgValue = 1200;
  static const double xlValue = 1536;

  final double size;

  const FBreakpoint(this.size);

  static FBreakpoint getCurrent(double inputWidth) {
    if (inputWidth <= FBreakpoint.xs.size) return FBreakpoint.xs;
    if (inputWidth <= FBreakpoint.sm.size) return FBreakpoint.sm;
    if (inputWidth <= FBreakpoint.md.size) return FBreakpoint.md;
    if (inputWidth <= FBreakpoint.lg.size) return FBreakpoint.lg;
    return FBreakpoint.xl;
  }

  FBreakpoint? get previous {
    return switch (this) {
      FBreakpoint.xs => null,
      FBreakpoint.sm => FBreakpoint.xs,
      FBreakpoint.md => FBreakpoint.sm,
      FBreakpoint.lg => FBreakpoint.md,
      FBreakpoint.xl => FBreakpoint.lg,
    };
  }

  FBreakpoint? get next {
    return switch (this) {
      FBreakpoint.xs => FBreakpoint.sm,
      FBreakpoint.sm => FBreakpoint.md,
      FBreakpoint.md => FBreakpoint.lg,
      FBreakpoint.lg => FBreakpoint.xl,
      FBreakpoint.xl => null,
    };
  }

  static bool gt(BuildContext context, FBreakpoint bp) {
    return MediaQuery.sizeOf(context).width >= bp.size;
  }

  static bool lt(BuildContext context, FBreakpoint bp) {
    return MediaQuery.sizeOf(context).width < bp.size;
  }
}
