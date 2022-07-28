import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/pages/history_page.dart';
import '/pages/settings_page.dart';
import '/pages/game_page.dart';

/// Gradient appbar.
class GradientAppBar extends StatefulWidget {
  const GradientAppBar(this.title, this.prefs, {Key? key}) : super(key: key);

  /// Title of appbar.
  final String title;

  /// [SharedPreferences] used to store and fetch some information.
  final SharedPreferences prefs;

  @override
  State<GradientAppBar> createState() => _GradientAppBarState();
}

/// [State] of [GradientAppBar].
class _GradientAppBarState extends State<GradientAppBar> {
  /// Indicator whether need to show full menu or not.
  bool showMenu = false;

  /// [TextStyle] of menu items.
  static const TextStyle textStyle = TextStyle(
    color: Colors.white,
    fontSize: 36,
    letterSpacing: 2,
    fontFamily: 'Jura',
  );

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + 90 + ((showMenu) ? 200 : 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF22944F), Color(0xFF196C6C)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          (!showMenu)
              ? Positioned(
                  width: MediaQuery.of(context).size.width,
                  top: 20,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(widget.title, style: textStyle),
                  ),
                )
              : Positioned(
                  width: MediaQuery.of(context).size.width,
                  top: (showMenu) ? 70 : 20,
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _menuButton('new game', () {
                          if (widget.title == 'game') {
                            showMenu = false;
                            setState(() {});
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GamePage(widget.prefs),
                                ));
                          }
                        }),
                        _menuButton('continue', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GamePage(
                                  widget.prefs,
                                  continueGame: true,
                                ),
                              ));
                        }),
                        _menuButton('history', () {
                          if (widget.title == 'history') {
                            showMenu = false;
                            setState(() {});
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HistoryPage(widget.prefs)));
                          }
                        }),
                        _menuButton('settings', () {
                          if (widget.title == 'settings') {
                            showMenu = false;
                            setState(() {});
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SettingsPage(widget.prefs)));
                          }
                        }),
                      ],
                    ),
                  ),
                ),
          Positioned(
            top: 15,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: MaterialButton(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(
                    'assets/images/icon_menu.png',
                    height: 32,
                    width: 46.4,
                  ),
                ),
                onPressed: () => setState(
                  () => (showMenu) ? showMenu = false : showMenu = true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Menu button.
  _menuButton(String title, VoidCallback onTap) => ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: MaterialButton(
          padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
          onPressed: onTap.call,
          child: Text(title, style: textStyle),
        ),
      );
}
