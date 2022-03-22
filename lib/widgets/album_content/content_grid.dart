import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/view_model/content_selection_view_model.dart';
import 'package:cloud_chest/view_model/current_album_view_model.dart';
import 'package:cloud_chest/widgets/album_content/content_item.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:cloud_chest/widgets/misc/network_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ContentGrid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentGridState();
}

class _ContentGridState extends State<ContentGrid> {
  late CurrentAlbumViewModel vm;

  // Clears previous user selection
  @override
  void initState() {
    super.initState();
    Provider.of<ContentSelectionViewModel>(context, listen: false)
        .clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    vm = context.watch<CurrentAlbumViewModel>();
    print('rebuilding grid');

    if (vm.response.status == ResponseStatus.LOADING_PARTIAL ||
        vm.response.status == ResponseStatus.LOADING_FULL)
      return LoadingWidget();
    if (vm.response.status == ResponseStatus.ERROR)
      return NetworkErrorWidget(
        retryCallback: () => vm.fetchSingleAlbum(vm.currentAlbumId),
        message: vm.response.message,
      );
    return _buildGrid(vm);
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
