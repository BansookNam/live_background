import 'dart:math';

import 'package:flutter/material.dart';

import '../object/palette.dart';
import '../object/particle.dart';
import '../utils/rnd.dart';

abstract class BaseFx with ChangeNotifier {
  static const double baseVelocity = 3.0;
  static const double baseParticleMinSize = 10;
  static const double baseParticleMaxSize = 50;

  /// The available canvas width for the FX.
  late double width;

  /// The available canvas height for the FX.
  late double height;

  /// The minimum value of [width] and [height].
  late double sizeMin;

  /// The center of the canvas.
  late Offset center;

  /// The area from wich to spawn new particles.
  late Rect spawnArea;

  /// The colors used for painting.
  Palette? palette;

  /// All the FX's particles.
  late List<Particle?> particles;

  /// The maximum number of particles.
  int numParticles;

  /// Velocity of particle
  double vx = baseVelocity;
  double vy = baseVelocity;

  /// Size of particle
  double particleMinSize = baseParticleMinSize;
  double particleMaxSize = baseParticleMaxSize;

  BaseFx({
    required Size size,
    this.numParticles = 5000,
  }) {
    palette = Palette(colors: [Colors.transparent]);
    particles = List<Particle?>.filled(numParticles, null);
    setSize(size);
  }

  /// Initializes the particle effect by resetting all the particles and assigning a random color from the palette.
  void init() {
    if (palette == null) return;
    for (int i = 0; i < numParticles; i++) {
      var color = Rnd.getItem(palette!.colors!);
      particles[i] = Particle(color: color);
      resetParticle(i);
    }
  }

  void setParticleCount(int count) {
    numParticles = count;
    particles = List<Particle?>.filled(numParticles, null);
    init();
  }

  void setVelocity(double vx, double vy) {
    this.vx = vx;
    this.vy = vy;
    particles = List<Particle?>.filled(numParticles, null);
    init();
  }

  void setParticleSize(double min, double max) {
    particleMinSize = min;
    particleMaxSize = max;
    particles = List<Particle?>.filled(numParticles, null);
    init();
  }

  /// Sets the palette used for coloring.
  void setPalette(Palette palette) {
    this.palette = palette;
    particles
        .where((p) => p != null)
        .forEach((p) => p!.color = Rnd.getItem(palette.colors!));
  }

  /// Sets the canvas size and updates dependent values.
  void setSize(Size size) {
    width = size.width;
    height = size.height;
    sizeMin = min(width, height);
    center = Offset(width / 2, height / 2);
    spawnArea = Rect.fromLTRB(
      center.dx - sizeMin / 100,
      center.dy - sizeMin / 100,
      center.dx + sizeMin / 100,
      center.dy + sizeMin / 100,
    );
    init();
  }

  /// Resets a particle's values.
  Particle resetParticle(int i) {
    Particle p = particles[i]!;
    p.size = p.opacity = p.vx = p.vy = p.life = p.lifeLeft = 0;
    p.x = center.dx;
    p.y = center.dy;
    return p;
  }

  void tick(Duration duration) {
    notifyListeners();
  }
}
