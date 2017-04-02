import 'dart:async';

import 'package:flutter/services.dart';

class ImagePicker {
  static const PlatformMethodChannel _channel =
      const PlatformMethodChannel('image_picker');

  // Returns the URL of the picked image
  static Future<String> pickImage() =>
      _channel.invokeMethod('pickImage');
}
