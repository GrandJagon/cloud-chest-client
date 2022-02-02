import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_chest/providers/content_viewer_provider.dart';
import 'package:cloud_chest/widgets/content_viewer/content_viewer_bar.dart';
import 'package:cloud_chest/widgets/content_viewer/metadata_pane.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
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
    final ContentViewerProvider contentViewerProvider =
        context.watch<ContentViewerProvider>();

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
                Expanded(
                  child: Container(),
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Hero(
                      tag: contentViewerProvider.currentItem.id,
                      child: CachedNetworkImage(
                        placeholder: (ctx, url) => LoadingWidget(),
                        imageUrl: contentViewerProvider.currentItem.path,
                        fit: BoxFit.fill,
                      ),
                    ),
                    MetadataPane(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
