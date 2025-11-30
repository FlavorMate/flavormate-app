import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_circle_avatar.dart';
import 'package:flavormate/presentation/features/home/widgets/search/home_search_bar.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final AccountDto? account;

  const HomeAppBar({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      // floating: true,
      // snap: true,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 64,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          spacing: PADDING,
          children: [
            // Maybe add a drawer icon later if needed
            // const SizedBox(width: 40),
            const Expanded(
              child: HomeSearchBar(elevation: 0),
            ),

            SizedBox(
              width: 40,
              child: account?.let((it) => FCircleAvatar(account: it)),
            ),
          ],
        ),
      ),
    );
  }
}
