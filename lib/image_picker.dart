// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library image_picker;

import 'dart:async';

import 'package:flutter/services.dart';

abstract class ImagePicker {
  /// ImageProviders appear on this stream when images are picked.
  Stream<ImageProvider> get onImagePicked;

  /// Initiate the process of picking an image.
  void pickImage();
}

class PlatformImagePicker implements ImagePicker {
  PlatformImagePicker._();

  /// Singleton ImagePicker for the operating system.
  ///
  /// Currently our implementation does not support multiple platform image pickers.
  static PlatformImagePicker instance = new PlatformImagePicker._();

  static const PlatformMethodChannel _channel = const PlatformMethodChannel('image_picker');

  final Stream<ImageProvider> _onImagePicked;
  Stream<ImageProvider> get onImagePicked {
    if (_onImagePicked == null) {
      _onImagePicked = _channel.receiveBroadcastStream().map(_toImageProvider);
    }
    return _onImagePicked;
  }

  ImageProvider _toImageProvider(ByteData data) {
    print("data received: $data");
    // TODO (jackson): Implement
    return new NetworkImage('http://thecatapi.com/api/images/get?format=src&type=gif');
  };

  void pickImage() => _channel.invokeMethod('pickImage');
}

/// For testing, a mock image picker that provides fake NetworkImage providers
class MockImagePicker implements ImagePicker {
  MockImagePicker({ this.url });

  String url;

  final StreamController<ImageProvider> _controller = new StreamController<ImageProvider>();

  Stream<ImageProvider> get onImagePicked => _controller.stream;

  void pickImage() {
    ImageProvider provider = new NetworkImage(url);
    _controller.add(provider);
  }
}