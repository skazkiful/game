import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/pages/game_page.dart';
import '/pages/history_page.dart';
import '/pages/settings_page.dart';
import 'gradient_text_with_shadow.dart';
import 'popup_button.dart';

/// Popup widget.
class PopupWidget extends StatelessWidget {
  const PopupWidget(this.prefs, {this.onClosed, Key? key}) : super(key: key);

  /// [SharedPreferences] used to store and fetch some information.
  final SharedPreferences prefs;

  /// Callback called when popup widget was closed.
  final VoidCallback? onClosed;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        constraints: const BoxConstraints(maxHeight: 629.75, maxWidth: 307.77),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            colors: [Color(0xFF00FFC2), Color(0xFFFFFFFF)],
          ),
        ),
        padding: const EdgeInsets.all(1),
        child: Container(
          constraints:
              const BoxConstraints(maxHeight: 627.75, maxWidth: 305.77),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              colors: [Color(0xFF09513F), Color(0xFF50B441)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onClosed?.call,
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const GradientTextWithShadow(
                      'GAME',
                      LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, 1],
                        colors: [Color(0xFFFFE600), Color(0xFF00FFC2)],
                      ),
                      TextStyle(
                        fontSize: 64,
                        letterSpacing: 2,
                        fontFamily: 'Jura',
                      ),
                    ),
                    PopupButton(
                        'new game',
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GamePage(prefs)))),
                    PopupButton(
                        'continue',
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GamePage(
                                      prefs,
                                      continueGame: true,
                                    )))),
                    PopupButton(
                        'history',
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryPage(prefs)))),
                    PopupButton(
                        'settings',
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage(prefs)))),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
