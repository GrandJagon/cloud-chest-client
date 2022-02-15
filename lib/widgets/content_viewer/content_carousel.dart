import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_chest/providers/content_viewer_provider.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ContentCarousel extends StatefulWidget {
  @override
  State<ContentCarousel> createState() => _ContentCarouselState();
}

class _ContentCarouselState extends State<ContentCarousel> {
  late ContentViewerProvider contentViewerProvider;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    contentViewerProvider =
        Provider.of<ContentViewerProvider>(context, listen: false);
    _pageController =
        PageController(initialPage: contentViewerProvider.currentItemIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onPageChanged(int index) {
    if (_pageController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      contentViewerProvider.nextItem();
    }
    if (_pageController.position.userScrollDirection ==
        ScrollDirection.forward) {
      contentViewerProvider.previousItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _contentBuilder(contentViewerProvider.currentItemIndex);
  }

  // Custom builder to build image corresponding to the content viewer provider state
  Widget _contentBuilder(int currentIndex) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: contentViewerProvider.contentListSize,
      itemBuilder: (context, index) => CachedNetworkImage(
        fit: BoxFit.contain,
        placeholder: (context, url) => LoadingWidget(),
        imageUrl: contentViewerProvider.contentList[index].path,
      ),
    );
  }
}
