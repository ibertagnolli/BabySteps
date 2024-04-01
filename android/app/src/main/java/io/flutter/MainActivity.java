// TODO add imports? maybe package name?
package com.babysteps;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    String sharedText;
    private static final String CHANNEL = "app.channel.shared.data";


    /**
     * Handle the intent. If we get an ACTION_CREATE_NOTE intent and it is a text,
     * extract the value and store it in savedNote.
     * @param savedInstanceState
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // GeneratedPluginRegistrant.registerWith(this);
        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();

        if (Intent.ACTION_CREATE_NOTE.equals(action) && type != null) {
            if ("text/plain".equals(type)) {
                handleSendText(intent); // Handle text being sent
            }
        }

        // Since we can't explicitly tell our Flutter app that we have a note, we can
        // only return it when asked for it. The MethodChannel handles that. When
        // MethodChannel "getSavedNote" is invoked, we return savedNote and then set it 
        // to null.
        // new MethodChannel(getFlutterView(), "app.channel.shared.data")
        //         .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
        //             @Override
        //             public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        //                 if (methodCall.method.contentEquals("getSavedNote")) {
        //                     result.success(savedNote);
        //                     savedNote = null;
        //                 }
        //             }
        //         });
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
  
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.contentEquals("getSharedText")) {
                                result.success(sharedText);
                                sharedText = null;
                            }
                        }
                );
    }

    void handleSendText(Intent intent) {
        sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
    }
}