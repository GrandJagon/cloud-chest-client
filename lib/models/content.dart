import 'dart:ffi';

// Abstract class that holds the different types of content
abstract class Content {
  final Uri path;
  final int size;
  final String mimetype;
  final Map<String, dynamic>? metadata;

  Content(
      {required this.path,
      required this.size,
      required this.mimetype,
      this.metadata});

  Map<String, dynamic> toJson() => {
        'path': path,
        'size': size,
        'mimetype': mimetype,
        'metada': metadata ?? {}
      };
}
