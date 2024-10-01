class Version {
  final int major;
  final int minor;
  final int patch;

  Version({
    required this.major,
    required this.minor,
    required this.patch,
  });

  factory Version.fromString(String input) {
    /// example: input = 1.0.2+13

    final version = input.split('+')[0];
    final parts = version.split('.');

    final major = int.parse(parts[0]);
    final minor = int.parse(parts[1]);
    final patch = int.parse(parts[2]);

    return Version(major: major, minor: minor, patch: patch);
  }

  VersionComparison compare(Version serverVersion) {
    if (major != serverVersion.major) {
      return VersionComparison.majorIncompatible;
    }

    if (minor != serverVersion.minor) {
      return VersionComparison.minorIncompatible;
    }

    return VersionComparison.fullyCompatible;
  }
}

enum VersionComparison {
  /// Incompatible because of major version difference
  majorIncompatible,

  /// Might be incompatible because of minor version difference
  minorIncompatible,

  /// Server and client are 100% compatible
  fullyCompatible,
}
