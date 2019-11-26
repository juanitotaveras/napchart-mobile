package net.polyphasic.polysleep

import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder
import android.os.Vibrator
import android.util.Log

class AlarmService : Service() {
    override fun onBind(intent: Intent?): IBinder? {
        Log.e("x", "BINDING MADE")
         return null
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int) : Int {
        executeVibration()
        Log.e("x", "OMG HI")
        return Service.START_STICKY
    }

    private fun executeVibration() {
            val v = applicationContext.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            /* First element is delay amount, then alternates between vibrate and sleep. */
            val vibrationPattern = longArrayOf(0, 400, 400, 400, 400, 400)
            /* If URI is length of Ringtone, play one of the default selections. */
            v.vibrate(vibrationPattern, -1)
    }

}