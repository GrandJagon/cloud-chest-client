import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_chest/providers/content_viewer_provider.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentViewerScreen extends StatefulWidget {
  static final routeName = '/contentViewer';

  @override
  State<StatefulWidget> createState() => _ContentViewerScreenState();
}

class _ContentViewerScreenState extends State<ContentViewerScreen> {
  @override
  Widget build(BuildContext context) {
    print('Building viewer');

    final Size size = MediaQuery.of(context).size;

    final ContentViewerProvider contentViewerProvider =
        context.watch<ContentViewerProvider>();

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Center(
              child: Hero(
                tag: contentViewerProvider.currentItem.id,
                child: CachedNetworkImage(
                  placeholder: (ctx, url) => LoadingWidget(),
                  imageUrl: contentViewerProvider.currentItem.path,
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
                    onPressed: () => contentViewerProvider.previousItem(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_rounded,
                      size: 25,
                    ),
                    onPressed: () => contentViewerProvider.nextItem(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
