import 'package:flutter/services.dart';

class AppWakelock {
  static const MethodChannel _channel =
      MethodChannel('com.livestream.touchvoice/wakelock');

  const AppWakelock._();

  static Future<void> enable() async {
    await _channel.invokeMethod<void>('enable');
  }

  static Future<void> disable() async {
    await _channel.invokeMethod<void>('disable');
  }
}
