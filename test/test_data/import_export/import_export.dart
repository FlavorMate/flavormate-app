import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_metadata.dart';

class ImportExport {
  static List<IEMetadata> getByOrder(
    Locale locale,
    int Function(IEMetadata, IEMetadata) compare,
  ) {
    return [
      ie_flavormate[locale]!,
      ie_ldjson[locale]!,
      ie_nextcloud_cookbook[locale]!,
    ].sorted(compare);
  }

  static Map<Locale, IEMetadata> ie_flavormate = {
    const Locale('en'): const IEMetadata(
      'flavormate',
      'FlavorMate Plugin',
      '1.0.0',
      'FlavorMate',
      [.FileImport, .UrlImport],
      ['application/zip'],
      ['zip'],
      'Import FlavorMate Backups',
      'Import FlavorMate backups from files or URLs.',
      true,
      'Create FlavorMate backups',
      'Export recipes by creating FlavorMate backups',
    ),
    const Locale('de'): const IEMetadata(
      'flavormate',
      'FlavorMate Plugin',
      '1.0.0',
      'FlavorMate',
      [.FileImport, .UrlImport],
      ['application/zip'],
      ['zip'],
      'FlavorMate Sicherungen importieren',
      'FlavorMate Sicherungen aus Dateien oder URLs importieren.',
      true,
      'FlavorMate Sicherungen erstellen',
      'Rezepte als FlavorMate Sicherung exportieren.',
    ),
  };

  static Map<Locale, IEMetadata> ie_ldjson = {
    const Locale('en'): const IEMetadata(
      'ldJson',
      'LD-JSON Plugin',
      '1.0.0',
      'FlavorMate',
      [.FileImport, .UrlImport],
      ['application/ld+json', 'application/json'],
      ['json', 'jsonld'],
      'Import LD-JSON',
      'Import recipe data from LD-JSON files or URLs.',
      true,
      'Export LD-JSON',
      'Export recipes as LD-JSON archive.',
    ),
    const Locale('de'): const IEMetadata(
      'ldJson',
      'LD-JSON Plugin',
      '1.0.0',
      'FlavorMate',
      [.FileImport, .UrlImport],
      ['application/ld+json', 'application/json'],
      ['json', 'jsonld'],
      'LD-JSON importieren',
      'Rezeptdaten aus LD-JSON-Dateien oder URLs importieren.',
      true,
      'LD-JSON exportieren',
      'Rezepte als LD-JSON-Archiv exportieren.',
    ),
  };

  static Map<Locale, IEMetadata> ie_nextcloud_cookbook = {
    const Locale('en'): const IEMetadata(
      'nextcloud_cookbook',
      'Nextcloud Cookbook',
      '1.0.0',
      'FlavorMate',
      [.FileImport, .UrlImport],
      ['application/zip'],
      ['zip'],
      'Import Nextcloud Cookbook',
      'Import recipes from Nextcloud Cookbook zip files or URLs.',
      true,
      'Export Nextcloud Cookbook',
      'Export recipes as Nextcloud Cookbook zip archive.',
    ),
    const Locale('de'): const IEMetadata(
      'nextcloud_cookbook',
      'Nextcloud Kochbuch',
      '1.0.0',
      'FlavorMate',
      [.FileImport, .UrlImport],
      ['application/zip'],
      ['zip'],
      'Nextcloud Kochbuch importieren',
      'Rezepte aus Nextcloud Kochbuch-ZIP-Dateien oder URLs importieren.',
      true,
      'Nextcloud Kochbuch exportieren',
      'Rezepte als Nextcloud Kochbuch-ZIP-Archiv exportieren.',
    ),
  };
}
