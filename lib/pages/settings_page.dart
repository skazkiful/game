import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/widgets/gradient_appbar.dart';

/// Settings page.
class SettingsPage extends StatefulWidget {
  const SettingsPage(this.prefs, {Key? key}) : super(key: key);

  /// [SharedPreferences] used to store and fetch some information.
  final SharedPreferences prefs;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// [State] of [SettingsPage].
class _SettingsPageState extends State<SettingsPage> {
  ///Indicator whether sound is enabled or not.
  bool soundEnabled = true;

  @override
  void initState() {
    if ((widget.prefs.getBool('soundEnabled') != null)) {
      soundEnabled = widget.prefs.getBool('soundEnabled')!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: const BoxDecoration(color: Color(0xFF0B3830)),
          child: Column(
            children: [
              GradientAppBar('settings', widget.prefs),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    MaterialButton(
                      onPressed: () => setState(() {
                        if (soundEnabled) {
                          soundEnabled = false;
                        } else {
                          soundEnabled = true;
                        }
                        widget.prefs.setBool('soundEnabled', soundEnabled);
                      }),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/sound_${(soundEnabled ? 'on' : 'off')}.png',
                              width: 65.08,
                              height: 65.08,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                'Turn sound ${(soundEnabled) ? 'off' : 'on'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 2,
                                  fontFamily: 'Jura',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
