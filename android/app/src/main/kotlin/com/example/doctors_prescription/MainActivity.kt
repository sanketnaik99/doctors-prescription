package com.example.doctors_prescription

import android.content.res.AssetManager
import android.graphics.Bitmap
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.opencv.android.OpenCVLoader
import org.opencv.android.Utils
import org.opencv.core.*
import org.opencv.core.Core.*
import org.opencv.core.CvType.CV_8UC1
import org.opencv.imgcodecs.Imgcodecs.*
import org.opencv.imgproc.Imgproc.*
import java.io.IOException
import java.nio.ByteBuffer
import org.tensorflow.lite.Interpreter
import java.io.FileInputStream
import java.nio.ByteOrder
import java.nio.channels.FileChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import kotlin.math.abs

class MainActivity() : FlutterActivity() {
    private val CHANNEL = "com.example.flutter_doctorsprescription/pipeline"

    private val executorService: ExecutorService = Executors.newCachedThreadPool()
    private var inputImageWidth: Int = 0 // will be inferred from TF Lite model
    private var inputImageHeight: Int = 0 // will be inferred from TF Lite model
    private var modelInputSize: Int = 0
    private val classes: String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabdefghnqrt"
    private var preds: MutableList<String> = ArrayList()

    init {
        if(OpenCVLoader.initDebug()){
            Log.i("OPENCV", "LOADED OPENCV")
        }else{
            Log.e("OPENCV", "ERROR LOADING OPENCV")
        }
    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if(call.method == "pipeline"){
                val args = call.arguments as Map<String, Any>
                val imagePath = pipeline(args["imagePath"] as String)
                if(imagePath != null){
                    result.success(imagePath)
                }else{
                    result.error("ERROR", "Something went wrong", null);
                }
            } else{
                result.error("ERROR", "Something went wrong", null)
            }
        }
    }

    private fun pipeline(imagePath: String): MutableList<String> {
        val startTime = System.nanoTime()
        if (OpenCVLoader.initDebug()){
            Log.i("OPENCV", "OPEN CV INIT")
        }else{
            Log.e("OPENCV", "ERROR LOADING OPENCV")
        }
        val originalImage: Mat = imread(imagePath)
        val image: Mat = originalImage.clone()
        val pathList = imagePath.split(".").toMutableList()
        pathList[pathList.size - 2] = pathList[pathList.size - 2] + "-new"
        val newPath = pathList.joinToString(".")
//        Log.i("OPENCV", "NEW PATH => ${newPath}")
        resize(image, image, Size(300.0, 300.0))
        resize(originalImage, originalImage, Size(300.0, 300.0))

        // CHANGE COLOR TO GREY
        cvtColor(image, image, COLOR_RGB2GRAY)

        // Median Blur
        val bg_img : Mat = Mat()
        medianBlur(image, bg_img,21);

        // Abs DIFF
        //absdiff(image, bg_img, image)

        // Normalize
        normalize(image, image, 0.0, 255.0, NORM_MINMAX, CV_8UC1)

        // Morphology EX
        morphologyEx(image, image, MORPH_OPEN, getStructuringElement(MORPH_RECT, Size(2.0,2.0)))

        //Create Clahe
        val clahe = createCLAHE(2.0, Size(8.0,8.0))
        clahe.apply(image, image)

        // Detect Contours
        val contours: List<MatOfPoint> = ArrayList()
        val hierarchy = Mat()
        val cannyOutput = Mat()
        threshold(image, image, 150.0, 255.0, THRESH_BINARY_INV + THRESH_OTSU)
        findContours(image, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_NONE)

        // Get Rectangles array
        val n = contours.size
        val rects: MutableList<MutableList<Int>> = ArrayList()

        for (i in 0 until n){
            var rect = Rect()
            rect = boundingRect(contours[i])
            rects.add(mutableListOf<Int>(rect.x, rect.y, rect.x + rect.width, rect.y + rect.height))
            //Log.i("CONTOUR", "CONTOUR $i => ${rects[i.toInt()]}")
        }

        // Group Rectangles
        var rectanglesGrouped: MutableList<MutableList<MutableList<Int>>> = ArrayList()
        var current: MutableList<Int> = ArrayList()
        var unmatched = rects
        while(unmatched.size > 0){
            current = unmatched.removeAt(0)
//            Log.i("GROUPING START", "CURRENT => $current")
            var matches = mutableListOf(current)
            var notMatched: MutableList<MutableList<Int>> = ArrayList()
            for(i in 0 until unmatched.size){
                val rect = unmatched[i]
                val area = abs(rect[0] - rect[2])*abs(rect[1] - rect[3])
//                Log.i("GROUPING", "RECT $i -> Area = $area")
                if(area < 60){
//                    Log.i("GROUPING", "Area too small")
                    continue
                }
                if(kotlin.math.abs((rect[1] - current[1])) < 50){
//                    Log.i("GROUPING", "FOUND MATCH => $rect DIFF = ${kotlin.math.abs((rect[1] - current[1]))}")
                    matches.add(rect)
                }
                else{
                    // Log.i("GROUPING", "DID NOT MATCH => $rect")
                    notMatched.add(rect)
                }
            }
            matches.sortBy { r -> r[0] }
//            Log.i("GROUPING DONE", "MATCHES -> $matches")
            rectanglesGrouped.add(matches)
            unmatched = notMatched
        }

        Log.i("GROUPED", "GROUPED RECTS -> $rectanglesGrouped")
        for(i in 0 until rectanglesGrouped.size){
            var group = rectanglesGrouped[i]
            var rect1 = group[0]
            var rect2 = group[group.size - 1]
//            Log.i("RECTANGLES", "R1 => $rect1 \nR2 => $rect2")
            rectangle(originalImage, Point(((rect1[0] - 10).toDouble()), ((rect1[1] - 10).toDouble())), Point(((rect2[2] + 10).toDouble()), ((rect2[3] + 10).toDouble())), Scalar(0.0,255.0,0.0, 255.0), 1, 4, 0)
        }

        val assetManager = context.assets
        var model : ByteBuffer = loadModel(assetManager)

        val options = Interpreter.Options()
        options.setUseNNAPI(true)
        val interpreter: Interpreter = Interpreter(model, options)
        val inputShape = interpreter.getInputTensor(0).shape()
        inputImageWidth = inputShape[1]
        inputImageHeight = inputShape[2]
        modelInputSize = FLOAT_TYPE_SIZE * inputImageWidth * inputImageHeight * PIXEL_SIZE

        // CROP INDIVIDUAL CHARACTERS
        preds.clear()
        var groups: MutableList<MutableList<Mat>> = ArrayList()
        for(i in 0 until rectanglesGrouped.size){
            var individualChars: MutableList<Mat> = ArrayList()
            var pred: String = ""
            var n = rectanglesGrouped[i]
            for(j in 0 until n.size){
                val rect = n[j]
                val width = rect[2] - rect[0]
                val height = rect[3] - rect[1]
                val roi: Rect = Rect(rect[0], rect[1], width, height)
                val cropped: Mat = Mat(image, roi)
                resize(cropped, cropped, Size(18.0, 18.0))
                copyMakeBorder(cropped, cropped, 5,5,5,5, BORDER_CONSTANT, Scalar(0.0,0.0,0.0,255.0))
                // Perform Prediction
                cvtColor(cropped, cropped, COLOR_GRAY2RGB)
                val bitmap: Bitmap = Bitmap.createBitmap(cropped.cols(), cropped.rows(), Bitmap.Config.ARGB_8888)
                Utils.matToBitmap(cropped, bitmap)
                val resizedImage = Bitmap.createScaledBitmap(bitmap, inputImageWidth, inputImageHeight, true)
                val byteBuffer = convertBitmapToByteBuffer(resizedImage)
                val result = Array(1) { FloatArray(OUTPUT_CLASSES_COUNT) }
                interpreter.run(byteBuffer, result)

                val string = getOutputString(result[0])
                pred += string

                individualChars.add(cropped)
            }
            preds.add(pred)
            Log.i("PREDS", preds.toString())
            groups.add(individualChars)
        }


        imwrite(newPath, originalImage)
        val elapsedTime = (System.nanoTime() - startTime) / 1000000
        Log.i("FINAL PREDICTION", "Prediction => ${preds.joinToString(" ")}")
        Log.d("TFLITE", "Preprocessing time = " + elapsedTime + "ms")
        val result: MutableList<String> = ArrayList()
        result.add(newPath)
        result.add(preds.joinToString(" "))
        return result
    }

    @Throws(IOException::class)
    private fun loadModel(assetManager: AssetManager): ByteBuffer {
        val fileDescriptor = assetManager.openFd(MODEL_FILE)
        val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
        val fileChannel = inputStream.channel
        val startOffset = fileDescriptor.startOffset
        val declaredLength = fileDescriptor.declaredLength
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
    }

    private fun getOutputString(output: FloatArray): String {
        val maxIndex = output.indices.maxBy { output[it] } ?: -1
        Log.i("PREDICTION", "Prediction Result: %s\nConfidence: %2f".format(classes[maxIndex], output[maxIndex]))
        return classes[maxIndex].toString()
    }

    private fun convertBitmapToByteBuffer(bitmap: Bitmap): ByteBuffer {
        val byteBuffer = ByteBuffer.allocateDirect(modelInputSize)
        byteBuffer.order(ByteOrder.nativeOrder())

        val pixels = IntArray(inputImageWidth * inputImageHeight)
        bitmap.getPixels(pixels, 0, bitmap.width, 0, 0, bitmap.width, bitmap.height)

        for (pixelValue in pixels) {
            val r = (pixelValue shr 16 and 0xFF)
            val g = (pixelValue shr 8 and 0xFF)
            val b = (pixelValue and 0xFF)

            // Convert RGB to grayscale and normalize pixel value to [0..1]
            val normalizedPixelValue = (r + g + b) / 3.0f / 255.0f
            byteBuffer.putFloat(normalizedPixelValue)
        }

        return byteBuffer
    }

    


    companion object {
        private const val TAG = "DigitClassifier"

        private const val MODEL_FILE = "handwriting.tflite"

        private const val FLOAT_TYPE_SIZE = 4
        private const val PIXEL_SIZE = 1

        private const val OUTPUT_CLASSES_COUNT = 47
    }
}