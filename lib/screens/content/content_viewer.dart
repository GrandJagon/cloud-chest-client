import 'package:cloud_chest/models/content.dart';
import 'package:cloud_chest/providers/content_provider.dart';
import 'package:cloud_chest/widgets/content/content_viewer_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentViewer extends StatefulWidget {
  static final routeName = '/contentViewer';

  @override
  State<StatefulWidget> createState() => _ContentViewerState();
}

class _ContentViewerState extends State<ContentViewer> {
  bool _metadata = false;
  bool _isInit = false;
  var _currentIndex;
  late int _albumSize;

  @override
  void didChangeDependencies() {
    if (!_isInit) _currentIndex = ModalRoute.of(context)!.settings.arguments;
    super.didChangeDependencies();
  }

  // Displays a metadata panel on the bottom
  void _toggleMetadata() {
    setState(() {
      _metadata = !_metadata;
    });
  }

  // Displays the previous content
  void _goBack() {
    setState(() {
      _currentIndex = _currentIndex - 1;
      if (_currentIndex < 0) _currentIndex = _albumSize - 1;
    });
  }

  // Displays the next content
  void _goNext() {
    setState(() {
      _currentIndex = _currentIndex + 1;
      if (_currentIndex >= _albumSize) _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _albumContent =
        Provider.of<ContentProvider>(context, listen: false).contentList;

    _albumSize = _albumContent.length;

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: ContentViewerBar(_toggleMetadata),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: _currentIndex,
              child: Image.network(
                _albumContent[_currentIndex].path,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
              width: double.infinity,
              height: size.height * 0.1,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 25,
                    ),
                    onPressed: () => _goBack(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_rounded,
                      size: 25,
                    ),
                    onPressed: () => _goNext(),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
