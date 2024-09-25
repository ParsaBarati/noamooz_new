import 'package:flutter/material.dart';
import 'package:noamooz/Models/Blog/post_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class BlogController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  List<PostModel> posts = [];
  List<PostModel> mostVisits = [];
  List<PostModel> latestPosts = [];
  List<PostModel> videoCastPosts = [];
  List<PostModel> podcastPosts = [];
  int page = 0;

  final PageController mostVisitsController = PageController();
  final PageController latestPostsController = PageController(viewportFraction: 0.4);
  final PageController videoCastController = PageController(viewportFraction: 0.4);
  final PageController podcastController = PageController(viewportFraction: 0.4);


  void fetchPosts() async {
    isLoading.value = true;
    ApiResult apiResult = await RequestsUtil.instance.blog.posts(page);
    if (apiResult.isDone) {
      posts = PostModel.listFromJson(apiResult.data);
      mostVisits = PostModel.listFromJson(apiResult.data);
      latestPosts = PostModel.listFromJson(apiResult.data);
      videoCastPosts = PostModel.listFromJson(apiResult.data);
      podcastPosts = PostModel.listFromJson(apiResult.data);
    }
    isLoading.value = false;
  }

  void fetchMorePosts() async {
    page++;
    isMoreLoading.value = true;
    ApiResult apiResult = await RequestsUtil.instance.blog.posts(page);
    if (apiResult.isDone) {
      posts.addAll(PostModel.listFromJson(apiResult.data));
    }
    isMoreLoading.value = true;
  }

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }
}
