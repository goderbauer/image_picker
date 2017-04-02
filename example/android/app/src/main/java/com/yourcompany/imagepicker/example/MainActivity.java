package com.yourcompany.imagepicker.example;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ImagePickerPlugin.register(this);
    }
}
