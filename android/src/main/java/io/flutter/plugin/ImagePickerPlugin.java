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
  private static String TAG = "LocationPlugin";

  private FlutterActivity activity;

  public static void register(FlutterActivity activity) {
    new ImagePickerPlugin(activity);
  }

  private ImagePickerPlugin(FlutterActivity activity) {
    this.activity = activity;
    activity.getFlutterView().addOnMessageListener("ImagePicker", this);
  }

  @Override
  public String onMessage(FlutterView flutterView, String message) {
    try {
      final JSONObject jsonMessage = new JSONObject(message);
      final String locationProvider = jsonMessage.getString("provider");
      final String permission = "android.permission.ACCESS_FINE_LOCATION";
      Location location = null;
      if (activity.checkCallingOrSelfPermission(permission) == PackageManager.PERMISSION_GRANTED) {
        LocationManager locationManager = (LocationManager) activity.getSystemService(Context.LOCATION_SERVICE);
        //noinspection ResourceType
        location = locationManager.getLastKnownLocation(locationProvider);
      }
      JSONObject reply = new JSONObject();
      if (location != null) {
        reply.put("latitude", location.getLatitude());
        reply.put("longitude", location.getLongitude());
      } else {
        reply.put("latitude", 10.0);
        reply.put("longitude", 10.0);
      }
      return reply.toString();
    } catch (JSONException e) {
      Log.e(TAG, "JSON exception", e);
    }
    return null;
  }
}
