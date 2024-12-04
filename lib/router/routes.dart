import 'package:flavormate/components/go_router/wrapper.dart';
import 'package:flavormate/layouts/main_layout.dart';
import 'package:flavormate/models/appLink/app_link.dart';
import 'package:flavormate/pages/authors/_id.dart';
import 'package:flavormate/pages/categories/_id.dart';
import 'package:flavormate/pages/categories/index.dart';
import 'package:flavormate/pages/editor/_id.dart';
import 'package:flavormate/pages/home/index.dart';
import 'package:flavormate/pages/library/_id.dart';
import 'package:flavormate/pages/library/index.dart';
import 'package:flavormate/pages/login/login_page.dart';
import 'package:flavormate/pages/more/index.dart';
import 'package:flavormate/pages/no_connection/index.dart';
import 'package:flavormate/pages/public_recipe/index.dart';
import 'package:flavormate/pages/recipe/index.dart';
import 'package:flavormate/pages/recipe_drafts/index.dart';
import 'package:flavormate/pages/recipes/_id.dart';
import 'package:flavormate/pages/recovery/index.dart';
import 'package:flavormate/pages/registration/index.dart';
import 'package:flavormate/pages/server_outdated/index.dart';
import 'package:flavormate/pages/settings/index.dart';
import 'package:flavormate/pages/share_management/index.dart';
import 'package:flavormate/pages/splash/index.dart';
import 'package:flavormate/pages/story/_id.dart';
import 'package:flavormate/pages/story_drafts/index.dart';
import 'package:flavormate/pages/story_editor/_id.dart';
import 'package:flavormate/pages/tags/_id.dart';
import 'package:flavormate/pages/tags/index.dart';
import 'package:flavormate/pages/user_management/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

var routes = [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return Wrapper(child: MainLayout(navigationShell: navigationShell));
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => const MaterialPage(
              child: HomePage(),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/library',
            pageBuilder: (context, state) => const MaterialPage(
              child: LibraryPage(),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/more',
            pageBuilder: (context, state) => const MaterialPage(
              child: MorePage(),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const MaterialPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    path: '/login',
    name: 'login',
    pageBuilder: (context, state) => const MaterialPage(
      child: LoginPage(),
    ),
  ),
  GoRoute(
    name: 'recipe',
    path: '/recipe/:id',
    pageBuilder: (context, state) => MaterialPage(
      child: RecipePage(
        id: state.pathParameters['id']!,
        title: state.extra as String?,
      ),
    ),
  ),
  GoRoute(
    path: '/library/:id',
    name: 'book',
    pageBuilder: (context, state) => MaterialPage(
      child: BookPage(
        id: int.parse(state.pathParameters['id']!),
        title: state.extra as String?,
      ),
    ),
  ),
  GoRoute(
    path: '/recipes',
    name: 'recipes',
    pageBuilder: (context, state) => const MaterialPage(
      child: RecipesPage(),
    ),
  ),
  GoRoute(
    path: '/categories',
    name: 'categories',
    pageBuilder: (context, state) => const MaterialPage(
      child: CategoriesPage(),
    ),
  ),
  GoRoute(
    path: '/categories/:id',
    name: 'category',
    pageBuilder: (context, state) => MaterialPage(
      child: CategoryPage(
        id: int.parse(state.pathParameters['id']!),
        title: state.extra as String?,
      ),
    ),
  ),
  GoRoute(
    path: '/tags',
    name: 'tags',
    pageBuilder: (context, state) => const MaterialPage(
      child: TagsPage(),
    ),
  ),
  GoRoute(
    path: '/tags/:id',
    name: 'tag',
    pageBuilder: (context, state) => MaterialPage(
      child: TagPage(
        id: int.parse(state.pathParameters['id']!),
        title: state.extra as String?,
      ),
    ),
  ),
  GoRoute(
    path: '/authors/:id',
    name: 'author',
    pageBuilder: (context, state) => MaterialPage(
      child: AuthorPage(
        id: int.parse(state.pathParameters['id']!),
        title: state.extra as String?,
      ),
    ),
  ),
  GoRoute(
    path: '/admin/user',
    name: 'user_management',
    pageBuilder: (context, state) => const MaterialPage(
      child: UserManagementPage(),
    ),
  ),
  GoRoute(
    path: '/no-connection',
    name: 'no-connection',
    pageBuilder: (context, state) => const MaterialPage(
      child: NoConnectionPage(),
    ),
  ),
  GoRoute(
    path: '/recipe-editor/:id',
    name: 'recipe-editor',
    pageBuilder: (context, state) => MaterialPage(
      child: EditorPage(id: state.pathParameters['id'] as String),
    ),
  ),
  GoRoute(
    path: '/story/:id',
    name: 'story',
    pageBuilder: (context, state) => MaterialPage(
      child: StoryPage(
        id: state.pathParameters['id'] as String,
        title: state.extra as String?,
      ),
    ),
  ),
  GoRoute(
    path: '/recipe-drafts',
    name: 'recipe-drafts',
    pageBuilder: (context, state) => const MaterialPage(
      child: RecipeDraftsPage(),
    ),
  ),
  GoRoute(
    path: '/recovery',
    name: 'recovery',
    pageBuilder: (context, state) => const MaterialPage(
      child: RecoveryPage(),
    ),
  ),
  GoRoute(
    path: '/registration',
    name: 'registration',
    pageBuilder: (context, state) => const MaterialPage(
      child: RegistrationPage(),
    ),
  ),
  GoRoute(
    path: '/story-drafts',
    name: 'story-drafts',
    pageBuilder: (context, state) => const MaterialPage(
      child: StoryDraftsPage(),
    ),
  ),
  GoRoute(
    path: '/story-editor/:id',
    name: 'story-editor',
    pageBuilder: (context, state) => MaterialPage(
      child: StoryEditorPage(id: state.pathParameters['id'] as String),
    ),
  ),
  GoRoute(
    path: '/splash',
    name: 'splash',
    pageBuilder: (context, state) => const MaterialPage(child: SplashPage()),
  ),
  GoRoute(
    path: '/server-outdated',
    name: 'server-outdated',
    pageBuilder: (context, state) =>
        const MaterialPage(child: ServerOutdatedPage()),
  ),
  GoRoute(
    path: '/public/recipe/:id',
    name: 'public-recipe',
    pageBuilder: (context, state) =>
        MaterialPage(child: PublicRecipePage(appLink: state.extra as AppLink)),
  ),
  GoRoute(
    path: '/admin/share',
    name: 'share_management',
    pageBuilder: (context, state) =>
        const MaterialPage(child: ShareManagementPage()),
  ),
];
