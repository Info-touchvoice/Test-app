import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Formats and logs native Google Sign-In failures without dropping details.
class GoogleSignInDiagnostics {
  static final RegExp _apiExceptionPattern =
      RegExp(r'ApiException:\s*([0-9]+)(?::\s*([^\n]*))?');

  static void logSignInException(
    Object error,
    StackTrace stackTrace, {
    String operation = 'GoogleSignIn.signIn',
  }) {
    final details = describe(error);

    debugPrint('$operation failed\n$details\nStack trace:\n$stackTrace');
    developer.log(
      '$operation failed\n$details',
      name: 'GoogleSignIn',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static String snackbarMessage(Object error) {
    if (error is PlatformException) {
      return _dedupe(<String>[
        'PlatformException code: ${error.code}',
        if (_hasText(error.message))
          'PlatformException message: ${error.message}',
        ..._apiExceptionLines(error.message, error.details),
        if (error.details != null)
          'PlatformException details: ${error.details}',
      ]).join('\n');
    }

    return error.toString();
  }

  static String describe(Object error) {
    if (error is PlatformException) {
      return _dedupe(<String>[
        'Exception type: ${error.runtimeType}',
        'PlatformException code: ${error.code}',
        if (_hasText(error.message))
          'PlatformException message: ${error.message}',
        ..._apiExceptionLines(error.message, error.details),
        if (error.details != null)
          'PlatformException details: ${error.details}',
        'Exception toString: $error',
      ]).join('\n');
    }

    return 'Exception type: ${error.runtimeType}\nException toString: $error';
  }

  static List<String> _apiExceptionLines(String? message, Object? details) {
    final raw = <String>[
      if (_hasText(message)) message!,
      if (details != null) details.toString(),
    ].join('\n');
    final match = _apiExceptionPattern.firstMatch(raw);

    if (match == null) {
      return const <String>[];
    }

    final apiMessage = match.group(2)?.trim();
    return <String>[
      'ApiException status code: ${match.group(1)}',
      if (_hasText(apiMessage))
        'ApiException message: $apiMessage'
      else if (_hasText(message))
        'ApiException message: $message',
    ];
  }

  static List<String> _dedupe(List<String> values) {
    final seen = <String>{};
    return values.where((value) => seen.add(value)).toList();
  }

  static bool _hasText(String? value) => value != null && value.trim().isNotEmpty;
}
