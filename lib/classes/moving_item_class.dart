import 'package:flutter/material.dart';
import 'dart:convert';

/// [MovingItem] class wraps information about moving items inside game.
class MovingItem {
  MovingItem({this.position = const Offset(0, 0), this.isEnemy = true});

  /// [MovingItem] current position.
  Offset position;

  /// [GlobalKey] of [MovingItem].
  GlobalKey key = GlobalKey();

  /// Indicator whether [MovingItem] is enemy or not.
  bool isEnemy;

  /// Returns [Widget] with image of [MovingItem].
  Widget display() => Image.asset(
        (isEnemy) ? 'assets/images/enemy.png' : 'assets/images/ruble.png',
        width: 50,
      );

  /// Returns [String] encoded from map of data about [MovingItem].
  String getString() => json.encode({
        'position': {'dx': position.dx, 'dy': position.dy},
        'isEnemy': isEnemy,
      });

  /// Returns [MovingItem] decoded from [String] of data about this class.
  MovingItem fromString(String data) {
    Map decoded = json.decode(data);
    position = Offset(decoded['position']['dx'], decoded['position']['dy']);
    isEnemy = decoded['isEnemy'];
    return this;
  }
}
