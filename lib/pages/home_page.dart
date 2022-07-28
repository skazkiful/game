import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/firebase_options.dart';
import '/pages/webview_page.dart';
import '/widgets/home_page_button.dart';
import '/widgets/popup_widget.dart';

/// Home page.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

/// [State] of [HomePage].
class _HomePageState extends State<HomePage> {
  /// [SharedPreferences] used to store and fetch some information.
  late SharedPreferences prefs;

  /// Defines opacity of [PopupWidget].
  double animatedOpacity = 0;

  /// Indicator where [PopupWidget] need to show or not.
  bool showAnimatedWidget = false;

  /// Url of WebView site.
  String webViewUrl = '';

  @override
  void initState() {
    initApp();
    super.initState();
  }

  /// Initiate application.
  Future<void> initApp() async {
    prefs = await SharedPreferences.getInstance();

    Map appsFlyerOptions = {
      "afDevKey": 'afDevKey',
      "afAppId": 'appId',
      "isDebug": true
    };

    AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);

    appsflyerSdk.onAppOpenAttribution(
        (_) => prefs.setString('attribution', _.toString()));

    OneSignal.shared.setAppId("8a4a8b1e-82b7-465b-a3ea-5f89e4ba0a51");
    OneSignal.shared.promptUserForPushNotificationPermission();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();

    setState(
        () => webViewUrl = remoteConfig.getValue('webview_url').asString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomePageButton(
                    'SITE',
                    () {
                      OneSignal.shared.sendTag('page', 'site');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPage(webViewUrl)),
                      );
                    },
                    true,
                  ),
                  const SizedBox(height: 63),
                  HomePageButton(
                    'GAME',
                    () {
                      OneSignal.shared.sendTag('page', 'game');
                      setState(() {
                        showAnimatedWidget = true;
                        animatedOpacity = 1;
                      });
                    },
                    false,
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: animatedOpacity,
              duration: const Duration(milliseconds: 500),
              child: (showAnimatedWidget)
                  ? Center(
                      child: PopupWidget(
                      prefs,
                      onClosed: () => setState(() => animatedOpacity = 0),
                    ))
                  : null,
              onEnd: () => setState(
                () => (animatedOpacity == 1)
                    ? showAnimatedWidget = true
                    : showAnimatedWidget = false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
