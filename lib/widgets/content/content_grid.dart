import 'package:cloud_chest/providers/content_provider.dart';
import 'package:cloud_chest/screens/content/content_viewer.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cloud_chest/widgets/misc/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'content_item.dart';

class ContentGrid extends StatefulWidget {
  final String _albumId;

  ContentGrid(this._albumId);

  @override
  State<StatefulWidget> createState() => _ContentGridState();
}

class _ContentGridState extends State<ContentGrid> {
  bool _isLoading = false;
  bool _isError = false;
  bool _isInit = false;
  List<String> selectedItems = [];

  // Request the album list of files from the API
  Future<void> _fetchContent(BuildContext context) async {
    if (!_isInit) {
      print('fetching content');
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<ContentProvider>(context, listen: false)
            .fetchAlbumContent(widget._albumId)
            .then((value) {
          setState(() {
            _isLoading = false;
            _isInit = true;
            _isError = false;
          });
        });
      } on Exception catch (err) {
        print(err);
        setState(() {
          _isInit = false;
          _isLoading = false;
          _isError = true;
        });
      }
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    _fetchContent(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final albumContent = Provider.of<ContentProvider>(context).contentList;

    if (_isLoading) return LoadingWidget();
    if (_isError)
      return NetworkErrorWidget(
        () => _fetchContent(context),
        'The server is not responding. Make sure it is up and running',
      );
    if (_isInit && !_isError)
      return Container(
        child: albumContent.length <= 0
            ? Center(
                child: Text('Your album is empty...',
                    style: TextStyle(fontSize: 20)),
              )
            : SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemCount: albumContent.length,
                  itemBuilder: (ctx, i) =>
                      ContentItem(albumContent[i], this.selectedItems),
                ),
              ),
      );
    else
      return Container();
  }
}
