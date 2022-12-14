import 'package:flutter/material.dart';
import 'package:live_background/object/particle_draw_type.dart';

class Particle {
  /// The particle's X-position.
  double x;

  /// The particle's Y-position.
  double y;

  /// The particle's opacity.
  double opacity;

  /// Speed vector (horizontally).
  double vx;

  /// Speed vector (vertically).
  double vy;

  /// The distance from canvas center.
  double dist;

  /// The distance from canvas center in percentage (0-1).
  double distFrac;

  /// The particle's size.
  double size;

  /// The life length of the particle (0-1).
  double life;

  /// The life remaining of the particle (0-1).
  double lifeLeft;

  /// If the particle is filled or only stroked.
  bool isFilled;

  /// If the particle should have "speed marks".
  bool? isFlowing;

  /// The color of the particle.
  Color color;

  /// The particle's distribution value.
  int distribution;

  ParticleDrawShape shape;

  Particle({
    this.x = 0,
    this.y = 0,
    this.opacity = 0,
    this.vx = 0,
    this.vy = 0,
    this.dist = 0,
    this.distFrac = 0,
    this.size = 0,
    this.life = 0,
    this.lifeLeft = 0,
    this.isFilled = false,
    this.isFlowing = false,
    this.color = Colors.black,
    this.distribution = 0,
    this.shape = ParticleDrawShape.circle,
  });
}
