import 'package:flutter/material.dart';
import 'package:live_background/object/particle_draw_type.dart';

import 'base_fx.dart';

class ParticlePainter extends CustomPainter {
  BaseFx? fx;

  // ChangeNotifier used as repaint notifier.
  ParticlePainter({required this.fx}) : super(repaint: fx);

  @override
  void paint(Canvas canvas, Size size) {
    final particles = fx?.particles;
    if (particles == null) {
      return;
    }
    for (var p in particles) {
      if (p == null) {
        continue;
      }
      var pos = Offset(p.x, p.y);

      var paint = Paint()
        ..color = p.color.withAlpha((255 * p.opacity).floor())
        ..strokeWidth = p.size * .1
        ..style = p.isFilled ? PaintingStyle.fill : PaintingStyle.stroke;
      switch (p.shape) {
        case ParticleDrawShape.circle:
          canvas.drawCircle(pos, p.size / 1.2, paint);
          break;
        case ParticleDrawShape.square:
          canvas.drawRect(
              Rect.fromLTRB(pos.dx, pos.dy, pos.dx + p.size, pos.dy + p.size),
              paint);
      }
    }
  }

  @override
  bool shouldRepaint(oldDelegate) => false;
}
