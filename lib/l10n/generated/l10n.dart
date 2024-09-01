import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_de.dart';
import 'l10n_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @pageHomeQuickAllRecipes.
  ///
  /// In en, this message translates to:
  /// **'All Recipes'**
  String get pageHomeQuickAllRecipes;

  /// No description provided for @pageHomeQuickRandomRecipe.
  ///
  /// In en, this message translates to:
  /// **'Random Recipe'**
  String get pageHomeQuickRandomRecipe;

  /// No description provided for @pageHomeQuickWhatToBake.
  ///
  /// In en, this message translates to:
  /// **'What should I bake today?'**
  String get pageHomeQuickWhatToBake;

  /// No description provided for @pageHomeQuickWhatToCook.
  ///
  /// In en, this message translates to:
  /// **'What should i bake today?'**
  String get pageHomeQuickWhatToCook;

  /// No description provided for @pageHomeHighlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get pageHomeHighlights;

  /// No description provided for @pageHomeStories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get pageHomeStories;

  /// No description provided for @pageHomeLatestRecipes.
  ///
  /// In en, this message translates to:
  /// **'Latest Recipes'**
  String get pageHomeLatestRecipes;

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'FlavorMate'**
  String get app_title;

  /// No description provided for @c_dashboard_highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get c_dashboard_highlights;

  /// No description provided for @c_dashboard_latest.
  ///
  /// In en, this message translates to:
  /// **'Latest recipes'**
  String get c_dashboard_latest;

  /// No description provided for @c_dashboard_stories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get c_dashboard_stories;

  /// No description provided for @c_dashboard_quick_actions_cook.
  ///
  /// In en, this message translates to:
  /// **'What should I cook?'**
  String get c_dashboard_quick_actions_cook;

  /// No description provided for @c_dashboard_quick_actions_bake.
  ///
  /// In en, this message translates to:
  /// **'What should I bake?'**
  String get c_dashboard_quick_actions_bake;

  /// No description provided for @c_dashboard_quick_actions_random.
  ///
  /// In en, this message translates to:
  /// **'Random recipe'**
  String get c_dashboard_quick_actions_random;

  /// No description provided for @c_dashboard_quick_actions_all.
  ///
  /// In en, this message translates to:
  /// **'All recipes'**
  String get c_dashboard_quick_actions_all;

  /// No description provided for @btn_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btn_cancel;

  /// No description provided for @btn_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get btn_yes;

  /// No description provided for @d_library_create_title.
  ///
  /// In en, this message translates to:
  /// **'Add new book'**
  String get d_library_create_title;

  /// No description provided for @d_library_create_label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get d_library_create_label;

  /// No description provided for @btn_create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get btn_create;

  /// No description provided for @d_library_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit book'**
  String get d_library_edit_title;

  /// No description provided for @d_library_edit_name.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get d_library_edit_name;

  /// No description provided for @btn_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get btn_save;

  /// No description provided for @d_recipe_library_title.
  ///
  /// In en, this message translates to:
  /// **'Add to library'**
  String get d_recipe_library_title;

  /// No description provided for @btn_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get btn_close;

  /// No description provided for @c_recipe_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get c_recipe_categories;

  /// No description provided for @c_recipe_tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get c_recipe_tags;

  /// No description provided for @c_recipe_informations.
  ///
  /// In en, this message translates to:
  /// **'Informations'**
  String get c_recipe_informations;

  /// No description provided for @c_recipe_duration_prep.
  ///
  /// In en, this message translates to:
  /// **'Prep time'**
  String get c_recipe_duration_prep;

  /// No description provided for @c_recipe_duration_cook.
  ///
  /// In en, this message translates to:
  /// **'Cook time'**
  String get c_recipe_duration_cook;

  /// No description provided for @c_recipe_duration_rest.
  ///
  /// In en, this message translates to:
  /// **'Rest time'**
  String get c_recipe_duration_rest;

  /// No description provided for @c_bring_btn.
  ///
  /// In en, this message translates to:
  /// **'Add to shopping list'**
  String get c_bring_btn;

  /// No description provided for @c_recipe_bookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark recipe'**
  String get c_recipe_bookmark;

  /// No description provided for @c_recipe_instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get c_recipe_instructions;

  /// No description provided for @c_recipe_ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get c_recipe_ingredients;

  /// No description provided for @c_recipe_ingredients_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get c_recipe_ingredients_amount;

  /// No description provided for @c_recipe_ingredients_ingredient.
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
  String get c_recipe_ingredients_ingredient;

  /// No description provided for @c_recipe_author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get c_recipe_author;

  /// No description provided for @c_recipe_published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get c_recipe_published;

  /// No description provided for @c_recipe_published_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get c_recipe_published_version;

  /// No description provided for @c_recipe_published_origin.
  ///
  /// In en, this message translates to:
  /// **'Open origin'**
  String get c_recipe_published_origin;

  /// No description provided for @c_search_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading ...'**
  String get c_search_loading;

  /// No description provided for @c_search_nothing_found.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get c_search_nothing_found;

  /// No description provided for @c_search_search_term_too_short.
  ///
  /// In en, this message translates to:
  /// **'Enter more than 3 characters'**
  String get c_search_search_term_too_short;

  /// No description provided for @c_search_label_author.
  ///
  /// In en, this message translates to:
  /// **'Search for authors'**
  String get c_search_label_author;

  /// No description provided for @c_search_label_book.
  ///
  /// In en, this message translates to:
  /// **'Search for books'**
  String get c_search_label_book;

  /// No description provided for @c_search_label_category.
  ///
  /// In en, this message translates to:
  /// **'Search for categories'**
  String get c_search_label_category;

  /// No description provided for @c_search_label_recipe.
  ///
  /// In en, this message translates to:
  /// **'Search for recipes'**
  String get c_search_label_recipe;

  /// No description provided for @c_search_label_tag.
  ///
  /// In en, this message translates to:
  /// **'Search for tags'**
  String get c_search_label_tag;

  /// No description provided for @c_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search ...'**
  String get c_search_hint;

  /// No description provided for @e_duration_day.
  ///
  /// In en, this message translates to:
  /// **'d.'**
  String get e_duration_day;

  /// No description provided for @e_duration_hour.
  ///
  /// In en, this message translates to:
  /// **'h.'**
  String get e_duration_hour;

  /// No description provided for @e_duration_minute.
  ///
  /// In en, this message translates to:
  /// **'min.'**
  String get e_duration_minute;

  /// No description provided for @e_duration_second.
  ///
  /// In en, this message translates to:
  /// **'sec.'**
  String get e_duration_second;

  /// No description provided for @l_main_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get l_main_home;

  /// No description provided for @l_main_library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get l_main_library;

  /// No description provided for @l_main_more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get l_main_more;

  /// No description provided for @l_main_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get l_main_settings;

  /// No description provided for @p_author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get p_author;

  /// No description provided for @p_authors.
  ///
  /// In en, this message translates to:
  /// **'Authors'**
  String get p_authors;

  /// No description provided for @p_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get p_category;

  /// No description provided for @p_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get p_categories;

  /// No description provided for @p_library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get p_library;

  /// No description provided for @p_book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get p_book;

  /// No description provided for @p_library_private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get p_library_private;

  /// No description provided for @p_library_public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get p_library_public;

  /// No description provided for @p_library_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get p_library_edit;

  /// No description provided for @p_library_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get p_library_share;

  /// No description provided for @p_library_unshare.
  ///
  /// In en, this message translates to:
  /// **'Unshare'**
  String get p_library_unshare;

  /// No description provided for @p_library_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get p_library_delete;

  /// No description provided for @d_library_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete book?'**
  String get d_library_delete_title;

  /// No description provided for @p_login_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get p_login_username;

  /// No description provided for @p_login_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get p_login_password;

  /// No description provided for @btn_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get btn_login;

  /// No description provided for @p_login_error.
  ///
  /// In en, this message translates to:
  /// **'Error on login'**
  String get p_login_error;

  /// No description provided for @p_more_recipes.
  ///
  /// In en, this message translates to:
  /// **'Create recipe'**
  String get p_more_recipes;

  /// No description provided for @p_more_title.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get p_more_title;

  /// No description provided for @p_more_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get p_more_categories;

  /// No description provided for @p_more_tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get p_more_tags;

  /// No description provided for @p_recipe_title.
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get p_recipe_title;

  /// No description provided for @p_recipe_error_bring.
  ///
  /// In en, this message translates to:
  /// **'Bring could not be opened'**
  String get p_recipe_error_bring;

  /// No description provided for @p_recipes_title.
  ///
  /// In en, this message translates to:
  /// **'All recipes'**
  String get p_recipes_title;

  /// No description provided for @en_course_appetizer.
  ///
  /// In en, this message translates to:
  /// **'Appetizer'**
  String get en_course_appetizer;

  /// No description provided for @en_course_main_dish.
  ///
  /// In en, this message translates to:
  /// **'Main dish'**
  String get en_course_main_dish;

  /// No description provided for @en_course_dessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get en_course_dessert;

  /// No description provided for @en_course_side_dish.
  ///
  /// In en, this message translates to:
  /// **'Side dish'**
  String get en_course_side_dish;

  /// No description provided for @en_course_bakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get en_course_bakery;

  /// No description provided for @en_course_drink.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get en_course_drink;

  /// No description provided for @en_diet_meat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get en_diet_meat;

  /// No description provided for @en_diet_fish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get en_diet_fish;

  /// No description provided for @en_diet_vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get en_diet_vegetarian;

  /// No description provided for @en_diet_vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get en_diet_vegan;

  /// No description provided for @p_settings_manage_avatar.
  ///
  /// In en, this message translates to:
  /// **'Manage avatar'**
  String get p_settings_manage_avatar;

  /// No description provided for @p_settings_manage_diet.
  ///
  /// In en, this message translates to:
  /// **'Manage diet'**
  String get p_settings_manage_diet;

  /// No description provided for @p_settings_change_mail.
  ///
  /// In en, this message translates to:
  /// **'Change mail'**
  String get p_settings_change_mail;

  /// No description provided for @p_settings_change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get p_settings_change_password;

  /// No description provided for @p_settings_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get p_settings_logout;

  /// No description provided for @p_settings_informations_title.
  ///
  /// In en, this message translates to:
  /// **'Informations'**
  String get p_settings_informations_title;

  /// No description provided for @p_settings_whats_new.
  ///
  /// In en, this message translates to:
  /// **'Whats new?'**
  String get p_settings_whats_new;

  /// No description provided for @p_settings_administration_title.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get p_settings_administration_title;

  /// No description provided for @p_settings_user_management.
  ///
  /// In en, this message translates to:
  /// **'User management'**
  String get p_settings_user_management;

  /// No description provided for @p_settings_recipe_management.
  ///
  /// In en, this message translates to:
  /// **'Recipe management'**
  String get p_settings_recipe_management;

  /// No description provided for @p_tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get p_tag;

  /// No description provided for @p_tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get p_tags;

  /// No description provided for @p_recipe_share.
  ///
  /// In en, this message translates to:
  /// **'Here is the recipe for {recipe}'**
  String p_recipe_share(String recipe);

  /// No description provided for @d_recipe_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete recipe?'**
  String get d_recipe_delete_title;

  /// No description provided for @d_recipe_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Recipe deleted successfully!'**
  String get d_recipe_delete_success;

  /// No description provided for @p_recipe_actions_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get p_recipe_actions_edit;

  /// No description provided for @p_recipe_actions_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get p_recipe_actions_delete;

  /// No description provided for @p_recipe_actions_transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer ownership'**
  String get p_recipe_actions_transfer;

  /// No description provided for @d_settings_manage_diet_title.
  ///
  /// In en, this message translates to:
  /// **'Choose diet'**
  String get d_settings_manage_diet_title;

  /// No description provided for @d_settings_manage_mail_title.
  ///
  /// In en, this message translates to:
  /// **'Change mail'**
  String get d_settings_manage_mail_title;

  /// No description provided for @d_settings_manage_mail_old.
  ///
  /// In en, this message translates to:
  /// **'Current mail'**
  String get d_settings_manage_mail_old;

  /// No description provided for @d_settings_manage_mail_new.
  ///
  /// In en, this message translates to:
  /// **'New mailaddress'**
  String get d_settings_manage_mail_new;

  /// No description provided for @d_settings_manage_mail_new_2.
  ///
  /// In en, this message translates to:
  /// **'Repeat mail address'**
  String get d_settings_manage_mail_new_2;

  /// No description provided for @v_isEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter something'**
  String get v_isEmpty;

  /// No description provided for @v_isMail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mail address'**
  String get v_isMail;

  /// No description provided for @v_isEqual.
  ///
  /// In en, this message translates to:
  /// **'The input does not match'**
  String get v_isEqual;

  /// No description provided for @d_settings_manage_password_title.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get d_settings_manage_password_title;

  /// No description provided for @d_settings_manage_password_old.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get d_settings_manage_password_old;

  /// No description provided for @d_settings_manage_password_new_2.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get d_settings_manage_password_new_2;

  /// No description provided for @d_settings_manage_password_new.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get d_settings_manage_password_new;

  /// No description provided for @v_isSecure.
  ///
  /// In en, this message translates to:
  /// **'Min. one upper and lower case letter, one special character & one number'**
  String get v_isSecure;

  /// No description provided for @d_settings_manage_password_success.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get d_settings_manage_password_success;

  /// No description provided for @d_settings_manage_password_error.
  ///
  /// In en, this message translates to:
  /// **'Password could not be changed'**
  String get d_settings_manage_password_error;

  /// No description provided for @d_settings_manage_mail_success.
  ///
  /// In en, this message translates to:
  /// **'Mail changed successfully'**
  String get d_settings_manage_mail_success;

  /// No description provided for @d_settings_manage_mail_error.
  ///
  /// In en, this message translates to:
  /// **'Mail could not be changed'**
  String get d_settings_manage_mail_error;

  /// No description provided for @d_settings_manage_avatar_title.
  ///
  /// In en, this message translates to:
  /// **'Change avatar'**
  String get d_settings_manage_avatar_title;

  /// No description provided for @d_settings_manage_avatar_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete avatar'**
  String get d_settings_manage_avatar_delete;

  /// No description provided for @d_settings_manage_avatar_change.
  ///
  /// In en, this message translates to:
  /// **'Change avatar'**
  String get d_settings_manage_avatar_change;

  /// No description provided for @cat_group_1.
  ///
  /// In en, this message translates to:
  /// **'Baking & Desserts'**
  String get cat_group_1;

  /// No description provided for @cat_group_2.
  ///
  /// In en, this message translates to:
  /// **'Continents'**
  String get cat_group_2;

  /// No description provided for @cat_group_3.
  ///
  /// In en, this message translates to:
  /// **'Preperation methods'**
  String get cat_group_3;

  /// No description provided for @cat_group_4.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get cat_group_4;

  /// No description provided for @cat_group_5.
  ///
  /// In en, this message translates to:
  /// **'Seasonal'**
  String get cat_group_5;

  /// No description provided for @cat_9.
  ///
  /// In en, this message translates to:
  /// **'Africa'**
  String get cat_9;

  /// No description provided for @cat_12.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get cat_12;

  /// No description provided for @cat_14.
  ///
  /// In en, this message translates to:
  /// **'Caribbean & Exotic'**
  String get cat_14;

  /// No description provided for @cat_15.
  ///
  /// In en, this message translates to:
  /// **'Middle & Near East'**
  String get cat_15;

  /// No description provided for @cat_16.
  ///
  /// In en, this message translates to:
  /// **'Eastern europe'**
  String get cat_16;

  /// No description provided for @cat_20.
  ///
  /// In en, this message translates to:
  /// **'Barbecue & Grill'**
  String get cat_20;

  /// No description provided for @cat_25.
  ///
  /// In en, this message translates to:
  /// **'Egg dish'**
  String get cat_25;

  /// No description provided for @cat_27.
  ///
  /// In en, this message translates to:
  /// **'Flaming'**
  String get cat_27;

  /// No description provided for @p_admin_user_management_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get p_admin_user_management_username;

  /// No description provided for @p_admin_user_management_displayname.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get p_admin_user_management_displayname;

  /// No description provided for @p_admin_user_management_last_activity.
  ///
  /// In en, this message translates to:
  /// **'Last activity'**
  String get p_admin_user_management_last_activity;

  /// No description provided for @p_admin_user_management_is_active.
  ///
  /// In en, this message translates to:
  /// **'Active?'**
  String get p_admin_user_management_is_active;

  /// No description provided for @p_admin_user_management_set_password.
  ///
  /// In en, this message translates to:
  /// **'Set password'**
  String get p_admin_user_management_set_password;

  /// No description provided for @p_admin_user_management_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get p_admin_user_management_delete;

  /// No description provided for @p_admin_user_management_title.
  ///
  /// In en, this message translates to:
  /// **'User management'**
  String get p_admin_user_management_title;

  /// No description provided for @d_admin_user_management_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete user {username}?'**
  String d_admin_user_management_delete_title(String username);

  /// No description provided for @d_admin_user_management_create_title.
  ///
  /// In en, this message translates to:
  /// **'Create user'**
  String get d_admin_user_management_create_title;

  /// No description provided for @d_admin_user_management_create_displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get d_admin_user_management_create_displayName;

  /// No description provided for @d_admin_user_management_create_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get d_admin_user_management_create_username;

  /// No description provided for @d_admin_user_management_create_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get d_admin_user_management_create_password;

  /// No description provided for @d_admin_user_management_create_mail.
  ///
  /// In en, this message translates to:
  /// **'Mail address'**
  String get d_admin_user_management_create_mail;

  /// No description provided for @d_admin_user_management_change_password_title.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get d_admin_user_management_change_password_title;

  /// No description provided for @d_admin_user_management_change_password_new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get d_admin_user_management_change_password_new_password;

  /// No description provided for @d_admin_user_management_change_password_new_password_2.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get d_admin_user_management_change_password_new_password_2;

  /// No description provided for @d_recipe_change_owner_title.
  ///
  /// In en, this message translates to:
  /// **'Change owner'**
  String get d_recipe_change_owner_title;

  /// No description provided for @d_recipe_change_owner_success.
  ///
  /// In en, this message translates to:
  /// **'Owner successfully changed'**
  String get d_recipe_change_owner_success;

  /// No description provided for @p_login_server.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get p_login_server;

  /// No description provided for @cat_28.
  ///
  /// In en, this message translates to:
  /// **'Fondue'**
  String get cat_28;

  /// No description provided for @cat_32.
  ///
  /// In en, this message translates to:
  /// **'Spices / Oil / Vinegar / Pastes'**
  String get cat_32;

  /// No description provided for @cat_33.
  ///
  /// In en, this message translates to:
  /// **'Basic recipes'**
  String get cat_33;

  /// No description provided for @cat_34.
  ///
  /// In en, this message translates to:
  /// **'Preserving'**
  String get cat_34;

  /// No description provided for @cat_35.
  ///
  /// In en, this message translates to:
  /// **'Crustacean / Mussels'**
  String get cat_35;

  /// No description provided for @cat_40.
  ///
  /// In en, this message translates to:
  /// **'Microwave'**
  String get cat_40;

  /// No description provided for @cat_41.
  ///
  /// In en, this message translates to:
  /// **'Molecular cuisine'**
  String get cat_41;

  /// No description provided for @cat_43.
  ///
  /// In en, this message translates to:
  /// **'Roman pot'**
  String get cat_43;

  /// No description provided for @cat_50.
  ///
  /// In en, this message translates to:
  /// **'Punsh bowl'**
  String get cat_50;

  /// No description provided for @cat_51.
  ///
  /// In en, this message translates to:
  /// **'Cocktail'**
  String get cat_51;

  /// No description provided for @cat_52.
  ///
  /// In en, this message translates to:
  /// **'Coffee / Tea / Hot chocolate'**
  String get cat_52;

  /// No description provided for @cat_55.
  ///
  /// In en, this message translates to:
  /// **'Shake'**
  String get cat_55;

  /// No description provided for @cat_59.
  ///
  /// In en, this message translates to:
  /// **'Easter'**
  String get cat_59;

  /// No description provided for @cat_60.
  ///
  /// In en, this message translates to:
  /// **'New years eve'**
  String get cat_60;

  /// No description provided for @cat_3.
  ///
  /// In en, this message translates to:
  /// **'Ice cream'**
  String get cat_3;

  /// No description provided for @cat_57.
  ///
  /// In en, this message translates to:
  /// **'Halloween'**
  String get cat_57;

  /// No description provided for @cat_21.
  ///
  /// In en, this message translates to:
  /// **'Blanching'**
  String get cat_21;

  /// No description provided for @cat_48.
  ///
  /// In en, this message translates to:
  /// **'Wok'**
  String get cat_48;

  /// No description provided for @cat_54.
  ///
  /// In en, this message translates to:
  /// **'Punsh'**
  String get cat_54;

  /// No description provided for @cat_53.
  ///
  /// In en, this message translates to:
  /// **'Liqueur'**
  String get cat_53;

  /// No description provided for @cat_24.
  ///
  /// In en, this message translates to:
  /// **'Steaming'**
  String get cat_24;

  /// No description provided for @cat_1.
  ///
  /// In en, this message translates to:
  /// **'Bread / Rolls'**
  String get cat_1;

  /// No description provided for @cat_18.
  ///
  /// In en, this message translates to:
  /// **'Spread'**
  String get cat_18;

  /// No description provided for @cat_29.
  ///
  /// In en, this message translates to:
  /// **'Frying'**
  String get cat_29;

  /// No description provided for @cat_5.
  ///
  /// In en, this message translates to:
  /// **'Confectionery'**
  String get cat_5;

  /// No description provided for @cat_38.
  ///
  /// In en, this message translates to:
  /// **'Marinate'**
  String get cat_38;

  /// No description provided for @cat_46.
  ///
  /// In en, this message translates to:
  /// **'Snacks / Small dishes'**
  String get cat_46;

  /// No description provided for @cat_8.
  ///
  /// In en, this message translates to:
  /// **'Cakes'**
  String get cat_8;

  /// No description provided for @cat_7.
  ///
  /// In en, this message translates to:
  /// **'Tart / Quiche'**
  String get cat_7;

  /// No description provided for @cat_61.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get cat_61;

  /// No description provided for @cat_45.
  ///
  /// In en, this message translates to:
  /// **'Braise'**
  String get cat_45;

  /// No description provided for @cat_56.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get cat_56;

  /// No description provided for @cat_4.
  ///
  /// In en, this message translates to:
  /// **'Cookies'**
  String get cat_4;

  /// No description provided for @cat_10.
  ///
  /// In en, this message translates to:
  /// **'America'**
  String get cat_10;

  /// No description provided for @cat_36.
  ///
  /// In en, this message translates to:
  /// **'Cheese'**
  String get cat_36;

  /// No description provided for @cat_23.
  ///
  /// In en, this message translates to:
  /// **'Bread dish'**
  String get cat_23;

  /// No description provided for @cat_2.
  ///
  /// In en, this message translates to:
  /// **'Cremes'**
  String get cat_2;

  /// No description provided for @cat_62.
  ///
  /// In en, this message translates to:
  /// **'Christmas'**
  String get cat_62;

  /// No description provided for @cat_26.
  ///
  /// In en, this message translates to:
  /// **'Stew'**
  String get cat_26;

  /// No description provided for @cat_63.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get cat_63;

  /// No description provided for @cat_47.
  ///
  /// In en, this message translates to:
  /// **'Sweets'**
  String get cat_47;

  /// No description provided for @cat_19.
  ///
  /// In en, this message translates to:
  /// **'Baking'**
  String get cat_19;

  /// No description provided for @cat_49.
  ///
  /// In en, this message translates to:
  /// **'Gratinated'**
  String get cat_49;

  /// No description provided for @cat_13.
  ///
  /// In en, this message translates to:
  /// **'Europe'**
  String get cat_13;

  /// No description provided for @cat_42.
  ///
  /// In en, this message translates to:
  /// **'Pasta'**
  String get cat_42;

  /// No description provided for @cat_11.
  ///
  /// In en, this message translates to:
  /// **'Asia'**
  String get cat_11;

  /// No description provided for @cat_37.
  ///
  /// In en, this message translates to:
  /// **'Cooking'**
  String get cat_37;

  /// No description provided for @cat_58.
  ///
  /// In en, this message translates to:
  /// **'Autumn'**
  String get cat_58;

  /// No description provided for @cat_44.
  ///
  /// In en, this message translates to:
  /// **'Sauces'**
  String get cat_44;

  /// No description provided for @cat_39.
  ///
  /// In en, this message translates to:
  /// **'Pastries'**
  String get cat_39;

  /// No description provided for @cat_31.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get cat_31;

  /// No description provided for @cat_17.
  ///
  /// In en, this message translates to:
  /// **'Casserole'**
  String get cat_17;

  /// No description provided for @cat_30.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get cat_30;

  /// No description provided for @cat_6.
  ///
  /// In en, this message translates to:
  /// **'Cake'**
  String get cat_6;

  /// No description provided for @cat_22.
  ///
  /// In en, this message translates to:
  /// **'Roast'**
  String get cat_22;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return L10nDe();
    case 'en': return L10nEn();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
