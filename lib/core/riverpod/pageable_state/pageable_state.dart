enum PageableState {
  accountStories,
  accountRecipes,
  accountBook,
  bookRecipes,
  categories,
  categoryRecipes,
  highlightFull,
  highlightPreview,
  recipeLatestPreview,
  recipeLatestFull,
  storiesPreview,
  storiesFull,
  booksOwnView,
  recipeFiles,
  tagRecipes,
  tags,
  recipes,
  recipeDrafts,
  recipeDraftFiles,
  administrationAccountManagement,
  administrationTokenManagement,
  storyDrafts,
  recipeAddBook,
  recipeAccountList,
  unused;

  String getId(String id) => '${name}_$id';
}
