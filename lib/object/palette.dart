import 'dart:ui';

/// Holds a list of colors.
class Palette {
  /// The palette's color members. All unique.
  final List<Color>? colors;

  const Palette({this.colors});

  /// Creates a new palette from Hex String list.
  factory Palette.fromStringList(List<String> hexList) {
    var colors = hexList.map((c) => Color(int.tryParse(c)!)).toList();
    return Palette(colors: colors);
  }
}
