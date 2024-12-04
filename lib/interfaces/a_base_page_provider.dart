import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract class BasePageProvider extends AutoDisposeNotifier<int> {
  void setState(int value) {
    state = value;
  }
}
