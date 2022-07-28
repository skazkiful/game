import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/widgets/popup_widget.dart';
import '/classes/moving_item_class.dart';

/// Game page.
class GamePage extends StatefulWidget {
  const GamePage(this.prefs, {this.continueGame = false, Key? key})
      : super(key: key);

  /// [SharedPreferences] used to store and fetch some information.
  final SharedPreferences prefs;

  /// Indicator whether need continue game or start new.
  final bool continueGame;

  @override
  State<GamePage> createState() => _GamePageState();
}

/// [State] of [GamePage].
class _GamePageState extends State<GamePage> {
  /// Defines current position of player.
  double mouseDxPosition = 0;

  /// Indicator whether save was loaded or not.
  bool saveLoaded = false;

  /// Indicator whether game was paused or not.
  bool gamePaused = false;

  /// [GlobalKey] of player.
  GlobalKey player = GlobalKey();

  /// Defines opacity of [PopupWidget].
  double animatedOpacity = 0;

  /// Indicator where [PopupWidget] need to show or not.
  bool showAnimatedWidget = false;

  /// Defines amount of collected items.
  int collected = 0;

  /// [List] of [MovingItem] used in game.
  List<MovingItem> items = [];

  /// [List] of [MovingItem] need to remove from [items] list.
  List<MovingItem> toRemove = [];

  /// [Timer] adds new [MovingItem] to game.
  Timer? itemTimer;

  /// [Timer] make [MovingItem] in move.
  Timer? itemMovingTimer;

  /// [Duration] of [MovingItem] moving.
  Duration itemMovingDuration = const Duration(milliseconds: 25);

  @override
  void initState() {
    if (widget.continueGame) {
      loadSave();
    }
    if (widget.continueGame == false || saveLoaded == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
          mouseDxPosition = MediaQuery.of(context).size.width / 2 - 12.5);
    }
    startGame();

    super.initState();
  }

  @override
  void dispose() {
    itemTimer?.cancel();
    itemMovingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: WillPopScope(
          onWillPop: () async => false,
          child: GestureDetector(
            onPanUpdate: (pointer) {
              if (gamePaused != true) {
                setState(() => mouseDxPosition = pointer.localPosition.dx - 25);
              }
            },
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                for (MovingItem item in items)
                  AnimatedPositioned(
                    key: item.key,
                    duration: itemMovingDuration,
                    top: item.position.dy,
                    left: item.position.dx,
                    child: item.display(),
                  ),
                Positioned(
                  key: player,
                  left: mouseDxPosition,
                  top: MediaQuery.of(context).size.height - 50,
                  child: Image.asset('assets/images/gus_fly.png', width: 50),
                ),
                Positioned(
                    top: 50,
                    left: 20,
                    child: Text(
                      'Collected: $collected',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 2,
                        fontFamily: 'Jura',
                      ),
                    )),
                Positioned(
                    right: 20,
                    top: 50,
                    child: InkWell(
                      onTap: () => setState(() {
                        if (showAnimatedWidget == false) {
                          animatedOpacity = 1;
                          showAnimatedWidget = true;
                          toggleGame();
                        } else {
                          animatedOpacity = 0;
                        }
                      }),
                      child: Image.asset(
                        'assets/images/settings_button.png',
                        width: 50,
                        height: 50,
                      ),
                    )),
                AnimatedOpacity(
                  opacity: animatedOpacity,
                  duration: const Duration(milliseconds: 500),
                  child: (showAnimatedWidget)
                      ? Center(
                          child: PopupWidget(
                          widget.prefs,
                          onClosed: () => setState(() => animatedOpacity = 0),
                        ))
                      : null,
                  onEnd: () => setState(
                    () {
                      if (animatedOpacity == 1) {
                        showAnimatedWidget = true;
                      } else {
                        showAnimatedWidget = false;
                        toggleGame();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );

  /// Starts game.
  void startGame() {
    itemTimer = Timer.periodic(const Duration(milliseconds: 250), (a) {
      if (Random().nextInt(10) == 1) {
        items.add(MovingItem(
          position: Offset(
            Random()
                .nextInt((MediaQuery.of(context).size.width - 50).toInt())
                .toDouble(),
            -100,
          ),
          isEnemy: false,
        ));
      }
      if (Random().nextInt(5) == 1 &&
          items.where((e) => e.isEnemy).length < 20) {
        int countEnemiesToAdd = Random().nextInt(2) + 1;
        int added = 0;
        while (added < countEnemiesToAdd) {
          items.add(MovingItem(
              position: Offset(
            Random()
                .nextInt((MediaQuery.of(context).size.width - 50).toInt())
                .toDouble(),
            -100,
          )));
          added++;
        }
      }

      for (MovingItem enemy in items) {
        if (enemy.position.dy > MediaQuery.of(context).size.height) {
          toRemove.add(enemy);
        }
      }
      items.removeWhere((e) => toRemove.contains(e));
      saveGame();
      setState(() {});
    });

    itemMovingTimer = Timer.periodic(itemMovingDuration, (a) {
      for (MovingItem enemy in items) {
        enemy.position = Offset(enemy.position.dx, enemy.position.dy + 5);
      }

      for (MovingItem item in items) {
        if (item.key.currentContext != null) {
          RenderBox box1 =
              item.key.currentContext!.findRenderObject() as RenderBox;
          RenderBox box2 =
              player.currentContext!.findRenderObject() as RenderBox;

          if (box1.hasSize) {
            final size1 = box1.size;
            final size2 = box2.size;

            final position1 = box1.localToGlobal(Offset.zero);
            final position2 = box2.localToGlobal(Offset.zero);

            final collide = (position1.dx < position2.dx + size2.width &&
                position1.dx + size1.width > position2.dx &&
                position1.dy < position2.dy + size2.height &&
                position1.dy + size1.height > position2.dy);

            if (collide) {
              if (item.isEnemy) {
                deleteSave();
                itemTimer?.cancel();
                itemMovingTimer?.cancel();
                List<String>? history = widget.prefs.getStringList('history');
                if (history == null) {
                  widget.prefs.setStringList('history', [collected.toString()]);
                } else {
                  history.insert(0, collected.toString());
                  widget.prefs.setStringList('history', history);
                }
              } else {
                toRemove.add(item);
                collected++;
              }
            }
          }
        }
      }

      items.removeWhere((e) => toRemove.contains(e));
      setState(() {});
    });
  }

  /// Toggle game to paused or active.
  void toggleGame() {
    if (gamePaused) {
      startGame();
      gamePaused = false;
    } else {
      itemTimer?.cancel();
      itemMovingTimer?.cancel();
      gamePaused = true;
    }
    setState(() {});
  }

  /// Save game to [widget.prefs].
  void saveGame() async {
    List<String> list = [];
    for (MovingItem item in items) {
      list.add(item.getString());
    }
    await widget.prefs.setStringList('saved', list);
    await widget.prefs.setInt('savedCollected', collected);
    await widget.prefs.setDouble('savedMouseDxPosition', mouseDxPosition);
  }

  /// Load save from [widget.prefs].
  void loadSave() {
    if (widget.prefs.getInt('savedCollected') != null) {
      collected = widget.prefs.getInt('savedCollected')!;
      saveLoaded = true;
    }
    if (widget.prefs.getDouble('savedMouseDxPosition') != null) {
      mouseDxPosition = widget.prefs.getDouble('savedMouseDxPosition')!;
    }
    List<String>? list = widget.prefs.getStringList('saved');
    if (list != null && list.isNotEmpty) {
      for (String data in list) {
        items.add(MovingItem().fromString(data));
      }
    }
  }

  /// Delete save from [widget.prefs].
  void deleteSave() {
    widget.prefs.remove('savedMouseDxPosition');
    widget.prefs.remove('savedCollected');
    widget.prefs.remove('saved');
  }
}
