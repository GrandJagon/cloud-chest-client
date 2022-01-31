// Abstract class that holds the different types of content
abstract class Content {
  final String id;
  final String path;
  final int size;
  final String mimetype;
  final Map<String, dynamic>? metadata;

  Content(
      {required this.id,
      required this.path,
      required this.size,
      required this.mimetype,
      this.metadata});

  Map<String, dynamic> toJson() => {
        'id': id,
        'path': path,
        'size': size,
        'mimetype': mimetype,
        'metada': metadata ?? {}
      };

  // Sending only the relevant information for the server to delete the content
  Map<String, dynamic> toJsonForDeletion() {
    // Convert the absolute path to a relative path in order for the server to locate the files
    final startIndex = path.indexOf('storage');
    final relativePath = path.substring(startIndex, path.length);

    print(relativePath);

    return {'id': id, 'path': relativePath};
  }
}
