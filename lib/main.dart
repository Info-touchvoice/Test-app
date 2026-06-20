import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki/data/app/constants.dart';
import 'package:tiki/data/app/setup.dart';
import 'package:wakelock/wakelock.dart';
import 'package:tiki/parse/BattleStreamingModel.dart';
import 'package:tiki/parse/CommentsModel.dart';
import 'package:tiki/parse/GiftsModel.dart';
import 'package:tiki/parse/GiftsSentModel.dart';
import 'package:tiki/parse/InvitedUsersModel.dart';
import 'package:tiki/parse/MessageListModel.dart';
import 'package:tiki/parse/MessageModel.dart';
import 'package:tiki/parse/NotificationsModel.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/parse/PostsModel.dart';
import 'package:tiki/parse/RankingModel.dart';
import 'package:tiki/parse/ReportModel.dart';
import 'package:tiki/parse/SubscriptionModel.dart';
import 'package:tiki/parse/TimerModel.dart';
import 'package:tiki/parse/WhisperListModel.dart';
import 'package:tiki/parse/WhisperModel.dart';
import 'package:tiki/parse/WithdrawModel.dart';
import 'package:tiki/parse/BannerModel.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tiki/parse/UserModel.dart';
import 'package:tiki/data/app/navigation_service.dart';
import 'package:tiki/purchase/purchase.dart';
import 'package:tiki/utils/routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiki/utils/theme/theme_helper.dart';
import 'parse/MusicModel.dart';
import 'parse/PaymentsModel.dart';
import 'parse/ReplyModel.dart';
import 'services/dynamic_link_service.dart';
import 'services/banner_popup_service.dart';
import 'data/app/config.dart';
import 'parse/LiveMessagesModel.dart';
import 'parse/LiveStreamingModel.dart';
import 'view_model/animation_controller.dart';
import 'view_model/theme_controller.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Used by screens (e.g. reels) to know when another route covers them so they can pause media.
final RouteObserver<PageRoute<dynamic>> routeObserver = RouteObserver<PageRoute<dynamic>>();
void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Future.wait([
    _initFirebase(),
    EasyLocalization.ensureInitialized(),
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light));

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Stripe.publishableKey =
      'pk_live_51I7PORFscf0wcwAmgLtfR6UIpCzSWiTwpAjPSQb85cO5hjhgP1WBJJvImDjveuYv0ATsnQcXYSoFu6gdQczwlh7y00ypU4BVXb';



  Map<String, ParseObjectConstructor> subClassMap =
      <String, ParseObjectConstructor>{
    PostsModel.keyTableName: () => PostsModel(),
    RankingModel.keyTableName: () => RankingModel(),
    NotificationsModel.keyTableName: () => NotificationsModel(),
    CommentsModel.keyTableName: () => CommentsModel(),
    GiftsModel.keyTableName: () => GiftsModel(),
    GiftsSentModel.keyTableName: () => GiftsSentModel(),
    LiveStreamingModel.keyTableName: () => LiveStreamingModel(),
    LiveMessagesModel.keyTableName: () => LiveMessagesModel(),
    LiveMessagesModel.keyTableName: () => LiveMessagesModel(),
    MessageModel.keyTableName: () => MessageModel(),
    MessageListModel.keyTableName: () => MessageListModel(),
    WhisperModel.keyTableName: () => WhisperModel(),
    WhisperListModel.keyTableName: () => WhisperListModel(),
    WithdrawModel.keyTableName: () => WithdrawModel(),
    PaymentsModel.keyTableName: () => PaymentsModel(),
    InvitedUsersModel.keyTableName: () => InvitedUsersModel(),
    MusicModel.keyTableName: () => MusicModel(),
    ReplyModel.keyTableName: () => ReplyModel(),
    ReportModel.keyTableName: () => ReportModel(),
    BattleModel.keyTableName: () => BattleModel(),
    TimerModel.keyTableName: () => TimerModel(),
    SubscriptionModel.keyTableName: () => SubscriptionModel(),
    BannerModel.keyTableName: () => BannerModel(),
  };

  await Parse().initialize(
    Config.appId,
    Config.serverUrl,
    clientKey: Config.clientKey,
    liveQueryUrl: Config.liveQueryUrl,
    autoSendSessionId: true,
    // coreStore: QuickHelp.isWebPlatform()
    //     ? await CoreStoreSharedPrefsImp.getInstance()
    //     : await CoreStoreSembastImp.getInstance(password: Config.appId),
    debug: Setup.isDebug,
    appName: Setup.appName,
    appPackageName: Setup.appPackageName,
    appVersion: Setup.appVersion,
    locale: await Devicelocale.currentLocale,
    parseUserConstructor: (username, password, email,
            {client, debug, sessionToken}) =>
        UserModel(username, password, email),
    registeredSubClassMap: subClassMap,
  );

  runZonedGuarded<Future<void>>(
    () async {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      runApp(
        EasyLocalization(
          supportedLocales: Config.languages,
          path: 'assets/translations',
          fallbackLocale: Locale(Config.defaultLanguage),
          child: App(),
        ),
      );

      unawaited(_warmUpAppServices());
    },
    (error, stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error firebase initialize');
  }
}

Future<void> _warmUpAppServices() async {
  try {
    await PurchaseApi.init();
    await initPlatformState();
    if (QuickHelp.isMobile()) {
      await MobileAds.instance.initialize();
    }
    DynamicLinkService().retrieveDynamicLink();
  } catch (_) {}
}

Future<void> initPlatformState() async {
  if (Setup.isDebug) {
    await Purchases.setLogLevel(LogLevel.verbose);
  }

  PurchasesConfiguration? configuration;

  if (QuickHelp.isAndroidPlatform()) {
    configuration = PurchasesConfiguration(Config.publicGoogleSdkKey);
  } else if (QuickHelp.isIOSPlatform()) {
    configuration = PurchasesConfiguration(Config.publicIosSdkKey);
  }
  await Purchases.configure(configuration!);
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late SharedPreferences preferences;
  AnimationViewModel animationController =Get.put(AnimationViewModel());
  final ThemeController themeController = Get.put(ThemeController());

  bool _isLiveRoute(String? route) {
    if (route == null) return false;
    return route == AppRoutes.streamerAudioLive ||
        route == AppRoutes.audienceAudioLive;
  }

  void _ensureWakelockCorrectForRoute(String? route) {
    // IMPORTANT:
    // LiveViewModel enables wakelock when entering live. If the controller isn't
    // disposed for some navigation paths, wakelock can stay enabled and the phone
    // won't sleep/lock. Force-disable it for all non-live routes.
    if (_isLiveRoute(route)) return;
    try {
      Wakelock.disable();
    } catch (_) {}
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    Future.delayed(Duration(seconds: 2), () {
      DynamicLinkService().listenDynamicLink(context);
    });

    initSharedPref();
    WidgetsBinding.instance.addObserver(this);
    // Default: allow phone to sleep/lock unless in a live screen.
    _ensureWakelockCorrectForRoute(Get.currentRoute);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If app is backgrounded/inactive, never keep wakelock on (prevents phone lock / drains battery).
    // On resume, re-apply route-based rule (live screens may re-enable inside their controllers).
    if (state == AppLifecycleState.resumed) {
      _ensureWakelockCorrectForRoute(Get.currentRoute);
    } else {
      try {
        Wakelock.disable();
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (_ , child) {
        return ResponsiveSizer(
            builder: (context, orientation, screenType) {
              return GetMaterialApp(
                title: Setup.appName,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                navigatorKey: NavigationService.navigatorKey,
                navigatorObservers: [routeObserver],
                routingCallback: (routing) {
                  // Every navigation change: disable wakelock if not in live.
                  _ensureWakelockCorrectForRoute(routing?.current);
                },
                locale: context.locale,
                scrollBehavior:
                ScrollConfiguration.of(context).copyWith(overscroll: false),
                theme: ThemeHelper.lightTheme,
                darkTheme: ThemeHelper.darkTheme,
                themeMode: ThemeMode.light,
                getPages: AppRoutes.pages,
                initialRoute: AppRoutes.initial,
              );

        });});
  }

  logoutUserPurchase() async {
    if (!await Purchases.isAnonymous) {
      await Purchases.logOut().then((value) => print("purchase logout"));
    }
  }

  initSharedPref() async {
    preferences = await SharedPreferences.getInstance();
    Constants.queryParseConfig(preferences);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
