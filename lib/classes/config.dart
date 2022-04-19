class Config {
  static const String baseUrl = 'https://runwithme.msuki.tk';
  int apiTimeout = 20;

  /// The base url for server requests.
  String getBaseUrl() {
    return baseUrl;
  }

  /// The timeout for API requests
  int getApiTimeout() {
    return apiTimeout;
  }
}
