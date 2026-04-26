import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_ingredient_group_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_instruction_group_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_serving_dto.dart';

import '../accounts/accounts.dart';
import '../categories/categories.dart';
import '../recipe_files/recipe_files.dart';
import '../tags/tags.dart';
import '../units/units.dart';

class RecipePreviews {
  static List<RecipePreviewDto> getByOrder(
    Locale locale,
    int Function(RecipePreviewDto, RecipePreviewDto) compare,
  ) {
    return [
      r_7ad8a257_8b11_4d3d_b4a8_33026db50948[locale]!,
      r_1840f38b_c554_4ee8_874c_074f69fe9455[locale]!,
      r_4d822d08_e4cc_4857_9626_2bc423b0e50a[locale]!,
      r_73bac776_4e0a_4ac2_b39b_a46d5d8b3d29[locale]!,
      r_279a08c5_32c9_42f2_9550_cc6b4da4d9c9[locale]!,
      r_2c6e6500_ccf9_4fad_9874_98d2cca1f6a8[locale]!,
      r_9a56652b_321c_405f_a5ef_84f1e82916ab[locale]!,
      r_cee6eb3d_3079_4937_a0b8_75d7b6e95c65[locale]!,
    ].sorted(compare);
  }

  static final Map<Locale, RecipePreviewDto>
  r_7ad8a257_8b11_4d3d_b4a8_33026db50948 = {
    const Locale('en'): RecipePreviewDto(
      id: '7ad8a257-8b11-4d3d-b4a8-33026db50948',
      createdOn: DateTime(2025, 12, 04, 20, 37, 42),
      label: 'Overnight Oats',
      diet: .Vegan,
      prepTime: const Duration(),
      cookTime: const Duration(minutes: 5),
      restTime: const Duration(hours: 8),
      cover: RecipeFiles.rf_25480138_78d2_421a_b8a0_2b1c8f7fc679,
    ),
    const Locale('de'): RecipePreviewDto(
      id: '7ad8a257-8b11-4d3d-b4a8-33026db50948',
      createdOn: DateTime(2025, 12, 04, 20, 37, 42),
      label: 'Overnight Oats',
      diet: .Vegan,
      prepTime: const Duration(),
      cookTime: const Duration(minutes: 5),
      restTime: const Duration(hours: 8),
      cover: RecipeFiles.rf_25480138_78d2_421a_b8a0_2b1c8f7fc679,
    ),
  };

  static final Map<Locale, RecipePreviewDto>
  r_1840f38b_c554_4ee8_874c_074f69fe9455 = {
    const Locale('en'): RecipePreviewDto(
      id: '1840f38b-c554-4ee8-874c-074f69fe9455',
      createdOn: DateTime(2025, 12, 04, 20, 55, 33),
      label: 'Spaghetti Carbonara',
      diet: .Meat,
      prepTime: const Duration(minutes: 10),
      cookTime: const Duration(minutes: 15),
      restTime: const Duration(),
      cover: RecipeFiles.rf_3b7910a9_e6a2_4ae3_a73f_6cc543a55ff4,
    ),
    const Locale('de'): RecipePreviewDto(
      id: '1840f38b-c554-4ee8-874c-074f69fe9455',
      createdOn: DateTime(2025, 12, 04, 20, 55, 33),
      label: 'Spaghetti Carbonara',
      diet: .Meat,
      prepTime: const Duration(minutes: 10),
      cookTime: const Duration(minutes: 15),
      restTime: const Duration(),
      cover: RecipeFiles.rf_3b7910a9_e6a2_4ae3_a73f_6cc543a55ff4,
    ),
  };

  static final Map<Locale, RecipePreviewDto>
  r_4d822d08_e4cc_4857_9626_2bc423b0e50a = {
    const Locale('en'): RecipePreviewDto(
      id: '4d822d08-e4cc-4857-9626-2bc423b0e50a',
      createdOn: DateTime(2025, 12, 04, 20, 36, 01),
      label: 'Chocolate Cake',
      diet: .Vegetarian,
      prepTime: const Duration(minutes: 20),
      cookTime: const Duration(minutes: 35),
      restTime: const Duration(),
      cover: RecipeFiles.rf_47a23184_f2d0_4c08_8c4a_1535bd82a6a7,
    ),
    const Locale('de'): RecipePreviewDto(
      id: '4d822d08-e4cc-4857-9626-2bc423b0e50a',
      createdOn: DateTime(2025, 12, 04, 20, 36, 01),
      label: 'Schokoladenkuchen',
      diet: .Vegetarian,
      prepTime: const Duration(minutes: 20),
      cookTime: const Duration(minutes: 35),
      restTime: const Duration(),
      cover: RecipeFiles.rf_47a23184_f2d0_4c08_8c4a_1535bd82a6a7,
    ),
  };

  static final Map<Locale, RecipePreviewDto>
  r_73bac776_4e0a_4ac2_b39b_a46d5d8b3d29 = {
    const Locale('en'): RecipePreviewDto(
      id: '73bac776-4e0a-4ac2-b39b-a46d5d8b3d29',
      createdOn: DateTime(2025, 12, 04, 20, 34, 18),
      label: 'Greek Salad',
      diet: .Vegetarian,
      prepTime: const Duration(minutes: 15),
      cookTime: const Duration(),
      restTime: const Duration(),
      cover: RecipeFiles.rf_1b84752d_7477_4f7a_adc9_de9dfd9af0e5,
    ),
    const Locale('de'): RecipePreviewDto(
      id: '73bac776-4e0a-4ac2-b39b-a46d5d8b3d29',
      createdOn: DateTime(2025, 12, 04, 20, 34, 18),
      label: 'Griechischer Salat',
      diet: .Vegetarian,
      prepTime: const Duration(minutes: 15),
      cookTime: const Duration(),
      restTime: const Duration(),
      cover: RecipeFiles.rf_1b84752d_7477_4f7a_adc9_de9dfd9af0e5,
    ),
  };

  static final Map<Locale, RecipePreviewDto>
  r_279a08c5_32c9_42f2_9550_cc6b4da4d9c9 = {
    const Locale('en'): RecipePreviewDto(
      id: '279a08c5-32c9-42f2-9550-cc6b4da4d9c9',
      createdOn: DateTime(2023, 12, 28, 20, 36, 18),
      label: 'Pizza dough',
      diet: .Vegan,
      prepTime: const Duration(minutes: 15),
      cookTime: const Duration(minutes: 20),
      restTime: const Duration(days: 2),
      cover: RecipeFiles.rf_6d484009_ec6f_46cc_926d_322443198ce2,
    ),
    const Locale('de'): RecipePreviewDto(
      id: '279a08c5-32c9-42f2-9550-cc6b4da4d9c9',
      createdOn: DateTime(2023, 12, 28, 20, 36, 18),
      label: 'Pizzateig',
      diet: .Vegan,
      prepTime: const Duration(minutes: 15),
      cookTime: const Duration(minutes: 20),
      restTime: const Duration(days: 2),
      cover: RecipeFiles.rf_6d484009_ec6f_46cc_926d_322443198ce2,
    ),
  };

  static final Map<Locale, RecipePreviewDto>
  r_2c6e6500_ccf9_4fad_9874_98d2cca1f6a8 = {
    const Locale('en'): RecipePreviewDto(
      id: '2c6e6500-ccf9-4fad-9874-98d2cca1f6a8',
      createdOn: DateTime(2023, 12, 28, 20, 36, 18),
      label: 'Nut Bars',
      diet: .Vegetarian,
      prepTime: const Duration(minutes: 20),
      cookTime: const Duration(minutes: 30),
      restTime: const Duration(),
      cover: RecipeFiles.rf_6e39c472_c41f_4dd2_b8f3_dcdbfe3c04a8,
    ),
    const Locale('de'): RecipePreviewDto(
      id: '2c6e6500-ccf9-4fad-9874-98d2cca1f6a8',
      createdOn: DateTime(2023, 12, 28, 20, 36, 18),
      label: 'Nussecken',
      diet: .Vegetarian,
      prepTime: const Duration(minutes: 20),
      cookTime: const Duration(minutes: 30),
      restTime: const Duration(),
      cover: RecipeFiles.rf_6e39c472_c41f_4dd2_b8f3_dcdbfe3c04a8,
    ),
  };

  static final Map<Locale, RecipePreviewDto>
  r_9a56652b_321c_405f_a5ef_84f1e82916ab = {
    const Locale('en'): RecipePreviewDto(
      id: '9a56652b-321c-405f-a5ef-84f1e82916ab',
      createdOn: DateTime(2023, 12, 28, 20, 36, 18),
      label: 'Lemon Cake',
      diet: .Vegetarian,
      prepTime: const Duration(minutes: 30),
      cookTime: const Duration(hours: 1),
      restTime: const Duration(),
      cover: RecipeFiles.rf_0b1564ca_b2ba_4378_ac48_02266ca78aab,
    ),
    const Locale('de'): RecipePreviewDto(
      id: '9a56652b-321c-405f-a5ef-84f1e82916ab',
      createdOn: DateTime(2023, 12, 28, 20, 36, 18),
      label: 'Zitronenkuchen',
      diet: .Vegetarian,
      prepTime: const Duration(minutes: 30),
      cookTime: const Duration(hours: 1),
      restTime: const Duration(),
      cover: RecipeFiles.rf_0b1564ca_b2ba_4378_ac48_02266ca78aab,
    ),
  };

  static final Map<Locale, RecipePreviewDto>
  r_cee6eb3d_3079_4937_a0b8_75d7b6e95c65 = {
    const Locale('en'): RecipePreviewDto(
      id: 'cee6eb3d-3079-4937-a0b8-75d7b6e95c65',
      createdOn: DateTime(2023, 12, 28, 20, 36, 18),
      label: 'Grandma\'s Butter Cookies',
      diet: .Vegetarian,
      prepTime: const Duration(minutes: 20),
      cookTime: const Duration(minutes: 7),
      restTime: const Duration(),
      cover: RecipeFiles.rf_85ec8169_241e_4096_83aa_ec3cdd8a0a1a,
    ),
    const Locale('de'): RecipePreviewDto(
      id: 'cee6eb3d-3079-4937-a0b8-75d7b6e95c65',
      createdOn: DateTime(2023, 12, 28, 20, 36, 18),
      label: 'Omas Butterkekse',
      diet: .Vegetarian,
      prepTime: const Duration(minutes: 20),
      cookTime: const Duration(minutes: 7),
      restTime: const Duration(),
      cover: RecipeFiles.rf_85ec8169_241e_4096_83aa_ec3cdd8a0a1a,
    ),
  };
}

class RecipeFulls {
  static Map<Locale, RecipeFullDto Function()>
  r_9fa077d3_af00_4ec1_ab7e_c27f8cd92920 = {
    const Locale('en'): () {
      const locale = Locale('en');
      return RecipeFullDto(
        id: '9fa077d3-af00-4ec1-ab7e-c27f8cd92920',
        createdOn: DateTime(2023, 12, 28, 02, 57, 03),
        label: 'Apple Cake',
        diet: .Vegetarian,
        prepTime: const Duration(minutes: 10),
        cookTime: const Duration(minutes: 55),
        restTime: Duration.zero,
        cover: RecipeFiles.rf_7b6be04e_8ee6_436e_b1e6_69027746002b,
        version: 1,
        ownedBy: AccountPreviews.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc,
        description: null,
        serving: const RecipeServingDto(
          id: '520179fa-4e17-417f-891c-a4688e63b3f0',
          amount: 1,
          label: 'Springform pan',
        ),
        instructionGroups: const [
          RecipeInstructionGroupDto(
            id: '904d31d8-09e9-4b03-a25c-ca835023ea3d',
            index: 0,
            instructions: [
              RecipeInstructionGroupItemDto(
                id: '1fef23f9-bea2-491f-b86e-03387136f925',
                label:
                    'Mix [[150]]g butter, [[125]]g sugar, [[250]]g flour, [[1]] egg, and baking powder',
                index: 0,
              ),
              RecipeInstructionGroupItemDto(
                id: '15136430-cbc0-417f-894a-82e3246f178d',
                label:
                    'Cut the apples into quarters and drizzle lemon juice over them',
                index: 1,
              ),
              RecipeInstructionGroupItemDto(
                id: '549c5e0c-11c9-483c-8b35-cb09e4334b01',
                label:
                    'Mix the remaining flour, sugar, egg, and butter together with the whipped cream',
                index: 2,
              ),
              RecipeInstructionGroupItemDto(
                id: 'c891fc1b-3f0e-4fb4-b3d1-d078d6da457b',
                label:
                    'First the crust, then the apples, and finally the liquid topping in a round pan',
                index: 3,
              ),
              RecipeInstructionGroupItemDto(
                id: 'ba350ddf-79b2-4976-961b-50b383f5cfac',
                label: 'Bake for 55–65 minutes at 180°C',
                index: 4,
              ),
            ],
            label: null,
          ),
        ],
        ingredientGroups: [
          RecipeIngredientGroupDto(
            id: 'f929d523-9e74-48fe-a8db-f9a0bdca03b8',
            index: 0,
            ingredients: [
              RecipeIngredientGroupItemDto(
                id: 'a3897856-372e-48fd-86e0-462c5ef7a473',
                label: 'Cream / Milk',
                index: 6,
                amount: 250.0,
                unit: Units.u_milliliter[locale]!,
                nutrition: null,
              ),
              RecipeIngredientGroupItemDto(
                id: 'ba55d491-88e5-4bec-9489-5ab5289105b0',
                label: 'Baking powder',
                index: 4,
                amount: 1.0,
                unit: Units.u_teaspoon[locale]!,
                nutrition: null,
              ),
              RecipeIngredientGroupItemDto(
                id: 'bd989f83-c12d-4f8f-88eb-c117dc2279ef',
                label: 'Butter',
                index: 0,
                amount: 300.0,
                unit: Units.u_gram[locale]!,
                nutrition: null,
              ),
              const RecipeIngredientGroupItemDto(
                id: 'd0213825-cbf4-48bb-aba6-56bc29e59ec5',
                label: 'sour apples',
                index: 7,
                amount: 7.0,
                unit: null,
                nutrition: null,
              ),
              const RecipeIngredientGroupItemDto(
                id: 'a7507849-4ba8-42e6-8029-de1c64c12d1b',
                label: 'Lemon (juice)',
                index: 5,
                amount: 1.0,
                unit: null,
                nutrition: null,
              ),
              RecipeIngredientGroupItemDto(
                id: '8c19f8dc-b159-4818-908b-39f679c4d282',
                label: 'Sugar',
                index: 1,
                amount: 225.0,
                unit: Units.u_gram[locale]!,
                nutrition: null,
              ),
              const RecipeIngredientGroupItemDto(
                id: '82868669-a786-4360-9614-40fb3829d78b',
                label: 'Eggs',
                index: 3,
                amount: 2.0,
                unit: null,
                nutrition: null,
              ),
              RecipeIngredientGroupItemDto(
                id: 'c243e260-2e28-43f5-a75a-df0fe8e1f1c5',
                label: 'Flour',
                index: 2,
                amount: 350.0,
                unit: Units.u_gram[locale]!,
                nutrition: null,
              ),
            ],
            label: null,
          ),
        ],
        course: .Bakery,
        url: null,
        categories: [
          Categories.c_autumn[locale]!,
        ],
        tags: [
          Tags.t_cake[locale]!,
          Tags.t_heavy_cream[locale]!,
          Tags.t_apple[locale]!,
        ],
        files: const [RecipeFiles.rf_7b6be04e_8ee6_436e_b1e6_69027746002b],
      );
    },
    const Locale('de'): () {
      const locale = Locale('de');
      return RecipeFullDto(
        id: '9fa077d3-af00-4ec1-ab7e-c27f8cd92920',
        createdOn: DateTime(2023, 12, 28, 02, 57, 03),
        label: 'Apfel Kuchen',
        diet: .Vegetarian,
        prepTime: const Duration(minutes: 10),
        cookTime: const Duration(minutes: 55),
        restTime: Duration.zero,
        cover: RecipeFiles.rf_7b6be04e_8ee6_436e_b1e6_69027746002b,
        version: 1,
        ownedBy: AccountPreviews.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc,
        description: null,
        serving: const RecipeServingDto(
          id: '520179fa-4e17-417f-891c-a4688e63b3f0',
          amount: 1,
          label: 'Springform',
        ),
        instructionGroups: const [
          RecipeInstructionGroupDto(
            id: '904d31d8-09e9-4b03-a25c-ca835023ea3d',
            index: 0,
            instructions: [
              RecipeInstructionGroupItemDto(
                id: '1fef23f9-bea2-491f-b86e-03387136f925',
                label:
                    '[[150]]g Butter, [[125]]g Zucker, [[250]]g Mehl, [[1]] Ei und Backpulver vermischen',
                index: 0,
              ),
              RecipeInstructionGroupItemDto(
                id: '15136430-cbc0-417f-894a-82e3246f178d',
                label: 'Äpfel vierteln und Zitronensaft drüber geben',
                index: 1,
              ),
              RecipeInstructionGroupItemDto(
                id: '549c5e0c-11c9-483c-8b35-cb09e4334b01',
                label:
                    'Restliches Mehr, Zucker, Ei und Butter zusammen mit der geschlagenen Sahne verrühren',
                index: 2,
              ),
              RecipeInstructionGroupItemDto(
                id: 'c891fc1b-3f0e-4fb4-b3d1-d078d6da457b',
                label:
                    'Erst Boden, dann Äpfel und anschließend den flüssigen Deckel in eine runde Form geben',
                index: 3,
              ),
              RecipeInstructionGroupItemDto(
                id: 'ba350ddf-79b2-4976-961b-50b383f5cfac',
                label: '55-65 Minuten bei 180°C backen',
                index: 4,
              ),
            ],
            label: null,
          ),
        ],
        ingredientGroups: [
          RecipeIngredientGroupDto(
            id: 'f929d523-9e74-48fe-a8db-f9a0bdca03b8',
            index: 0,
            ingredients: [
              RecipeIngredientGroupItemDto(
                id: 'a3897856-372e-48fd-86e0-462c5ef7a473',
                label: 'Sahne / Milch',
                index: 6,
                amount: 250.0,
                unit: Units.u_milliliter[locale]!,
                nutrition: null,
              ),
              RecipeIngredientGroupItemDto(
                id: 'ba55d491-88e5-4bec-9489-5ab5289105b0',
                label: 'Backpulver',
                index: 4,
                amount: 1.0,
                unit: Units.u_teaspoon[locale]!,
                nutrition: null,
              ),
              RecipeIngredientGroupItemDto(
                id: 'bd989f83-c12d-4f8f-88eb-c117dc2279ef',
                label: 'Butter',
                index: 0,
                amount: 300.0,
                unit: Units.u_gram[locale]!,
                nutrition: null,
              ),
              const RecipeIngredientGroupItemDto(
                id: 'd0213825-cbf4-48bb-aba6-56bc29e59ec5',
                label: 'saure Äpfel',
                index: 7,
                amount: 7.0,
                unit: null,
                nutrition: null,
              ),
              const RecipeIngredientGroupItemDto(
                id: 'a7507849-4ba8-42e6-8029-de1c64c12d1b',
                label: 'Zitrone (Saft)',
                index: 5,
                amount: 1.0,
                unit: null,
                nutrition: null,
              ),
              RecipeIngredientGroupItemDto(
                id: '8c19f8dc-b159-4818-908b-39f679c4d282',
                label: 'Zucker',
                index: 1,
                amount: 225.0,
                unit: Units.u_gram[locale]!,
                nutrition: null,
              ),
              const RecipeIngredientGroupItemDto(
                id: '82868669-a786-4360-9614-40fb3829d78b',
                label: 'Eier',
                index: 3,
                amount: 2.0,
                unit: null,
                nutrition: null,
              ),
              RecipeIngredientGroupItemDto(
                id: 'c243e260-2e28-43f5-a75a-df0fe8e1f1c5',
                label: 'Mehl',
                index: 2,
                amount: 350.0,
                unit: Units.u_gram[locale]!,
                nutrition: null,
              ),
            ],
            label: null,
          ),
        ],
        course: .Bakery,
        url: null,
        categories: [
          Categories.c_autumn[locale]!,
        ],
        tags: [
          Tags.t_cake[locale]!,
          Tags.t_heavy_cream[locale]!,
          Tags.t_apple[locale]!,
        ],
        files: const [RecipeFiles.rf_7b6be04e_8ee6_436e_b1e6_69027746002b],
      );
    },
  };
}
