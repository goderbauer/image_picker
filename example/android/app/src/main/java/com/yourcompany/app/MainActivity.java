package com.yourcompany.app;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.ImagePickerPlugin;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        registerPlugins();
    }

    private void registerPlugins() {
        ImagePickerPlugin.register(this);
    }
}
