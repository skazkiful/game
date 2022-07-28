import 'package:flutter/material.dart';

/// Home page button.
class HomePageButton extends StatelessWidget {
  const HomePageButton(
    this.text,
    this.onTap,
    this.isGreenButton, {
    Key? key,
  }) : super(key: key);

  /// Text of this button.
  final String text;

  /// Callback called when button was tapped.
  final VoidCallback onTap;

  /// Indicator whether button is green or not.
  final bool isGreenButton;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap.call,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          constraints: const BoxConstraints(
            maxHeight: 98.66,
            maxWidth: 307.77,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.1),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 1.0],
              colors: (isGreenButton)
                  ? const [Color(0xFFFFFFFF), Color(0xFF00FFC2)]
                  : const [Color(0xFFFFE600), Color(0xFFFFFFFF)],
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 97.75,
              maxWidth: 306.86,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.1),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: (isGreenButton)
                    ? const [0.0, 0.5, 1.0]
                    : const [0.0, 0.5, 0.55, 1.0],
                colors: (isGreenButton)
                    ? const [
                        Color(0xFF59DA44),
                        Color(0xFF22944F),
                        Color(0xFF104438)
                      ]
                    : const [
                        Color(0xFFFFC700),
                        Color(0xFFFF0B00),
                        Color(0xFFFF0000),
                        Color(0xFF570000),
                      ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 57.3,
                letterSpacing: 2,
                fontFamily: 'Jura',
              ),
            ),
          ),
        ),
      );
}
