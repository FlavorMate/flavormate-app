import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_ui/material_ui.dart';

class FRecipeTitle extends StatelessWidget {
  final String title;

  const FRecipeTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return FText(
      title,
      style: FTextStyle.headlineMedium,
      textAlign: TextAlign.center,
      fontWeight: FontWeight.bold,
      fontRoundness: 100,
    );
  }
}
