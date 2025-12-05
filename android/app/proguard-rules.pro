# Flutter Sound - Keep all classes
-keep class com.dooboolab.fluttersound.** { *; }
-keep class xyz.canardoux.flutter_sound.** { *; }

# Prevent removing Flutter plugin registrars
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep audio classes
-keep class androidx.media.** { *; }
-keep class android.media.** { *; }
