import 'package:flavormate/interfaces/i_page_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_book_page.g.dart';

@riverpod
class PBookPage extends _$PBookPage implements IPageProvider {
  @override
  int build() {
    return 0;
  }

  @override
  void setState(int value) {
    state = value;
  }
}
