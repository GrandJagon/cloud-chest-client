import 'dart:ffi';

class File {
  final String path;
  final int size;
  final String mimetype;
  final double? longitude;
  final double? latitude;
  final DateTime? creationDate;
  final DateTime? storageDate;
  final String? location;

  File(
      {required this.path,
      required this.size,
      required this.mimetype,
      this.longitude,
      this.latitude,
      this.creationDate,
      this.storageDate,
      this.location});

  Map toJson() => {
        'path': path,
        'size': size,
        'mimetype': mimetype,
        'longitude': longitude,
        'latitude': latitude,
        'creationDate': creationDate,
        'storageDate': storageDate,
        'location': location ?? ''
      };
}
