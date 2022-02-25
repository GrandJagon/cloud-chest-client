import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/view_model/user_selection_view_model.dart';
import 'package:cloud_chest/view_model/current_album_view_model.dart';
import 'package:cloud_chest/widgets/album_content/content_item.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cloud_chest/widgets/misc/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentGrid extends StatefulWidget {
  final String _albumId;

  ContentGrid(this._albumId);

  @override
  State<StatefulWidget> createState() => _ContentGridState();
}

class _ContentGridState extends State<ContentGrid> {
  // Clears user selection and fetches album content
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        Provider.of<UserSelectionViewModel>(context, listen: false)
            .clearSelection();
        Provider.of<CurrentAlbumViewModel>(context, listen: false)
            .fetchSingleAlbum(widget._albumId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final CurrentAlbumViewModel currentAlbumViewModel =
        context.watch<CurrentAlbumViewModel>();

    if (currentAlbumViewModel.response.status == ResponseStatus.LOADING)
      return LoadingWidget();
    if (currentAlbumViewModel.response.status == ResponseStatus.ERROR)
      return NetworkErrorWidget(
        () => currentAlbumViewModel.fetchSingleAlbum(widget._albumId),
        currentAlbumViewModel.response.message,
      );
    return _buildGrid(currentAlbumViewModel);
  }

  // Returns the grid if album is not empty
  Widget _buildGrid(CurrentAlbumViewModel viewModel) {
    return Container(
      child: viewModel.contentList.length <= 0
          ? Center(
              child: Text('Your album is empty...',
                  style: TextStyle(fontSize: 20)),
            )
          : GridView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemCount: viewModel.contentList.length,
              itemBuilder: (ctx, i) => ContentItem(
                viewModel.contentList[i],
                i,
                UniqueKey(),
              ),
            ),
    );
  }
}
