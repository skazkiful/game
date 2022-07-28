import 'package:flutter/material.dart';

/// Popup button.
class PopupButton extends StatefulWidget {
  const PopupButton(this.text, this.onTap, {Key? key}) : super(key: key);

  /// Text of this button.
  final String text;

  /// Callback called when button was tapped.
  final VoidCallback onTap;

  @override
  State<PopupButton> createState() => _PopupButtonState();
}

/// [State] of [PopupButton].
class _PopupButtonState extends State<PopupButton> {
  /// Indicator whether button is hovered or not.
  bool buttonHovered = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => buttonHovered = true),
        onTapUp: (_) => setState(() => buttonHovered = false),
        onTapCancel: () => setState(() => buttonHovered = false),
        child: GestureDetector(
          onTap: widget.onTap.call,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            constraints: const BoxConstraints(
              maxHeight: 67.22,
              maxWidth: 307.56,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(61.67),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  colors: [Color(0xFFFFFFFF), Color(0xFF00FFC2)],
                ),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 9.25),
                      blurRadius: 6.17,
                      color: (buttonHovered)
                          ? const Color(0xFF00FFC2)
                          : Colors.black.withOpacity(0.55))
                ]),
            alignment: Alignment.center,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 64.7,
                maxWidth: 306.7,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(61.67),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5, 1.0],
                  colors: [
                    Color(0xFF59DA44),
                    Color(0xFF22944F),
                    Color(0xFF104438),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 39.47,
                  letterSpacing: 2,
                  fontFamily: 'Jura',
                ),
              ),
            ),
          ),
        ),
      );
}
