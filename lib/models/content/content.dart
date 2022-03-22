// Abstract class that holds the different types of content
import 'package:flutter/cupertino.dart';

abstract class Content implements Listenable {
  final String id;
  bool _local = false;
  String path;
  String? localPath;
  final String storageDate;
  final int size;
  final String mimetype;
  bool _isSelected = false;
  bool _isDownloading = false;
  List<Function> _listeners = [];

  bool isSelected() => _isSelected;

  bool isDownloading() => _isDownloading;

  bool isLocal() => _local;

  Content(
      {required this.id,
      required this.path,
      required this.storageDate,
      required this.size,
      required this.mimetype});

  Map<String, dynamic> toJson() => {
        'id': id,
        'path': path,
        'storageDate': storageDate,
        'size': size,
        'mimetype': mimetype
      };

  // Sending only the relevant information for the server to delete the content
  Map<String, dynamic> toJsonForDeletion() {
    // Convert the absolute path to a relative path in order for the server to locate the files
    final startIndex = path.indexOf('storage');
    final relativePath = path.substring(startIndex, path.length);

    return {'id': id, 'path': relativePath};
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void cancelSubscription() {
    _listeners.clear();
  }

  // Listeners are individual content items
  void notifyListeners() {
    try {
      for (Function l in _listeners) {
        l.call();
      }
    } catch (e, stack) {
      print(stack);
      print(e);
    }
  }

  void setLocal(bool state) {
    _local = state;
  }

  void setSelected(bool state) {
    _isSelected = state;
    notifyListeners();
  }

  void toggleSelected() {
    _isSelected = !_isSelected;
    notifyListeners();
  }

  void toggleDownloading() {
    _isDownloading = !_isDownloading;
    notifyListeners();
  }

  void clearState() {
    _isDownloading = false;
    _isSelected = false;
    notifyListeners();
  }
}
