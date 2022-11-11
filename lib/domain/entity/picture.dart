import 'dart:typed_data';

class Picture {
  final String title;
  final Uint8List picture;

  Picture({required this.title, required this.picture});

  factory Picture.fromJson({required Map json}) {
    return Picture(
      title: json['title'],
      picture: json['picture'],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "picture": picture,
      };
}
