package com.yourcompany.app;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.LocationPlugin;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        registerPlugins();
    }

    private void registerPlugins() {
        // TODO(jackson): Rename to ImagePickerPlugin
        LocationPlugin.register(this);
    }
}
