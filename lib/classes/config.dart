///{@category Classes}
/// A class containing basic configuration settings that can be changed
/// during development but that are immutable when the app is compiled.
import "package:flutter/material.dart";

///The configuration object.
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
