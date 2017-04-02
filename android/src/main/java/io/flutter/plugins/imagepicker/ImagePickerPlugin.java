package io.flutter.plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import io.flutter.app.FlutterActivity;
import io.flutter.view.FlutterView;
import io.flutter.plugin.common.FlutterMethodChannel;
import io.flutter.plugin.common.FlutterMethodChannel.MethodCall;
import io.flutter.plugin.common.FlutterMethodChannel.MethodCallHandler;
import io.flutter.plugin.common.FlutterMethodChannel.Response;
import org.json.JSONException;
import org.json.JSONObject;
import com.esafirm.imagepicker.features.ImagePicker;
import com.esafirm.imagepicker.features.ImagePickerActivity;
import com.esafirm.imagepicker.features.camera.CameraModule;
import com.esafirm.imagepicker.features.camera.ImmediateCameraModule;
import com.esafirm.imagepicker.features.camera.OnImageReadyListener;
import com.esafirm.imagepicker.model.Image;
import java.util.ArrayList;
import java.util.List;
import android.util.Log;

/**
 * Location Plugin
 */
public class ImagePickerPlugin implements MethodCallHandler {
  private static String TAG = "flutter";
  private static final String CHANNEL = "ImagePicker";

  public static final int REQUEST_CODE_PICK = 2342;
  public static final int REQUEST_CODE_CAMERA = 2343;

  private FlutterActivity activity;
  private static ImagePickerPlugin plugin;

  // Pending method call to obtain an image
  private Response pendingResponse;

  public static void register(FlutterActivity activity) {
    plugin = new ImagePickerPlugin(activity);
  }

  private ImagePickerPlugin(FlutterActivity activity) {
    this.activity = activity;
    new FlutterMethodChannel(activity.getFlutterView(), CHANNEL).setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(MethodCall call, Response response) {
    if (pendingResponse != null) {
      response.error("ALREADY_ACTIVE", "Image picker is already active", null);
    }
    pendingResponse = response;
    if (call.method.equals("pick")) {
      ImagePicker.create(activity)
          .single()
          .start(REQUEST_CODE_PICK);
    } else if (call.method.equals("capture")) {
      DefaultCameraModule cameraModule = new DefaultCameraModule();
      startActivityForResult(cameraModule.getIntent(context), RC_REQUEST_CAMERA);
    } else {
      throw new IllegalArgumentException("Unknown method " + call.method);
    }
  }

  public static void onActivityResult(Context context, int requestCode, int resultCode, Intent data) {
    if (requestCode == REQUEST_CODE_PICK) {
      if (resultCode == Activity.RESULT_OK && data != null) {
        ArrayList<Image> images = (ArrayList<Image>) ImagePicker.getImages(data);
        Log.v(TAG, "We got images picked: " + images.size());
        printImages(images);
        plugin.handleResponse(images.get(0));
      } else {
        result.error("PICK_ERROR", "Error picking image", null);
        plugin.handleResponse(null);
      }
    } else if (requestCode == REQUEST_CODE_CAMERA) {
      if (resultCode == Activity.RESULT_OK && data != null)
        cameraModule.getImage(context, data, new OnImageReadyListener() {
          @Override
          public void onImageReady(List<Image> images) {
            Log.v(TAG, "We got images from the camera");
            printImages(images);
            //plugin.handleResponse(images);
          }
        });
    }
  }

  private void handleResponse(Image image) {
    if (pendingResponse != null) {
      pendingResponse.success(null);
      pendingResponse = null;
    } else {
      throw new IllegalStateException("Received images from picker that were not requested");
    }
  }

  private static void printImages(List<Image> images) {
    if (images == null) return;

    StringBuilder stringBuffer = new StringBuilder();
    for (int i = 0, l = images.size(); i < l; i++) {
      stringBuffer.append(images.get(i).getPath()).append("\n");
    }
    Log.v(TAG, stringBuffer.toString());
  }
}
