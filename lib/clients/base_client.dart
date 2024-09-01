abstract class BaseClient {
  String getParams(Map<String, dynamic> params) {
    return params.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent("${entry.value}")}')
        .join('&');
  }
}
