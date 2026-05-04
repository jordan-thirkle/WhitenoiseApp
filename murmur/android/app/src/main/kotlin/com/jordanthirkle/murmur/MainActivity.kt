package com.jordanthirkle.murmur

import android.os.PowerManager
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: AudioServiceActivity() {
    private val CHANNEL = "com.jordanthirkle.murmur/thermal"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getThermalHeadroom") {
                val seconds = call.argument<Int>("seconds") ?: 0
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                    val powerManager = getSystemService(POWER_SERVICE) as PowerManager
                    result.success(powerManager.getThermalHeadroom(seconds))
                } else {
                    result.success(1.0)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
