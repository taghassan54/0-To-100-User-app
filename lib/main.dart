import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zero_to_100_user_app/provider/facebook_login_provider.dart';
import 'package:zero_to_100_user_app/provider/featured_deal_provider.dart';
import 'package:zero_to_100_user_app/provider/google_sign_in_provider.dart';
import 'package:zero_to_100_user_app/provider/home_category_product_provider.dart';
import 'package:zero_to_100_user_app/provider/location_provider.dart';
import 'package:zero_to_100_user_app/provider/top_seller_provider.dart';
import 'package:zero_to_100_user_app/provider/wallet_transaction_provider.dart';
import 'package:zero_to_100_user_app/view/screen/order/order_details_screen.dart';
import 'package:zero_to_100_user_app/provider/auth_provider.dart';
import 'package:zero_to_100_user_app/provider/brand_provider.dart';
import 'package:zero_to_100_user_app/provider/cart_provider.dart';
import 'package:zero_to_100_user_app/provider/category_provider.dart';
import 'package:zero_to_100_user_app/provider/chat_provider.dart';
import 'package:zero_to_100_user_app/provider/coupon_provider.dart';
import 'package:zero_to_100_user_app/provider/localization_provider.dart';
import 'package:zero_to_100_user_app/provider/notification_provider.dart';
import 'package:zero_to_100_user_app/provider/onboarding_provider.dart';
import 'package:zero_to_100_user_app/provider/order_provider.dart';
import 'package:zero_to_100_user_app/provider/profile_provider.dart';
import 'package:zero_to_100_user_app/provider/search_provider.dart';
import 'package:zero_to_100_user_app/provider/seller_provider.dart';
import 'package:zero_to_100_user_app/provider/splash_provider.dart';
import 'package:zero_to_100_user_app/provider/support_ticket_provider.dart';
import 'package:zero_to_100_user_app/provider/theme_provider.dart';
import 'package:zero_to_100_user_app/provider/wishlist_provider.dart';
import 'package:zero_to_100_user_app/theme/dark_theme.dart';
import 'package:zero_to_100_user_app/theme/light_theme.dart';
import 'package:zero_to_100_user_app/utill/app_constants.dart';
import 'package:zero_to_100_user_app/view/screen/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import 'di_container.dart' as di;
import 'helper/custom_delegate.dart';
import 'localization/app_localization.dart';
import 'notification/my_notification.dart';
import 'provider/product_details_provider.dart';
import 'provider/banner_provider.dart';
import 'provider/flash_deal_provider.dart';
import 'provider/product_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true , ignoreSsl: true);
  await di.init();
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  int _orderID;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    _orderID = (notificationAppLaunchDetails.notificationResponse.payload != null && notificationAppLaunchDetails.notificationResponse.payload.isNotEmpty)
        ? int.parse(notificationAppLaunchDetails.notificationResponse.payload) : null;
  }
  final RemoteMessage remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (remoteMessage != null) {
    _orderID = remoteMessage.notification.titleLocKey != null ? int.parse(remoteMessage.notification.titleLocKey) : null;
  }
  print('========-notification-----$_orderID----===========');

  await MyNotification.initialize(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<HomeCategoryProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TopSellerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FlashDealProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FeaturedDealProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BrandProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductDetailsProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SellerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishListProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SupportTicketProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<GoogleSignInProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FacebookLoginProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WalletTransactionProvider>()),
    ],
    child: MyApp(orderId: _orderID),
  ));
}

class MyApp extends StatelessWidget {
  final int orderId;
  MyApp({@required this.orderId});

  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode, language.countryCode));
    });
    return MaterialApp(
      title: AppConstants.APP_NAME,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationProvider>(context).locale,
      localizationsDelegates: [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackLocalizationDelegate()
      ],
      supportedLocales: _locals,
      home: orderId == null ? SplashScreen() : OrderDetailsScreen(orderModel: null,
        orderId: orderId, orderType: 'default_type',isNotification: true),
    );
  }
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}