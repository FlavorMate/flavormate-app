abstract class MapUtils {
  static String toPrettyString(Map map, {int level = 0}) {
    final List<String> fields = [];
    for (final entry in map.entries) {
      final value = entry.value;
      if (value is Map) {
        fields.add('\t' * level + '${entry.key} {');
        fields.add(toPrettyString(entry.value, level: level + 1));
        fields.add('\t' * level + '}');
      } else if (value is bool && value == true) {
        fields.add('\t' * level + entry.key.toString());
      }
    }

    return fields.join('\n');
  }

  static String toJsonString(Map map, {int level = 0}) {
    final List<String> fields = [];
    for (final entry in map.entries) {
      if (entry.value is Map) {
        fields.add('\t' * level + '${entry.key}: {');
        fields.add(toJsonString(entry.value, level: level + 1));
        fields.add('\t' * level + '}');
      } else if (entry.value != null) {
        fields.add('\t' * level + '${entry.key}: ${entry.value}');
      }
    }

    return fields.join('\n');
  }
}
