import 'dart:ui';

/// Holds a list of colors.
class Palette {
  /// The palette's color members. All unique.
  List<Color>? colors;

  Palette({this.colors});

  /// Creates a new palette from Hex String list.
  factory Palette.fromStringList(List<String> hexList) {
    var colors = hexList.map((c) => Color(int.tryParse(c)!)).toList();
    return Palette(colors: colors);
  }
}
