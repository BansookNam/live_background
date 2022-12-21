import 'package:live_background/object/particle_draw_type.dart';
import 'package:live_background/utils/rnd.dart';

enum ParticleShapeType {
  circle,
  square,
  random;

  ParticleDrawShape get drawType {
    switch (this) {
      case ParticleShapeType.circle:
        return ParticleDrawShape.circle;
      case ParticleShapeType.square:
        return ParticleDrawShape.square;
      case ParticleShapeType.random:
        return Rnd.getBool()
            ? ParticleDrawShape.circle
            : ParticleDrawShape.square;
    }
  }
}
