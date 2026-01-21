import 'package:flutter/material.dart';

class AnimatedWeatherBackground extends StatelessWidget {
  final String? weatherCondition;
  final int? weatherCode;  // Weather condition code from API
  final bool isNight;
  final Widget child;

  const AnimatedWeatherBackground({
    super.key,
    this.weatherCondition,
    this.weatherCode,
    this.isNight = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background (always visible as base)
        Positioned.fill(
          child: _buildGradientBackground(),
        ),
        
        // Animated particle overlay
        Positioned.fill(
          child: _buildAnimatedOverlay(),
        ),
        
        // Main content
        child,
      ],
    );
  }

  /// Build gradient background based on weather and time
  Widget _buildGradientBackground() {
    final colors = _getGradientColors();
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
    );
  }

  /// Build animated particle overlay
  Widget _buildAnimatedOverlay() {
    final condition = weatherCondition?.toLowerCase() ?? '';
    
    // Choose animation based on weather condition
    if (condition.contains('thunder') || condition.contains('storm')) {
      return const _ThunderAnimation();
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return const _RainAnimation();
    } else if (condition.contains('snow')) {
      return const _SnowAnimation();
    } else if (condition.contains('mist') || condition.contains('fog') || condition.contains('haze') || condition.contains('smoke') || condition.contains('dust')) {
      return const _MistAnimation();
    } else if (condition.contains('clear')) {
      return isNight ? const _StarsAnimation() : const _SunAnimation();
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return isNight ? const _StarsAnimation() : const _CloudAnimation();
    }
    
    // Default: subtle animation based on time
    return isNight ? const _StarsAnimation() : const _DefaultAnimation();
  }

  /// Get gradient colors based on weather condition and time of day
  List<Color> _getGradientColors() {
    final condition = weatherCondition?.toLowerCase() ?? '';
    
    // ============== NIGHT TIME GRADIENTS ==============
    if (isNight) {
      if (condition.contains('thunder') || condition.contains('storm')) {
        // Storm night - very dark
        return const [
          Color(0xFF0D1117),
          Color(0xFF161B22),
          Color(0xFF21262D),
        ];
      } else if (condition.contains('rain')) {
        // Rainy night
        return const [
          Color(0xFF1A202C),
          Color(0xFF2D3748),
          Color(0xFF3D4852),
        ];
      } else if (condition.contains('drizzle')) {
        // Drizzle night
        return const [
          Color(0xFF1A202C),
          Color(0xFF2D3748),
          Color(0xFF4A5568),
        ];
      } else if (condition.contains('snow')) {
        // Snowy night - slightly lighter
        return const [
          Color(0xFF2D3748),
          Color(0xFF4A5568),
          Color(0xFF718096),
        ];
      } else if (condition.contains('mist') || condition.contains('fog') || condition.contains('haze')) {
        // Misty night
        return const [
          Color(0xFF2D3748),
          Color(0xFF4A5568),
          Color(0xFF5A6A7A),
        ];
      } else if (condition.contains('clear')) {
        // Clear night - dark blue with stars vibe
        return const [
          Color(0xFF0D1B2A),
          Color(0xFF1B263B),
          Color(0xFF415A77),
        ];
      } else if (condition.contains('overcast')) {
        // Overcast night - dark gray clouds
        return const [
          Color(0xFF1A202C),
          Color(0xFF2D3748),
          Color(0xFF4A5568),
        ];
      } else if (condition.contains('cloud')) {
        // Cloudy night
        return const [
          Color(0xFF1A1A2E),
          Color(0xFF2D3748),
          Color(0xFF4A5568),
        ];
      }
      
      // Default night
      return const [
        Color(0xFF0D1B2A),
        Color(0xFF1B263B),
        Color(0xFF415A77),
      ];
    }
    
    // ============== DAY TIME GRADIENTS ==============
    
    if (condition.contains('thunder') || condition.contains('storm')) {
      // Storm day - dark and ominous
      return const [
        Color(0xFF455A64),
        Color(0xFF37474F),
        Color(0xFF263238),
      ];
    } else if (condition.contains('rain')) {
      // Rainy day
      return const [
        Color(0xFF546E7A),
        Color(0xFF455A64),
        Color(0xFF37474F),
      ];
    } else if (condition.contains('drizzle')) {
      // Drizzle day
      return const [
        Color(0xFF78909C),
        Color(0xFF607D8B),
        Color(0xFF546E7A),
      ];
    } else if (condition.contains('snow')) {
      // Snowy day - white/light gray
      return const [
        Color(0xFFECEFF1),
        Color(0xFFCFD8DC),
        Color(0xFFB0BEC5),
      ];
    } else if (condition.contains('mist') || condition.contains('fog') || condition.contains('haze') || condition.contains('smoke') || condition.contains('dust')) {
      // Misty/foggy day
      return const [
        Color(0xFFB0BEC5),
        Color(0xFF90A4AE),
        Color(0xFF78909C),
      ];
    } else if (condition.contains('clear')) {
      // Clear/sunny day - beautiful blue sky
      return const [
        Color(0xFF4FC3F7),
        Color(0xFF29B6F6),
        Color(0xFF03A9F4),
      ];
    } else if (condition.contains('overcast')) {
      // Overcast day - grayish blue
      return const [
        Color(0xFF78909C),
        Color(0xFF607D8B),
        Color(0xFF546E7A),
      ];
    } else if (condition.contains('few cloud') || condition.contains('scattered')) {
      // Light clouds - blue with slight haze
      return const [
        Color(0xFF81D4FA),
        Color(0xFF4FC3F7),
        Color(0xFF29B6F6),
      ];
    } else if (condition.contains('broken') || condition.contains('cloud')) {
      // More clouds
      return const [
        Color(0xFF90CAF9),
        Color(0xFF64B5F6),
        Color(0xFF42A5F5),
      ];
    }
    
    // Default clear day
    return const [
      Color(0xFF4FC3F7),
      Color(0xFF29B6F6),
      Color(0xFF03A9F4),
    ];
  }
}

/// Rain Animation - Falling droplets
class _RainAnimation extends StatefulWidget {
  const _RainAnimation();

  @override
  State<_RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<_RainAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _RainPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _RainPainter extends CustomPainter {
  final double progress;
  
  _RainPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final random = [0.1, 0.3, 0.5, 0.7, 0.9, 0.2, 0.4, 0.6, 0.8, 1.0];
    
    for (int i = 0; i < 50; i++) {
      final x = (size.width * random[i % 10]) + (i * 20) % size.width;
      final yOffset = ((progress + random[i % 10]) % 1.0) * size.height;
      final y = yOffset;
      
      canvas.drawLine(
        Offset(x, y),
        Offset(x - 5, y + 20),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RainPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Snow Animation - Falling snowflakes
class _SnowAnimation extends StatefulWidget {
  const _SnowAnimation();

  @override
  State<_SnowAnimation> createState() => _SnowAnimationState();
}

class _SnowAnimationState extends State<_SnowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _SnowPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _SnowPainter extends CustomPainter {
  final double progress;
  
  _SnowPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8);

    final random = [0.15, 0.35, 0.55, 0.75, 0.95, 0.25, 0.45, 0.65, 0.85, 0.05];
    
    for (int i = 0; i < 40; i++) {
      final x = (size.width * random[i % 10]) + (i * 25) % size.width;
      final yOffset = ((progress + random[(i + 3) % 10]) % 1.0) * size.height;
      final radius = 2.0 + (i % 4);
      
      // Add slight horizontal sway
      final sway = 10 * (progress * 2 * 3.14159).toDouble();
      final swayOffset = (sway % 1.0 - 0.5) * 20;
      
      canvas.drawCircle(
        Offset(x + swayOffset, yOffset),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SnowPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Cloud Animation - Moving clouds
class _CloudAnimation extends StatefulWidget {
  const _CloudAnimation();

  @override
  State<_CloudAnimation> createState() => _CloudAnimationState();
}

class _CloudAnimationState extends State<_CloudAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _CloudPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _CloudPainter extends CustomPainter {
  final double progress;
  
  _CloudPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4);

    // Draw a few clouds moving horizontally
    for (int i = 0; i < 4; i++) {
      final yPos = size.height * (0.1 + i * 0.2);
      final speed = 0.5 + i * 0.3;
      final xPos = ((progress * speed + i * 0.25) % 1.2 - 0.1) * size.width;
      
      _drawCloud(canvas, Offset(xPos, yPos), 40 + i * 10.0, paint);
    }
  }

  void _drawCloud(Canvas canvas, Offset center, double size, Paint paint) {
    // Simple cloud shape using circles
    canvas.drawCircle(center, size * 0.5, paint);
    canvas.drawCircle(Offset(center.dx - size * 0.4, center.dy + size * 0.1), size * 0.35, paint);
    canvas.drawCircle(Offset(center.dx + size * 0.4, center.dy + size * 0.1), size * 0.4, paint);
    canvas.drawCircle(Offset(center.dx + size * 0.2, center.dy - size * 0.2), size * 0.35, paint);
  }

  @override
  bool shouldRepaint(covariant _CloudPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Sun Animation - Rotating sun rays
class _SunAnimation extends StatefulWidget {
  const _SunAnimation();

  @override
  State<_SunAnimation> createState() => _SunAnimationState();
}

class _SunAnimationState extends State<_SunAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _SunPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _SunPainter extends CustomPainter {
  final double progress;
  
  _SunPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.8, size.height * 0.15);
    
    // Outer glow
    final glowPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(center, 60, glowPaint);
    
    // Sun body
    final sunPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.6);
    canvas.drawCircle(center, 35, sunPaint);
    
    // Rotating rays
    final rayPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.3)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 12; i++) {
      final angle = (progress * 2 * 3.14159) + (i * 3.14159 / 6);
      final innerRadius = 45.0;
      final outerRadius = 70.0;
      
      final startX = center.dx + innerRadius * (angle).toDouble().clamp(-1, 1);
      final startY = center.dy + innerRadius * (angle + 1.57).toDouble().clamp(-1, 1);
      final endX = center.dx + outerRadius * (angle).toDouble().clamp(-1, 1);
      final endY = center.dy + outerRadius * (angle + 1.57).toDouble().clamp(-1, 1);
      
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        rayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SunPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Stars Animation - Twinkling stars for night
class _StarsAnimation extends StatefulWidget {
  const _StarsAnimation();

  @override
  State<_StarsAnimation> createState() => _StarsAnimationState();
}

class _StarsAnimationState extends State<_StarsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarsPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _StarsPainter extends CustomPainter {
  final double progress;
  
  _StarsPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final positions = [
      Offset(0.1, 0.1), Offset(0.3, 0.05), Offset(0.5, 0.12),
      Offset(0.7, 0.08), Offset(0.9, 0.15), Offset(0.15, 0.25),
      Offset(0.4, 0.2), Offset(0.6, 0.18), Offset(0.85, 0.22),
      Offset(0.25, 0.35), Offset(0.55, 0.3), Offset(0.75, 0.32),
    ];
    
    for (int i = 0; i < positions.length; i++) {
      final twinkle = ((progress + i * 0.1) % 1.0);
      final opacity = 0.3 + twinkle * 0.7;
      final radius = 1.5 + twinkle * 1.5;
      
      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity);
      
      canvas.drawCircle(
        Offset(size.width * positions[i].dx, size.height * positions[i].dy),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Thunder Animation - Lightning flashes
class _ThunderAnimation extends StatefulWidget {
  const _ThunderAnimation();

  @override
  State<_ThunderAnimation> createState() => _ThunderAnimationState();
}

class _ThunderAnimationState extends State<_ThunderAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Flash effect at specific moments
        final flash = (_controller.value > 0.45 && _controller.value < 0.5) ||
                     (_controller.value > 0.52 && _controller.value < 0.54);
        
        return Container(
          color: flash ? Colors.white.withOpacity(0.3) : Colors.transparent,
        );
      },
    );
  }
}

/// Mist Animation - Floating fog
class _MistAnimation extends StatefulWidget {
  const _MistAnimation();

  @override
  State<_MistAnimation> createState() => _MistAnimationState();
}

class _MistAnimationState extends State<_MistAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _MistPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _MistPainter extends CustomPainter {
  final double progress;
  
  _MistPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 5; i++) {
      final yPos = size.height * (0.3 + i * 0.15);
      final xOffset = ((progress * (0.3 + i * 0.1) + i * 0.2) % 1.0 - 0.5) * 100;
      
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);
      
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width / 2 + xOffset, yPos),
          width: size.width * 1.5,
          height: 80,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MistPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Default subtle animation
class _DefaultAnimation extends StatelessWidget {
  const _DefaultAnimation();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
