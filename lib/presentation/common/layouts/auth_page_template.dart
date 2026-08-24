import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/presentation/common/widgets/f_logo.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:material_ui/material_ui.dart';

class AuthPageTemplate extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget bottomChild;
  final List<Widget> children;

  const AuthPageTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.bottomChild,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Align(
          heightFactor: 1,
          alignment: .center,
          child: bottomChild,
        ),
      ),
      body: Center(
        child: FResponsiveCard(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: .start,
              spacing: PADDING * 1.5,
              children: [
                FLogo.sm,
                Column(
                  crossAxisAlignment: .start,
                  spacing: PADDING / 2,
                  children: [
                    FText(
                      title,
                      style: FTextStyle.headlineLarge,
                      fontRoundness: 100,
                    ),
                    FText(
                      subtitle,
                      style: FTextStyle.titleMedium,
                    ),
                  ],
                ),
                Column(
                  spacing: PADDING / 2,
                  children: children,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
