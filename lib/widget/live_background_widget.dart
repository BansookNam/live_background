import 'dart:async';
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
  final double blurSigmaX;
  final double blurSigmaY;
  final bool clipBoundary;

  ///
  ///All Parameters are initial values. If you want to change the value after first build you should use controller.
  const LiveBackgroundWidget({
    Key? key,
    this.controller,
    this.palette,
    this.particleCount,
    this.velocityX,
    this.velocityY,
    this.particleMinSize,
    this.particleMaxSize,
    this.blurSigmaX = 2,
    this.blurSigmaY = 0,
    this.clipBoundary = true,
  }) : super(key: key);

  @override
  State<LiveBackgroundWidget> createState() => _LiveBackgroundWidgetState();
}

class _LiveBackgroundWidgetState extends State<LiveBackgroundWidget>
    with SingleTickerProviderStateMixin {
  BokehFx? _bokehFx;
  Ticker? _ticker;
  Palette _palette = const Palette(colors: [Colors.white, Colors.yellow]);
  Size size = const Size(0, 0);
  Orientation? orientation;

  @override
  void initState() {
    if (widget.palette != null) {
      _palette = widget.palette!;
    }
    _ticker = createTicker(_tick)..start();

    _initController();

    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) {
          _initSize(context);
          _initBgFx();
          setState(() {});
        }
      },
    );
    super.initState();
  }

  void _initController() {
    widget.controller?.setPalette = (palette) {
      _bokehFx?.setPalette(palette);
      setState(() {});
    };
    widget.controller?.setParticleCount = (count) {
      _bokehFx?.setParticleCount(count);
    };
    widget.controller?.setVelocity = (vx, vy) {
      _bokehFx?.setVelocity(vx, vy);
    };
    widget.controller?.setParticleSize = (vx, vy) {
      _bokehFx?.setParticleSize(vx, vy);
    };
  }

  void _tick(Duration duration) {
    _bokehFx?.tick(duration);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation changedOrientation) {
        if (orientation != null && orientation != changedOrientation) {
          //force rebuild because some slow device's paintSize reflect their size later
          _delay(() {
            setState(() {});
          });
        }
        orientation = changedOrientation;

        _initSize(context);
        return RepaintBoundary(
          child: Stack(
            children: [
              if (_bokehFx == null)
                Container()
              else if (widget.clipBoundary)
                ClipRect(
                  child: bokeh,
                )
              else
                bokeh
            ],
          ),
        );
      },
    );
  }

  void _initSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    if (box.hasSize) {
      final paintSize = Size(box.paintBounds.width, box.paintBounds.height);
      if (size != paintSize) {
        _bokehFx ??= BokehFx(
          size: Size(paintSize.width, paintSize.height),
        );

        size = paintSize;
        _bokehFx?.setSize(paintSize);
      }
    }
  }

  Widget get bokeh => Stack(
        children: <Widget>[
          CustomPaint(
            painter: ParticlePainter(
              fx: _bokehFx,
            ),
            child: Container(),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.blurSigmaX,
              sigmaY: widget.blurSigmaY,
            ),
            child: const Text(" "),
          ),
        ],
      );

  void _initBgFx() {
    final bgFx = _bokehFx;
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
      bgFx.setParticleSize(
          particleMinSize ?? 0, particleMaxSize ?? particleMinSize ?? 0);
    }

    if (velocityX != null || velocityY != null) {
      bgFx.setVelocity(velocityX ?? 0, velocityY ?? 0);
    }
  }

  void _delay(Function func, {int milliseconds = 300}) async {
    Timer(Duration(milliseconds: milliseconds), () {
      func();
    });
  }
}
