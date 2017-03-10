package com.yourcompany.app;

import android.content.Intent;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.ImagePickerPlugin;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        registerPlugins();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        ImagePickerPlugin.onActivityResult(this, requestCode, resultCode, data);
    }

    private void registerPlugins() {
        ImagePickerPlugin.register(this);
    }
}
