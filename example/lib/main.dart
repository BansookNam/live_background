import 'package:example/widget/height.dart';
import 'package:example/widget/square_button.dart';
import 'package:flutter/material.dart';
import 'package:live_background/fx/base_fx.dart';
import 'package:live_background/live_background.dart';
import 'package:live_background/widget/live_background_widget.dart';
import 'package:nav/nav.dart';
import 'package:velocity_x/velocity_x.dart';

import 'dialog/edit_color_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Background Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showBackButton = false;
  final liveBackgroundController = LiveBackgroundController();
  Palette _palette = Palette(colors: [Colors.white, Colors.yellow]);
  double particleCount = 300;
  double vx = BaseFx.baseVelocity;
  double vy = BaseFx.baseVelocity;
  double particleMinSize = 10;
  double particleMaxSize = 50;
  bool hideSetting = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () async {
            if (hideSetting) {
              setState(() {
                hideSetting = false;
              });
            } else {
              await showEditColorDialog(context);
            }
          },
          child: Icon(hideSetting ? Icons.remove_red_eye : Icons.palette),
        ),
      ),
      body: Builder(
          builder: (context) => Stack(
                children: [
                  Container(
                    color: Colors.black,
                  ),
                  LiveBackgroundWidget(
                    controller: liveBackgroundController,
                    palette: _palette,
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: hideSetting ? Container() : settingWidget(),
                    ),
                  ),
                ],
              )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Container settingWidget() {
    return Container(
      color: Colors.black.withOpacity(0.0),
      child: Column(children: [
        Height(100),
        ("Particle Count: " + particleCount.toInt().toString()).text.size(25).white.make(),
        Slider(
            value: particleCount,
            max: 1500,
            min: 0,
            onChanged: ((value) {
              setState(() {
                particleCount = value;
                liveBackgroundController.setParticleCount(value.toInt());
              });
            })),
        Height(30),
        ("Particle velocity X: " + vx.toStringAsFixed(2)).text.size(25).white.make(),
        Slider(
            value: vx,
            max: 100,
            min: -100,
            onChanged: ((value) {
              setState(() {
                vx = value;
                liveBackgroundController.setVelocity(vx, vy);
              });
            })),
        Height(30),
        ("Particle velocity Y: " + vy.toStringAsFixed(2)).text.size(25).white.make(),
        Slider(
            value: vy,
            max: 100,
            min: -100,
            onChanged: ((value) {
              setState(() {
                vy = value;
                liveBackgroundController.setVelocity(vx, vy);
              });
            })),
        Height(30),
        ("Particle min size: " + particleMinSize.toStringAsFixed(2)).text.size(25).white.make(),
        Slider(
            value: particleMinSize,
            max: particleMaxSize,
            min: 1,
            onChanged: ((value) {
              setState(() {
                particleMinSize = value;
                liveBackgroundController.setParticleSize(particleMinSize, particleMaxSize);
              });
            })),
        Height(30),
        ("Particle max size: " + particleMaxSize.toStringAsFixed(2)).text.size(25).white.make(),
        Slider(
            value: particleMaxSize,
            max: 150,
            min: particleMinSize,
            onChanged: ((value) {
              setState(() {
                particleMaxSize = value;
                liveBackgroundController.setParticleSize(particleMinSize, particleMaxSize);
              });
            })),
        Height(30),
        SquareButton(
            text: "Hide Setting",
            onPressed: () {
              setState(() {
                hideSetting = true;
              });
            }),
        Height(300)
      ]),
    );
  }

  Future<void> showEditColorDialog(BuildContext context) async {
    final result = await EditColorListDialog(context, _palette.colors).show();
    if (Nav.isSuccess(result)) {
      _palette = Palette(colors: result[EditColorListDialog.data]);
      liveBackgroundController.setPalette(_palette);
    }
  }
}
