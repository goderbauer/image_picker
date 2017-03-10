package io.flutter.plugin;

import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import io.flutter.app.FlutterActivity;
import io.flutter.view.FlutterView;
import org.chromium.base.Log;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Location Plugin
 */
public class ImagePickerPlugin implements FlutterView.OnMessageListener {
  private static String TAG = "ImagePickerPlugin";

  public static final int IMAGE_PICKER_REQUEST_CODE = 2342;

  private FlutterActivity activity;
  private ImagePickerPlugin plugin;

  public static void register(FlutterActivity activity) {
    plugin = new ImagePickerPlugin(activity);
  }

  private ImagePickerPlugin(FlutterActivity activity) {
    this.activity = activity;
    activity.getFlutterView().addOnMessageListener("ImagePicker", this);
  }

  @Override
  public static void onActivityResult(Context context, int requestCode, int resultCode, Intent data) {
  }

  @Override
  public String onMessage(FlutterView flutterView, String message) {
    return null;
  }
}
