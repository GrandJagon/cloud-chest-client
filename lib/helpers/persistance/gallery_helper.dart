import 'dart:typed_data';

import 'package:cloud_chest/exceptions/cloud_chest_exceptions.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

// Provides method to store files in the gallery and convert them
class GalleryHelper {
  static GalleryHelper _singleton = new GalleryHelper._internal();

  factory GalleryHelper() {
    return _singleton;
  }

  GalleryHelper._internal();

  // Saves a picture into the local storage
  //Future<void> savePicture(String path) async {
  //  await GallerySaver.saveImage(path, albumName: 'cloudchest');
  //}

  Future<dynamic> savePicture(String path) async {
    dynamic result = await ImageGallerySaver.saveFile(path);

    print(result);

    if (result['isSucess'] == false)
      throw DlException('Could not download the file');

    return result['filePath'];
  }

  Future<dynamic> savePictureBytes(Uint8List bytes) async {
    dynamic result =
        await ImageGallerySaver.saveImage(bytes, isReturnImagePathOfIOS: true);

    if (result['isSucess'] == false)
      throw DlException('Could not download the file');

    return result['filePath'].toString().replaceAll('content://', '');
  }

  // Saves a video into the local storage
  Future<void> saveVideo(String path) async {
    await GallerySaver.saveVideo(path, albumName: 'cloudchest');
  }
}
