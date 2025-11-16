import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/accounts/account_file_dto.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_books.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_recipes.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_stories.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_carousel/f_carousel.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar_viewer.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_ink_well.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsItemPage extends ConsumerWidget {
  final String id;

  const AccountsItemPage({super.key, required this.id});

  PRestAccountsIdProvider get provider => pRestAccountsIdProvider(id);

  PRestAccountsIdBooksProvider get booksProvider =>
      pRestAccountsIdBooksProvider(
        accountId: id,
        pageProviderId: PageableState.unused.name,
      );

  PRestAccountsIdRecipesProvider get recipesProvider =>
      pRestAccountsIdRecipesProvider(
        accountId: id,
        pageProviderId: PageableState.unused.name,
      );

  PRestAccountsIdStoriesProvider get storiesProvider =>
      pRestAccountsIdStoriesProvider(
        accountId: id,
        pageProviderId: PageableState.unused.name,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FProviderPage(
      provider: provider,
      appBarBuilder: (_, data) => FAppBar(title: data.displayName),
      builder: (context, data) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PADDING),
          child: Column(
            spacing: PADDING,
            children: [
              Center(
                child: FImageInkWell(
                  height: 192,
                  width: 192,
                  onTap: () => showAvatar(context, data.avatar!),
                  child: FCircularAvatarViewer(
                    account: data,
                    height: 192,
                    width: 192,
                  ),
                ),
              ),
              Center(
                child: FText(
                  data.displayName,
                  style: FTextStyle.displayMedium,
                ),
              ),

              const Divider(),

              FProviderStruct(
                provider: storiesProvider,
                builder: (_, data) => data.data.isNotEmpty
                    ? FCarousel(
                        title: L10n.of(context).accounts_item_page__stories,
                        data: data.data.toList(),
                        onTap: (story) => context.routes.storiesItem(story.id),
                        labelSelector: (story) => story.label,
                        coverSelector: (story, resolution) =>
                            story.cover?.url(resolution),
                        onShowAll: () => context.routes.accountsItemStories(id),
                      )
                    : const SizedBox.shrink(),
                onError: FEmptyMessage(
                  title: L10n.of(context).accounts_item_page__stories_on_error,
                  icon: StateIconConstants.stories.errorIcon,
                ),
              ),

              FProviderStruct(
                provider: booksProvider,
                builder: (_, data) => data.data.isNotEmpty
                    ? FCarousel(
                        title: L10n.of(context).accounts_item_page__books,
                        data: data.data.toList(),
                        onTap: (book) => context.routes.libraryItem(book.id),
                        labelSelector: (book) => book.label,
                        coverSelector: (book, resolution) =>
                            book.cover?.url(resolution),
                        onShowAll: () => context.routes.accountsItemBooks(id),
                      )
                    : const SizedBox.shrink(),

                onError: FEmptyMessage(
                  title: L10n.of(context).accounts_item_page__books_on_error,
                  icon: StateIconConstants.books.errorIcon,
                ),
              ),

              FProviderStruct(
                provider: recipesProvider,
                builder: (_, data) => data.data.isNotEmpty
                    ? FCarousel(
                        title: L10n.of(context).accounts_item_page__recipes,
                        data: data.data,
                        onTap: (recipe) =>
                            context.routes.recipesItem(recipe.id),
                        labelSelector: (recipe) => recipe.label,
                        coverSelector: (recipe, resolution) =>
                            recipe.cover?.url(resolution),
                        onShowAll: () => context.routes.accountsItemRecipes(id),
                      )
                    : const SizedBox.shrink(),
                onError: FEmptyMessage(
                  title: L10n.of(context).accounts_item_page__recipes_on_error,
                  icon: StateIconConstants.recipes.errorIcon,
                ),
              ),
            ],
          ),
        ),
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).accounts_item_page__on_error,
        icon: StateIconConstants.authors.errorIcon,
      ),
    );
  }

  Future showAvatar(
    BuildContext context,
    AccountFileDto avatar,
  ) {
    return context.showFullscreenImage(
      avatar.url(ImageSquareResolution.Original),
    );
  }
}
