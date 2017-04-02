import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Image Picker Demo',
      home: new MyHomePage(title: 'Image Picker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _imageUrl;

  void _pickImage() {
    ImagePicker.pickImage().then((String url) {
      setState(() {
        _imageUrl = url;
      });
    })
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Image Picker Example'),
      ),
      body: new Center(
        child: _imageUrl == null ?
               new Text('You have not yet picked an image.') :
               new NetworkImage(_imageUrl),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}
