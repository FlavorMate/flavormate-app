import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/models/user/token.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_tokens.g.dart';

@riverpod
class PTokens extends _$PTokens {
  @override
  Future<List<TToken>> build() async {
    return await ref.read(pApiProvider).tokenClient.findAll();
  }

  void sortByUsername(bool sortASC) {
    if (sortASC) {
      state.value!.sort(
        (a, b) => a.owner.username.compareToIgnoreCase(b.owner.username),
      );
    } else {
      state.value!.sort(
        (a, b) => b.owner.username.compareToIgnoreCase(a.owner.username),
      );
    }
    ref.notifyListeners();
  }

  void sortByType(bool sortASC) {
    if (sortASC) {
      state.value!.sort((a, b) => a.type.compareToIgnoreCase(b.type));
    } else {
      state.value!.sort((a, b) => b.type.compareToIgnoreCase(a.type));
    }
    ref.notifyListeners();
  }

  void sortByCreated(bool sortASC) {
    if (sortASC) {
      state.value!.sort((a, b) => a.createdOn!.compareTo(b.createdOn!));
    } else {
      state.value!.sort((a, b) => b.createdOn!.compareTo(a.createdOn!));
    }
    ref.notifyListeners();
  }

  void sortByValidUntil(bool sortASC) {
    if (sortASC) {
      state.value!.sort((a, b) {
        DateTime? tmpA;
        DateTime? tmpB;

        if (a.createdOn != null && a.validFor != null) {
          tmpA = a.createdOn!.add(a.validFor!);
        }

        if (b.createdOn != null && b.validFor != null) {
          tmpB = b.createdOn!.add(b.validFor!);
        }

        if (tmpA != null && tmpB != null) {
          return tmpA.compareTo(tmpB);
        } else if (tmpA == null) {
          return 1;
        } else {
          return -1;
        }
      });
    } else {
      state.value!.sort((a, b) {
        DateTime? tmpA;
        DateTime? tmpB;

        if (a.createdOn != null && a.validFor != null) {
          tmpA = a.createdOn!.add(a.validFor!);
        }

        if (b.createdOn != null && b.validFor != null) {
          tmpB = b.createdOn!.add(b.validFor!);
        }

        if (tmpA != null && tmpB != null) {
          return tmpB.compareTo(tmpA);
        } else if (tmpB == null) {
          return 1;
        } else {
          return -1;
        }
      });
    }
    ref.notifyListeners();
  }

  void sortByUses(bool sortASC) {
    if (sortASC) {
      state.value!.sort((a, b) => a.uses.compareTo(b.uses));
    } else {
      state.value!.sort((a, b) => b.uses.compareTo(a.uses));
    }
    ref.notifyListeners();
  }
}
