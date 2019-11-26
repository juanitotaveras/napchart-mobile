package net.polyphasic.polysleep

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Vibrator
import android.support.v4.content.WakefulBroadcastReceiver
import android.util.Log

//import android.support.v4.content.WakefulBroadcastReceiver

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.e("x", "HEY LOOK WE HAVE RECEIVED IT!")
        executeVibration(context)
    }

    private fun executeVibration(context: Context?) {
        val v = context?.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        /* First element is delay amount, then alternates between vibrate and sleep. */
        val vibrationPattern = longArrayOf(0, 400, 400, 400, 400, 400)
        /* If URI is length of Ringtone, play one of the default selections. */
        v.vibrate(vibrationPattern, -1)
    }
}