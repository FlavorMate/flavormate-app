import 'package:file_selector/file_selector.dart';

class IEImportWrapper {
  final String pluginId;
  final List<String> urls;
  final List<XFile> files;

  const IEImportWrapper({
    required this.pluginId,
    required this.urls,
    required this.files,
  });
}
