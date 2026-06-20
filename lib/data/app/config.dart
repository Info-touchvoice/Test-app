import 'dart:ui';

class Config {
  static const String packageNameAndroid = "com.livestream.touchvoice";
  static const String packageNameIOS = "com.livestream.touchvoice";
  static const String iosAppStoreId = "1631705048";
  static final String appName = "Touch Voice";
  static final String appVersion = "1.0.2";
  static final String companyName = "Touch Voice";
  static final String appOrCompanyUrl = "https://tiki.page.link";
  // Admin backend (used for Stripe Connect onboarding in-app)
  // NOTE: During local development you can point this to your backend host.
  // If you test on:
  // - Android emulator: use http://10.0.2.2:5000
  // - Real phone: use http://<YOUR_PC_LAN_IP>:5000 (phone + PC must be on same Wi‑Fi)
static final String adminBackendUrl = "http://192.168.1.50:5000";
  static final String initialCountry = 'US'; // United States

  static final String serverUrl = "https://parseapi.back4app.com/";
  static final String liveQueryUrl = "wss://tikilives.b4a.io/";
  static final String appId = "d0Wzbu0nSWEYIUmZQVeskYJk4HDBxQNfvydi7dA7";
  static final String clientKey = "j9A2OcaNHtdWYytIsuHPfeFb9r4uN1nrYXHYjyWR";

  static final String pushGcm = "95114049968";
  static final String webPushCertificate =
      "BCsaRAkUVV8JpitKLK_dWzEz9wYDYyxQQrMo15MYQdrtQPZHIO_yjEokQG0NMFCmQr0Y-SnFzUj4NbBnGH8qEPg";

  // User support objectId
  static final String supportId = "";

  // Play Store and App Store public keys
  static final String publicGoogleSdkKey = "goog_ktrhyGbCrWyfYXUlrStILIkzoIN";
  static final String publicIosSdkKey = "_";

  // Languages
  // static String defaultLanguage = "en"; // English is default language.
  static String defaultLanguage = "en"; // English is default language.
  static List<Locale> languages = [
    Locale(defaultLanguage),
    //Locale('pt'),
    //Locale('fr')
  ];

  // Dynamic link
  static const String inviteSuffix = "invitee";
  static const String reelsSuffix = "reel";
  static const String postSuffix = "post";
  static const String uriPrefix = "https://tiki.page.link";
  static const String link = "https://tiki.page.link";

  // Android Admob ad
  static const String admobAndroidOpenAppAd =
      "ca-app-pub-3285903611547029/5560407341";
  static const String admobAndroidHomeBannerAd =
      "ca-app-pub-3285903611547029/6127343278";
  static const String admobAndroidFeedNativeAd =
      "ca-app-pub-3285903611547029/1109437422";
  static const String admobAndroidChatListBannerAd =
      "ca-app-pub-3285903611547029/3501179930";
  static const String admobAndroidLiveBannerAd =
      "ca-app-pub-3285903611547029/8179872141";
  static const String admobAndroidFeedBannerAd =
      "ca-app-pub-3285903611547029/9198522887";

  // iOS Admob ad
  static const String admobIOSOpenAppAd =
      "ca-app-pub-1084112649181796/632434508";
  static const String admobIOSHomeBannerAd =
      "ca-app-pub-1084112649181796/114347057";
  static const String admobIOSFeedNativeAd =
      "ca-app-pub-1084112649181796/7224533806";
  static const String admobIOSChatListBannerAd =
      "ca-app-pub-1084112649181796/58153458";
  static const String admobIOSLiveBannerAd =
      "ca-app-pub-1084112649181796/80953539063";
  static const String admobIOSFeedBannerAd =
      "ca-app-pub-1084112649181796/69053535815";

  // Web links for help, privacy policy and terms of use.
  static final String helpCenterUrl = "https://tiki.page.link";
  static final String privacyPolicyUrl =
      "https://app.termly.io/document/privacy-policy/9e61c4d5-4275-44d8-bead-50a172cd9478";
  static final String termsOfUseUrl =
      "https://app.termly.io/document/terms-of-service/2b34440d-ce04-4a57-a7a6-adda4a4937a0";
  static final String termsOfUseInAppUrl =
      "https://app.termly.io/document/terms-of-service/2b34440d-ce04-4a57-a7a6-adda4a4937a0";
  static final String dataSafetyUrl = "https://tiki.page.link";
  static final String openSourceUrl = "https://tiki.page.link";
  static final String instructionsUrl = "https://tiki.page.link";
  static final String cashOutUrl = "https://tiki.page.link";
  static final String supportUrl = "https://tiki.page.link";

  // Google Play and Apple Pay In-app Purchases IDs
  // static final String credit10 = "tiki.100.credits";
  // static final String credit200 = "tiki.200.credits";
  // static final String credit500 = "tiki.500.credits";
  // static final String credit1000 = "tiki.1000.credits";
  // static final String credit2100 = "tiki.2100.credits";
  // static final String credit5250 = "tiki.5250.credits";
  // static final String credit10500 = "tiki.10500.credits";

  static final String credit10 = '10 diamonds';
  static final String credit30 = '30 diamonds';
  static final String credit235 = '235 diamonds';
  static final String credit566 = '566 diamonds';
  static final String credit700 = '700 diamonds';
  static final String credit999 = '999 diamonds';
  static final String credit1200 = '1200 diamonds';
  static final String credit2352 = '2352 diamonds';
  static final String credit4000 = '4000 diamonds';
}
