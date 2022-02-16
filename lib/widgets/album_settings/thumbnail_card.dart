import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';

class ThumbnailCard extends StatefulWidget {
  late String imageUrl;

  ThumbnailCard(this.imageUrl);

  @override
  State<StatefulWidget> createState() => _ThumbnailCardState();
}

class _ThumbnailCardState extends State<ThumbnailCard> {
  // Fecthes a new image from url
  void fetchThumbnail(String newUrl) {
    setState(() {
      widget.imageUrl = newUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all()),
      child: CachedNetworkImage(
        placeholder: (context, url) => LoadingWidget(),
        imageUrl: widget.imageUrl,
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          color: Colors.red,
        ),
      ),
    );
  }
}
