abstract class ApiConstants {
  static const Root = '/v3';

  static const Version = '$Root/version/';
  static const Features = '$Root/features/';
  static const Ping = '$Root/version/';
  static const Bring = '$Root/bring';

  static const Recovery = '$Root/recovery/password/reset';
  static const Registration = '$Root/registration';

  static const Share = '$Root/share';

  static String shareRecipe(String id) => '$Share/$id';

  static const CoreAuth = '$Root/auth';
  static const CoreFeatures = '$Root/features';
  static const CoreVersion = '$Root/version';

  static const ExtensionBring = '$Root/bring';
  static const ExtensionOIDC = '$Root/oidc';
  static const ExtensionRatings = '$Root/ratings';
  static const ExtensionScrape = '$Root/scraper';
  static const ExtensionShare = '$Root/share';

  static const FeatureAccounts = '$Root/accounts';
  static const FeatureAdmin = '$Root/admin';
  static const FeatureBooks = '$Root/books';
  static const FeatureCategories = '$Root/categories';
  static const FeatureCategoryGroups = '$Root/category-groups';
  static const FeatureHighlights = '$Root/highlights';
  static const FeatureRecipes = '$Root/recipes';
  static const FeatureRecipeDrafts = '$Root/recipe-drafts';
  static const FeatureStories = '$Root/stories';
  static const FeatureStoryDrafts = '$Root/story-drafts';
  static const FeatureTags = '$Root/tags';
  static const FeatureUnits = '$Root/units';
}
