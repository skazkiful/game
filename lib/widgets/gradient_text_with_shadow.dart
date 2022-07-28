import 'package:flutter/material.dart';

/// Gradient text with shadow.
class GradientTextWithShadow extends StatelessWidget {
  const GradientTextWithShadow(
    this.text,
    this.gradient,
    this.style, {
    Key? key,
  }) : super(key: key);

  /// Text that will be displayed.
  final String text;

  /// [TextStyle] of text.
  final TextStyle style;

  /// [Gradient] of text.
  final Gradient gradient;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Text(text,
              style: style.copyWith(
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.45),
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              )),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => gradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: Text(text, style: style),
          ),
        ],
      );
}
