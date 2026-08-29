import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/accounts/account_file_dto.dart';
import 'package:flavormate/data/models/features/stories/story_dto.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_books.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_recipes.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_stories.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_carousel/f_carousel.dart';
import 'package:flavormate/presentation/common/widgets/f_circle_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class AccountsItemPage extends ConsumerStatefulWidget {
  final String id;

  const AccountsItemPage({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountsItemPageState();
}

class _AccountsItemPageState extends ConsumerState<AccountsItemPage> {
  final _scrollController = ScrollController();

  PRestAccountsIdProvider get provider => pRestAccountsIdProvider(widget.id);

  PRestAccountsIdBooksProvider get booksProvider =>
      pRestAccountsIdBooksProvider(
        accountId: widget.id,
        pageProviderId: PageableState.unused.name,
      );

  PRestAccountsIdRecipesProvider get recipesProvider =>
      pRestAccountsIdRecipesProvider(
        accountId: widget.id,
        pageProviderId: PageableState.unused.name,
      );

  PRestAccountsIdStoriesProvider get storiesProvider =>
      pRestAccountsIdStoriesProvider(
        accountId: widget.id,
        pageProviderId: PageableState.unused.name,
      );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyListenable = ref.watch(storiesProvider);
    final bookListenable = ref.watch(booksProvider);
    final recipeListenable = ref.watch(recipesProvider);

    final storyData = storyListenable.value;
    final bookData = bookListenable.value;
    final recipeData = recipeListenable.value;

    return FProviderPage(
      provider: provider,
      appBarBuilder: (_, data) => FAppBar(
        title: data.displayName,
        scrollController: _scrollController,
      ),
      builder: (context, data) => FResponsive(
        controller: _scrollController,
        child: Column(
          spacing: PADDING,
          children: [
            FCircleAvatar(
              account: data,
              radius: 56,
              onTap: () => showAvatar(context, data.avatar!),
            ),
            Center(
              child: FText(
                data.displayName,
                style: FTextStyle.headlineMedium,
                fontRoundness: 100,
              ),
            ),

            const Divider(),

            FCarousel<StoryPreviewDto>(
              title: context.l10n.accounts_item_page__stories,
              data: storyData?.data ?? [],
              loading: storyListenable.isLoading,
              error: storyListenable.hasError
                  ? context.l10n.accounts_item_page__stories_on_error
                  : null,
              onTap: (story) => context.routes.storiesItem(story.id),
              labelSelector: (story) => story.label,
              coverSelector: (story, resolution) =>
                  story.cover?.url(resolution),
              onShowAll: () => context.routes.accountsItemStories(widget.id),
            ),

            FCarousel(
              title: context.l10n.accounts_item_page__books,
              data: bookData?.data ?? [],
              loading: bookListenable.isLoading,
              error: bookListenable.hasError
                  ? context.l10n.accounts_item_page__books_on_error
                  : null,
              onTap: (book) => context.routes.libraryItem(book.id),
              labelSelector: (book) => book.label,
              coverSelector: (book, resolution) => book.cover?.url(resolution),
              onShowAll: () => context.routes.accountsItemBooks(widget.id),
            ),

            FCarousel(
              title: context.l10n.accounts_item_page__recipes,
              data: recipeData?.data ?? [],
              loading: recipeListenable.isLoading,
              error: recipeListenable.hasError
                  ? context.l10n.accounts_item_page__recipes_on_error
                  : null,
              onTap: (recipe) => context.routes.recipesItem(recipe.id),
              labelSelector: (recipe) => recipe.label,
              coverSelector: (recipe, resolution) =>
                  recipe.cover?.url(resolution),
              onShowAll: () => context.routes.accountsItemRecipes(widget.id),
            ),
          ],
        ),
      ),
      onError: FEmptyMessage(
        title: context.l10n.accounts_item_page__on_error,
        icon: IconConstants.errorIcon,
      ),
    );
  }

  Future showAvatar(
    BuildContext context,
    AccountFileDto avatar,
  ) {
    return context.showFullscreenImage(
      avatar.url(ImageResolution.Original),
    );
  }
}
