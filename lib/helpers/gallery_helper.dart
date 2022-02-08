import 'package:gallery_saver/gallery_saver.dart';

// Provides method to store files in the gallery and convert them
class GalleryHelper {
  static GalleryHelper _singleton = new GalleryHelper._internal();

  factory GalleryHelper() {
    return _singleton;
  }

  GalleryHelper._internal();

  // Saves a picture into the local storage
  Future<void> savePicture(String path) async {
    await GallerySaver.saveImage(path, albumName: 'Cloud chest downloads');
  }

  // Saves a video into the local storage
  Future<void> saveVideo(String path) async {
    await GallerySaver.saveVideo(path, albumName: 'Cloud chest downloads');
  }
}
