import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_chest/models/content/content.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import '../../../view_model/auth/auth_view_model.dart';

class PictureThumbnail extends StatelessWidget {
  final Content content;

  PictureThumbnail(this.content);

  @override
  Widget build(BuildContext context) {
    try {
      return CachedNetworkImage(
        fit: BoxFit.cover,
        httpHeaders: {'auth-token': Auth().accessToken!},
        placeholder: (ctx, url) => LoadingWidget(),
        imageUrl: content.path,
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    } catch (err, stack) {
      print(stack);
      print(err);
      return Container();
    }
  }
}
