import 'package:flavormate/interfaces/i_page_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_tag_page.g.dart';

@riverpod
class PTagPage extends _$PTagPage implements IPageProvider {
  @override
  int build() {
    return 0;
  }

  @override
  void setState(int value) {
    state = value;
  }
}
