import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class FFullDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback submit;

  const FFullDialog({
    super.key,
    required this.title,
    required this.submit,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: FAppBar(
          title: title,
          scrollController: null,
        ),
        body: FResponsive(child: child),
        bottomNavigationBar: SafeArea(
          minimum: const .only(right: PADDING, bottom: PADDING),
          child: Row(
            spacing: PADDING,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              M3EButton.text(
                onPressed: () => context.pop(),
                child: Text(context.l10n.btn_cancel),
              ),
              M3EButton(
                onPressed: submit,
                child: Text(context.l10n.btn_save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
