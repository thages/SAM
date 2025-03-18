# Keep the ML Kit text recognition classes
-keep class com.google.mlkit.vision.text.** { *; }

# Exclude unused language models (if not needed)
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
