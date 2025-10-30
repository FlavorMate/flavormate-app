import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_pageable_state.g.dart';

@riverpod
class PPageableState extends _$PPageableState {
  @override
  int build(String pageId) {
    return 0;
  }

  void increment() {
    state++;
  }

  void decrement() {
    if (state >= 1) {
      state--;
    }
  }

  void setPage(int newPage) {
    state = newPage;
  }
}
