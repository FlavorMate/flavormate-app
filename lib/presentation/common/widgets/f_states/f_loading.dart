import 'package:material_3_expressive/components/loading_indicator/m3e_loading_indicator.dart';
import 'package:material_ui/material_ui.dart';

class FLoading extends StatelessWidget {
  const FLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: M3ELoadingIndicator(),
    );
  }
}
