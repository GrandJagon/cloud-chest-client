import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../view_model/content_viewer_view_model.dart';

class ContentCarousel extends StatefulWidget {
  @override
  State<ContentCarousel> createState() => _ContentCarouselState();
}

class _ContentCarouselState extends State<ContentCarousel> {
  late ContentViewerViewModel contentViewerViewModel;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    contentViewerViewModel =
        Provider.of<ContentViewerViewModel>(context, listen: false);
    _pageController =
        PageController(initialPage: contentViewerViewModel.currentItemIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onPageChanged(int index) {
    if (_pageController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      contentViewerViewModel.nextItem();
    }
    if (_pageController.position.userScrollDirection ==
        ScrollDirection.forward) {
      contentViewerViewModel.previousItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _contentBuilder(contentViewerViewModel.currentItemIndex);
  }

  // Custom builder to build image corresponding to the content viewer provider state
  Widget _contentBuilder(int currentIndex) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: contentViewerViewModel.contentListSize,
      itemBuilder: (context, index) => CachedNetworkImage(
        fit: BoxFit.contain,
        placeholder: (context, url) => LoadingWidget(),
        imageUrl: contentViewerViewModel.contentList[index].path,
      ),
    );
  }
}
