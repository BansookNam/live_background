# Welcome to Live Background 👋

[![Version](https://img.shields.io/pub/v/live_background.svg?style=flat-square)](https://pub.dev/packages/live_background)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  Provide nice moving wall paper on your background.

## Install

Add nav dependency on your pubspec.yaml file

```yaml
live_background: ^{latest version}
```

## Show Case


https://user-images.githubusercontent.com/7719604/207383291-f35f2e01-a747-457e-883b-696da4c7e58b.mp4

https://user-images.githubusercontent.com/7719604/207383412-5c70a3be-9146-4136-b48b-9fe276938f34.mp4

https://user-images.githubusercontent.com/7719604/207383901-491692c5-52c8-4429-8c80-0f1380ede8d3.mp4

https://user-images.githubusercontent.com/7719604/207384180-10b8c128-e15a-492b-831a-b3b7025bad60.mp4

https://user-images.githubusercontent.com/7719604/207384463-5e63c237-8b0b-486f-bc3d-fe562d0119e8.mp4



## Usage

1. Add LiveBackgroundWidget() where you want

```dart
import 'package:live_background/live_background.dart';

Stack(children: [LiveBackgroundWidget(), AnyWidget()])
```

2. You can use initial values to change the effect

```dart
//for example
LiveBackgroundWidget(
   palette: Palette(colors: [Colors.red, Colors.green]),
   velocityX: 2.5,
   velocityY: 0,
   particleMinSize: 10,
   particleMaxSize: 30,
   particleCount: 250,
)
```

3. You can change values dynamically using LiveBackgroundController.

```dart
 final liveBackgroundController = LiveBackgroundController();

LiveBackgroundWidget(
  controller: liveBackgroundController,
  palette: _palette,
)

liveBackgroundController.setParticleCount(400);
liveBackgroundController.setVelocity(2.0, 10.5);
liveBackgroundController.setParticleSize(10, 30);
liveBackgroundController.setPalette(Palette(colors: [Colors.yellow, Colors.white]))
```


## Author

👤 **Bansook Nam**

* Website: https://github.com/bansooknam
* Github: [@bansooknam](https://github.com/bansooknam)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check [issues page](https://github.com/bansooknam/live_background/issues). You can also take a look at the [contributing guide](Contributions, issues and feature requests are welcome.).

## Show your support

Give a ⭐️ if this project helped you!

## 📝 License

Copyright © 2020 [Bansook Nam](https://github.com/bansooknam).

This project is [MIT](https://github.com/BansookNam/live_background/blob/master/LICENSE) licensed.

***

_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
