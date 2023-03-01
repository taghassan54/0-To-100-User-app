import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

class AdManager {

 static String adUnitId = Platform.isAndroid
      ? 'ca-app-pub-8107574011529731/5342770480'
      : 'ca-app-pub-8107574011529731/5342770480';
  final AdRequest request = const AdRequest(
    // keywords: <String>['foo', 'bar'],
    // contentUrl: 'http://foo.com/bar.html',
    // nonPersonalizedAds: true,
  );

 static  AdWidget adWidget;
 static  Container adContainer=Container();
 static final AdManagerBannerAd myBanner = AdManagerBannerAd(
      adUnitId: adUnitId,
      sizes: [AdSize.banner],
      request: const AdManagerAdRequest(),
      listener: AdManagerBannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('Banner Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();

          print('Banner Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Banner Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Banner Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Banner Ad impression.'),
      )
  );

 static showBannerAd() {
   adWidget = AdWidget(ad: myBanner);
   adContainer = Container(
     alignment: Alignment.center,
     width: 300,
     height: 50,
     child: adWidget,
   );
   myBanner.load();
 }

}