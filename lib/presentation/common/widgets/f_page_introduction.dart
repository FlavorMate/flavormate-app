import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/presentation/common/widgets/f_badge.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class FPageIntroduction extends StatelessWidget {
  final M3EShapeKind shape;
  final IconData icon;

  final String? description;

  const FPageIntroduction({
    super.key,
    required this.shape,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FBadge(shape: shape, icon: icon),

        if (description != null) ...[
          const SizedBox(height: PADDING),

          FText(
            description!,
            style: .bodyLarge,
            textAlign: .center,
          ),
        ],
      ],
    );
  }
}
