package com.example.mobile;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private String sharedFilePath;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    Intent intent = getIntent();

    if (Intent.ACTION_SEND.equals(intent.getAction())) {
      Uri fileUri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
      sharedFilePath = fileUri.getPath();
    }

    new MethodChannel(getFlutterView(), "app.channel.shared.data")
        .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
            if (methodCall.method.contentEquals("getSharedFilePath")) {
              result.success(sharedFilePath);
              sharedFilePath = null;
            }
          }
        });
  }
}
