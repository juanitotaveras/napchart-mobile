package net.polyphasic.polysleep

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log

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
      // TODO: Need method to see what alarms are currently set
      // todo: Need method to set a new alarm

      when (call.method) {
        "getRandomString" -> {
          result.success(getRandomString())
        }
        "setAlarm" -> {
//          Log.e("hi", call.arguments.toString())
          val msSinceEpochForNewAlarm = call.arguments as Long
          val mgr = applicationContext.getSystemService(Context.ALARM_SERVICE) as AlarmManager
          val i = Intent(this, AlarmReceiver::class.java)
          val pendingIntent = PendingIntent.getBroadcast(applicationContext, 0,
                  i, PendingIntent.FLAG_UPDATE_CURRENT)
          val PERIOD = 8000
          val ac = AlarmManager.AlarmClockInfo(msSinceEpochForNewAlarm, pendingIntent)
          mgr.setAlarmClock(ac, pendingIntent)
          Log.e("x", "setting the clock")
          result.success("success")
        }
      }
    }
  }

  private fun getRandomString(): String {
    return "HI FROM ANDROID"
  }
}
