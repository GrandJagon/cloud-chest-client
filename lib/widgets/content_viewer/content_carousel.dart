import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_chest/models/content/content.dart';
import 'package:cloud_chest/models/content/picture.dart';
import 'package:cloud_chest/widgets/content_viewer/picture_view.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../view_model/content/content_viewer_view_model.dart';

class ContentCarousel extends StatefulWidget {
  @override
  State<ContentCarousel> createState() => _ContentCarouselState();
}

class _ContentCarouselState extends State<ContentCarousel> {
  late ContentViewerViewModel vm;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    vm = Provider.of<ContentViewerViewModel>(context, listen: false);
    _pageController = PageController(initialPage: vm.currentItemIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onPageChanged(int index) {
    if (_pageController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      vm.nextItem();
    }
    if (_pageController.position.userScrollDirection ==
        ScrollDirection.forward) {
      vm.previousItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _contentBuilder(vm.currentItemIndex);
  }

  // Custom builder to build image corresponding to the content viewer provider state
  Widget _contentBuilder(int currentIndex) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: vm.contentListSize,
      itemBuilder: (context, index) => _buildContent(index),
    );
  }

  // Given if the content is stored locally or on server builds the image
  Widget _buildContent(int index) {
    Content content = vm.contentList[index];
    if (content is Picture)
      return PictureView(content);
    else {
      return Container();
    }
  }
}
