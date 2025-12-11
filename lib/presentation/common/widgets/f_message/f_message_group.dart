import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_circle_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_message/f_message.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FMessageGroup extends StatelessWidget {
  final AccountDto account;
  final List<FMessage> messages;

  final double borderRadius = 24;

  const FMessageGroup({
    super.key,
    required this.account,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    final widgets = List.generate(messages.length, (index) {
      final isFirst = index == 0;
      final isLast = index == messages.length - 1;
      final item = messages[index];

      final topLeft = isFirst ? borderRadius : 4.0;
      final topRight = borderRadius;
      final bottomLeft = isLast ? borderRadius : 4.0;
      final bottomRight = borderRadius;
      return ClipRRect(
        borderRadius: .only(
          topLeft: .circular(topLeft),
          topRight: .circular(topRight),
          bottomLeft: .circular(bottomLeft),
          bottomRight: .circular(bottomRight),
        ),
        child: item,
      );
    });

    return Row(
      crossAxisAlignment: .end,
      spacing: PADDING / 2,
      children: [
        FCircleAvatar(
          account: account,
          radius: 25,
          onTap: () => context.routes.accountsItem(account.id),
        ),
        Expanded(
          child: Column(
            spacing: 2,
            crossAxisAlignment: .start,
            children: [
              FText(
                account.displayName,
                style: .bodyMedium,
                weight: .w500,
                color: .primary,
              ),

              ...widgets,
            ],
          ),
        ),
      ],
    );
  }
}
