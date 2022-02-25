import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/view_model/content_viewer_view_model.dart';
import 'package:cloud_chest/view_model/current_album_view_model.dart';
import 'package:cloud_chest/widgets/content_viewer/content_carousel.dart';
import 'package:cloud_chest/widgets/content_viewer/content_viewer_bar.dart';
import 'package:cloud_chest/widgets/content_viewer/metadata_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ContentViewerScreen extends StatefulWidget {
  static final routeName = '/contentViewer';

  @override
  State<StatefulWidget> createState() => _ContentViewerScreenState();
}

class _ContentViewerScreenState extends State<ContentViewerScreen> {
  @override
  Widget build(BuildContext context) {
    final ContentViewerViewModel contentViewerProvider =
        context.read<ContentViewerViewModel>();

    final ApiResponse deleteResponse =
        context.watch<CurrentAlbumViewModel>().response;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ContentViewerBar(),
                Container(),
                // ADD HERO HERE
                Expanded(
                  child: ContentCarousel(),
                ),
                MetadataPane(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
