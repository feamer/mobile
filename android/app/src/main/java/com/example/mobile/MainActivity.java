package com.example.mobile;

import android.Manifest.permission;
import android.annotation.TargetApi;
import android.app.Notification;
import android.app.Notification.Builder;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Build.VERSION;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private String sharedFilePath;

  private NotificationManager notificationManager;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    Intent intent = getIntent();
    notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

    if (Intent.ACTION_SEND.equals(intent.getAction())) {
      Uri fileUri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
      sharedFilePath = fileUri.getPath();
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      requestPermissions(new String[] {android.Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
      requestPermissions(new String[] {permission.CAMERA}, 1);
    }

    Intent shareIntent = new Intent(this, ShareService.class);
    startService(shareIntent);

    new MethodChannel(getFlutterView(), "app.channel.shared.data")
        .setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.contentEquals("getSharedFilePath")) {
                  result.success(sharedFilePath);
                  sharedFilePath = null;
                } else if (methodCall.method.contentEquals("showNotification")) {
                  String name = methodCall.argument("name");

                  Notification notification;
                  if (VERSION.SDK_INT >= 26) {
                    notification =
                        createNotification()
                            .setContentTitle("Received a file!!")
                            .setContentText(name)
                            .build();
                  } else {
                    notification = new Notification();
                    notification.tickerText = name;
                  }

                  notificationManager.notify(1, notification);
                }
              }
            });
  }

  @TargetApi(26)
  public Builder createNotification() {
    return new Builder(this, "1")
        .setSmallIcon(getApplicationInfo().icon);
  }
}
