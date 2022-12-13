import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../object/particle.dart';
import '../utils/rnd.dart';
import 'base_fx.dart';

class BokehFx extends BaseFx {
  BokehFx({required Size size})
      : super(
          size: size,
          numParticles: 320,
        );

  @override
  void tick(Duration duration) {
    const vecSpeedRatio = 0.1;
    for (var p in particles) {
      if (p == null) {
        continue;
      }
      p.y -= p.vy * vecSpeedRatio;
      p.x -= p.vx * vecSpeedRatio;

      if (p.y > height || p.y < 0 || p.life == 0) {
        _activateParticle(p);
      }
      if (p.x > width || p.x < 0 || p.life == 0) {
        _activateParticle(p);
      }
    }

    super.tick(duration);
  }

  void _activateParticle(Particle p) {
    p.x = Rnd.getDouble(0, width);
    p.y = Rnd.getDouble(0, height);
    p.opacity =
        Rnd.ratio > .95 ? Rnd.getDouble(.6, .8) : Rnd.getDouble(.08, .4);
    p.isFilled = true;
    p.size = Rnd.getDouble(particleMinSize, particleMaxSize);
    p.life = 1;
    p.vx = vx;
    p.vy = vy;
  }
}
