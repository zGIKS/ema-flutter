class ApiBaseUrlValueObject {
  final Uri value;

  ApiBaseUrlValueObject._(this.value);

  factory ApiBaseUrlValueObject(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Base URL is required');
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw ArgumentError('Invalid base URL');
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw ArgumentError('Base URL must start with http:// or https://');
    }

    return ApiBaseUrlValueObject._(uri);
  }
}

