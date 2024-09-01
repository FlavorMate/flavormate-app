import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_image_label.dart';
import 'package:flavormate/components/t_pageable.dart';
import 'package:flavormate/components/t_wrap.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/authors/p_author_page.dart';
import 'package:flavormate/riverpod/authors/p_authors.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthorsPage extends StatelessWidget {
  const AuthorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: L10n.of(context).p_authors),
      body: SafeArea(
        child: TPageable(
          provider: pAuthorsProvider,
          pageProvider: pAuthorPageProvider,
          builder: (_, authors) => TWrap(
            children: authors.content
                .map(
                  (author) => SizedBox(
                    width: 450,
                    child: TCard(
                      padding: 0,
                      onTap: () => context.pushNamed(
                        'author',
                        pathParameters: {'id': author.id.toString()},
                        extra: author.account.displayName,
                      ),
                      child: TImageLabel(
                        imageSrc: author.account.avatar
                            ?.path(context.read(pServerProvider)!),
                        height: 200,
                        title: author.account.displayName,
                        labelSize: 0.4,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          onPressed: (ref, value) =>
              ref.read(pAuthorPageProvider.notifier).setState(value),
        ),
      ),
    );
  }
}
