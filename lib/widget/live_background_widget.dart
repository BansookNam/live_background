import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:live_background/object/particle_shape_type.dart';
import 'package:live_background/widget/prevent_recursive_call.dart';

import '../fx/particle_painter.dart';
import '../live_background.dart';

class LiveBackgroundController {
  late Function(Palette palette) setPalette;
  late Function(int count) setCount;
  late Function(double vx, double vy) setVelocity;
  late Function(double vx, double vy) setSize;
  late Function(ParticleShapeType) setShape;
  late Function() reset;
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
  final bool fixSize;
  final ParticleShapeType shape;

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
    this.fixSize = false,
    this.shape = ParticleShapeType.circle,
  }) : super(key: key);

  @override
  State<LiveBackgroundWidget> createState() => _LiveBackgroundWidgetState();
}

class _LiveBackgroundWidgetState extends State<LiveBackgroundWidget>
    with SingleTickerProviderStateMixin, PreventRecursiveCall {
  BokehFx? _bokehFx;
  Ticker? _ticker;
  Palette _palette = const Palette(colors: [Colors.white, Colors.yellow]);
  Size size = const Size(0, 0);
  Orientation? orientation;
  bool isNeedReset = false;
  ParticleShapeType shape = ParticleShapeType.circle;

  @override
  void initState() {
    _palette = widget.palette ?? _palette;
    shape = widget.shape;
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
    widget.controller?.setCount = (count) {
      _bokehFx?.setParticleCount(count);
    };
    widget.controller?.setVelocity = (vx, vy) {
      _bokehFx?.setVelocity(vx, vy);
    };
    widget.controller?.setSize = (vx, vy) {
      _bokehFx?.setParticleSize(vx, vy);
    };
    widget.controller?.setShape = (shape) {
      _bokehFx?.setShape(shape);
    };
    widget.controller?.reset = () {
      setState(() {
        isNeedReset = true;
      });
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
    if (widget.controller == null) {
      _initBgFx();
    }
    return OrientationBuilder(
      builder: (BuildContext context, Orientation changedOrientation) {
        if (orientation != null && orientation != changedOrientation) {
          //force rebuild because some slow device's paintSize reflect their size later
          _callDelayedSetState();
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
                  child: _bokeh,
                )
              else
                _bokeh
            ],
          ),
        );
      },
    );
  }

  void _initSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    if (box.hasSize &&
        (size == const Size(0, 0) || !widget.fixSize || isNeedReset)) {
      final paintSize = Size(box.paintBounds.width, box.paintBounds.height);
      if (paintSize == const Size(0, 0)) {
        recursiveCallCount++;
        if (isRecursiveCountSafe) {
          _callDelayedSetState();
        }
      } else if (size != paintSize || isNeedReset) {
        if (_bokehFx == null || isNeedReset) {
          _bokehFx = BokehFx(
            size: Size(paintSize.width, paintSize.height),
            shape: shape,
          );
          _initBgFx();
          isNeedReset = false;
        }
        size = paintSize;
        _bokehFx?.setSize(paintSize);
      }
    }
  }

  Widget get _bokeh => Stack(
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
    final palette = widget.palette ?? _palette;
    final shape = widget.shape;
    if (bgFx == null) {
      return;
    }
    bgFx.setShape(shape);

    bgFx.setPalette(palette);

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

  void _emptyCall() {}

  void _callDelayedSetState() {
    _delay(() {
      setState(_emptyCall);
    });
  }

  void _delay(Function func) async {
    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) {
          func();
        }
      },
    );
  }
}
