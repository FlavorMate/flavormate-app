import 'package:flavormate/data/models/features/accounts/account_dto.dart';

import '../account_files/account_files.dart';

class AccountFulls {
  static final aThenus = AccountFullDto(
    id: 'd6fc559f-ddc1-4bc2-a9c1-c8a17ff5ffcc',
    displayName: 'Thenus',
    avatar: AccountFiles.afThenus,
    username: 'thenus',
    diet: .Meat,
    email: 'thenus@example.com',
    enabled: true,
    verified: true,
    firstLogin: false,
    createdOn: DateTime(2024, 09, 16, 17, 16, 54),
    lastActivity: null,
    roles: const ['User', 'Admin'],
  );
}

class AccountPreviews {
  static const aThenus = AccountPreviewDto(
    id: 'd6fc559f-ddc1-4bc2-a9c1-c8a17ff5ffcc',
    displayName: 'Thenus',
    avatar: AccountFiles.afThenus,
    username: 'thenus',
  );
}
