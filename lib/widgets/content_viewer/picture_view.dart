import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_chest/view_model/auth/auth_view_model.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import '../../models/content/content.dart';

class PictureView extends StatelessWidget {
  final Content content;

  PictureView(this.content);

  @override
  Widget build(BuildContext context) {
    return content.isLocal()
        ? Image.file(
            File(content.localPath!),
            fit: BoxFit.contain,
          )
        : CachedNetworkImage(
            fit: BoxFit.contain,
            httpHeaders: {'auth-token': Auth().accessToken!},
            placeholder: (ctx, url) => LoadingWidget(),
            imageUrl: content.path,
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
  }
}
