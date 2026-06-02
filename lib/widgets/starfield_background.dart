import 'dart:math';
import 'package:flutter/material.dart';

class Star {
  double x;
  double y;
  double size;
  double opacity;
  double speed; // for twinkling

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
  });
}

class StarfieldPainter extends CustomPainter {
  final List<Star> stars;
  final Color starColor;
  final double animationValue;

  StarfieldPainter({
    required this.stars,
    required this.starColor,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle = (sin(animationValue * star.speed * pi * 2) + 1) / 2;
      final opacity = (star.opacity * 0.5 + twinkle * star.opacity * 0.5).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = starColor.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );

      // Glow for larger stars
      if (star.size > 1.5) {
        final glowPaint = Paint()
          ..color = starColor.withOpacity(opacity * 0.3)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(
          Offset(star.x * size.width, star.y * size.height),
          star.size * 2,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(StarfieldPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class StarfieldBackground extends StatefulWidget {
  final Widget child;
  final List<Color> gradientColors;
  final bool showStars;
  final int starCount;

  const StarfieldBackground({
    super.key,
    required this.child,
    required this.gradientColors,
    this.showStars = true,
    this.starCount = 120,
  });

  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _stars = List.generate(widget.starCount, (i) => Star(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 2.0 + 0.4,
      opacity: _random.nextDouble() * 0.6 + 0.3,
      speed: _random.nextDouble() * 1.5 + 0.5,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            ),
          ),
        ),
        // Stars layer
        if (widget.showStars)
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => CustomPaint(
              painter: StarfieldPainter(
                stars: _stars,
                starColor: Colors.white,
                animationValue: _controller.value,
              ),
              size: Size.infinite,
            ),
          ),
        // Content
        widget.child,
      ],
    );
  }
}
