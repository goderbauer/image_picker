package com.yourcompany.imagepicker.example;

import android.content.Intent;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;

public class MainActivity extends FlutterActivity {

    private ImagePickerPlugin imagePicker;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        imagePicker = ImagePickerPlugin.register(this);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        imagePicker.onActivityResult(requestCode, resultCode, data);
    }
}
