#-keepclasseswithmembernames,includedescriptorclasses class * {
#    native <methods>;
#}

##---------------Begin: proguard configuration for VK  ----------
-keep class com.vk.** { *; }
##---------------End: proguard configuration for VK  ----------
#
#-keepclassmembers class ai.deepar.ar.DeepAR { *; }
#-keepclassmembers class ai.deepar.ar.core.videotexture.VideoTextureAndroidJava { *; }
#-keep class ai.deepar.ar.core.videotexture.VideoTextureAndroidJava


-keep class **.zego.**{*;}

##---------------Begin: Google Sign-In / Firebase Auth (release minify) ----------
## These rules help avoid R8 stripping classes used via reflection.
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
##---------------End: Google Sign-In / Firebase Auth ----------
