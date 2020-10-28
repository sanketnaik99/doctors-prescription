package com.example.flutter_doctorsprescription

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.flutter_doctorsprescription/pipeline"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method == "pipeline"){
                val args = call.arguments as Map<String, Any>;
                result.error("ERROR", "Something ${args} went wrong", null)
//                val imagePath = pipeline(args["imagePath"] as String)
//                if(imagePath != null){
//                    result.success(imagePath)
//                }else{
//                    result.error("ERROR", "Something went wrong", null);
//                }
            } else{
             result.error("ERROR", "Something went wrong", null)
            }
        }
    }

    private fun pipeline(imagePath: String): String {
        return imagePath;
    }
}
