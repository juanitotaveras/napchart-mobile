package net.polyphasic.polysleep

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  private val CHANNEL = "polysleep/alarm"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      // NOTE: This method is invoked on the main thread.
      // TODO
      if (call.method == "getRandomString") {
        result.success(getRandomString())
      }
    }
  }

  private fun getRandomString(): String {
    return "HI FROM ANDROID"
  }
}
