package io.flutter.plugins.imagepicker;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import io.flutter.app.FlutterActivity;
import io.flutter.view.FlutterView;
import io.flutter.plugin.common.FlutterMethodChannel;
import io.flutter.plugin.common.FlutterMethodChannel.MethodCallHandler;
import io.flutter.plugin.common.FlutterMethodChannel.Response;
import io.flutter.plugin.common.MethodCall;
import org.json.JSONException;
import org.json.JSONObject;
import com.esafirm.imagepicker.features.ImagePicker;
import com.esafirm.imagepicker.features.ImagePickerActivity;
import com.esafirm.imagepicker.features.camera.CameraModule;
import com.esafirm.imagepicker.features.camera.DefaultCameraModule;
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
  private static final String CHANNEL = "image_picker";

  public static final int REQUEST_CODE_PICK = 2342;
  public static final int REQUEST_CODE_CAMERA = 2343;

  private FlutterActivity activity;

  private static final DefaultCameraModule cameraModule = new DefaultCameraModule();

  // Pending method call to obtain an image
  private Response pendingResponse;

  public static ImagePickerPlugin register(FlutterActivity activity) {
    return new ImagePickerPlugin(activity);
  }

  private ImagePickerPlugin(FlutterActivity activity) {
    this.activity = activity;
    new FlutterMethodChannel(activity.getFlutterView(), CHANNEL).setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(MethodCall call, Response response) {
    if (pendingResponse != null) {
      response.error("ALREADY_ACTIVE", "Image picker is already active", null);
      return;
    }
    pendingResponse = response;
    if (call.method.equals("pickImage")) {
      ImagePicker.create(activity)
          .single()
          .start(REQUEST_CODE_PICK);
    } else if (call.method.equals("captureImage")) {
      activity.startActivityForResult(cameraModule.getCameraIntent(activity), REQUEST_CODE_CAMERA);
    } else {
      throw new IllegalArgumentException("Unknown method " + call.method);
    }
  }

  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == REQUEST_CODE_PICK) {
      if (resultCode == Activity.RESULT_OK && data != null) {
        ArrayList<Image> images = (ArrayList<Image>) ImagePicker.getImages(data);
        handleResponse(images.get(0));
      } else {
        pendingResponse.error("PICK_ERROR", "Error picking image", null);
        pendingResponse = null;
      }
    } else if (requestCode == REQUEST_CODE_CAMERA) {
      if (resultCode == Activity.RESULT_OK && data != null)
        cameraModule.getImage(activity, data, new OnImageReadyListener() {
          @Override
          public void onImageReady(List<Image> images) {
            handleResponse(images.get(0));
          }
        });
    }
  }

  private void handleResponse(Image image) {
    if (pendingResponse != null) {
      pendingResponse.success(image.getPath());
      pendingResponse = null;
    } else {
      throw new IllegalStateException("Received images from picker that were not requested");
    }
  }
}
