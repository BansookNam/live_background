import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../fx/particle_painter.dart';
import '../live_background.dart';

class LiveBackgroundController {
  late Function(Palette palette) setPalette;
  late Function(int count) setParticleCount;
  late Function(double vx, double vy) setVelocity;
  late Function(double vx, double vy) setParticleSize;
}

class LiveBackgroundWidget extends StatefulWidget {
  final LiveBackgroundController? controller;
  final Palette? palette;
  final int? particleCount;
  final double? velocityX;
  final double? velocityY;
  final double? particleMinSize;
  final double? particleMaxSize;

  ///
  ///All Parameters are initial values. If you want to change the value after first build you should use controller.
  const LiveBackgroundWidget(
      {Key? key,
      this.controller,
      this.palette,
      this.particleCount,
      this.velocityX,
      this.velocityY,
      this.particleMinSize,
      this.particleMaxSize})
      : super(key: key);

  @override
  State<LiveBackgroundWidget> createState() => _LiveBackgroundWidgetState();
}

class _LiveBackgroundWidgetState extends State<LiveBackgroundWidget> with SingleTickerProviderStateMixin {
  BokehFx? _bgFx;
  Ticker? _ticker;
  Palette _palette = Palette(colors: [Colors.white, Colors.yellow]);

  @override
  void initState() {
    if (widget.palette != null) {
      _palette = widget.palette!;
    }
    _ticker = createTicker(_tick)..start();

    initController();

    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) {
          final size = MediaQuery.of(context).size;
          _bgFx = BokehFx(
            size: Size(size.width, size.height),
          );
          initBgFx();
          setState(() {});
        }
      },
    );
    super.initState();
  }

  void initController() {
    widget.controller?.setPalette = (palette) {
      _bgFx!.setPalette(palette);
      setState(() {});
    };
    widget.controller?.setParticleCount = (count) {
      _bgFx!.setParticleCount(count);
    };
    widget.controller?.setVelocity = (vx, vy) {
      _bgFx!.setVelocity(vx, vy);
    };
    widget.controller?.setParticleSize = (vx, vy) {
      _bgFx!.setParticleSize(vx, vy);
    };
  }

  void _tick(Duration duration) {
    _bgFx?.tick(duration);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _bgFx == null
          ? Container()
          : Stack(
              children: <Widget>[
                CustomPaint(
                  painter: ParticlePainter(
                    fx: _bgFx,
                  ),
                  child: Container(),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2,
                    sigmaY: 0,
                  ),
                  // filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: const Text(" "),
                ),
              ],
            ),
    );
  }

  void initBgFx() {
    final bgFx = _bgFx;
    final particleCount = widget.particleCount;
    final velocityX = widget.velocityX;
    final velocityY = widget.velocityY;
    final particleMinSize = widget.particleMinSize;
    final particleMaxSize = widget.particleMaxSize;
    if (bgFx == null) {
      return;
    }
    bgFx.setPalette(_palette);

    if (particleCount != null) {
      bgFx.setParticleCount(particleCount);
    }

    if (particleMinSize != null || particleMaxSize != null) {
      bgFx.setParticleSize(particleMinSize ?? 0, particleMaxSize ?? particleMinSize ?? 0);
    }

    if (velocityX != null || velocityY != null) {
      bgFx.setVelocity(velocityX ?? 0, velocityY ?? 0);
    }
  }
}
