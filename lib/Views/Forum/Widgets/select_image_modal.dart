import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Forum/single_forum_controller.dart';
import 'package:noamooz/Utils/color_utils.dart';
// import 'package:photo_manager/photo_manager.dart';

import '../../../Plugins/get/get.dart';

class AddPostModal extends StatefulWidget {
  final SingleForumController controller;
  final bool isBusiness;

  const AddPostModal({
    Key? key,
    required this.controller,
    required this.isBusiness,
  }) : super(key: key);

  @override
  State<AddPostModal> createState() => _AddPostModalState();
}

class _AddPostModalState extends State<AddPostModal> {
  final List<Widget> _mediaList = [];
  int currentPage = 0;
  int? lastPage;

  int marginBottom = 1000;

  @override
  void dispose() {
    widget.controller.cameraController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        marginBottom = 0;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          marginBottom = 75;
        });

        Future.delayed(const Duration(milliseconds: 150), () {
          setState(() {
            marginBottom = 0;
          });
          Future.delayed(const Duration(milliseconds: 100), () {
            setState(() {
              marginBottom = 50;
            });
            Future.delayed(const Duration(milliseconds: 100), () {
              setState(() {
                marginBottom = 0;
              });
            });
          });
        });
      });
    });
    if (widget.controller.cameras.isNotEmpty) {
      widget.controller.cameraController = CameraController(
        widget.controller.cameras[0],
        ResolutionPreset.low,
      );
      widget.controller.cameraController?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });
    }
    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    // final PermissionState ps = await PhotoManager.requestPermissionExtend();
    // if (ps.isAuth) {
    //   List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
    //     onlyAll: true,
    //   );
    //   widget.controller.media.addAll(await albums[0].getAssetListPaged(
    //     size: 60,
    //     page: currentPage,
    //   ));
    //   List<Widget> temp = [];
    //   for (var asset in widget.controller.media) {
    //     temp.add(
    //       FutureBuilder(
    //         future: asset.thumbnailDataWithSize(
    //           const ThumbnailSize(200, 200),
    //         ),
    //         builder:
    //             (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
    //           if (snapshot.connectionState == ConnectionState.done) {
    //             return Obx(
    //               () => GestureDetector(
    //                 onLongPress: () {
    //                   widget.controller.isMultipleSelect.value =
    //                       !widget.controller.isMultipleSelect.value;
    //                   if (widget.controller.isMultipleSelect.isTrue) {
    //                     widget.controller.currentItems.add(
    //                       widget.controller.media.indexOf(asset),
    //                     );
    //                   } else {
    //                     widget.controller.currentItems.clear();
    //                     ;
    //                   }
    //                 },
    //                 onTap: () {
    //                   if (widget.controller.isMultipleSelect.isTrue) {
    //                     if (widget.controller.currentItems.contains(
    //                       widget.controller.media.indexOf(asset),
    //                     )) {
    //                       widget.controller.currentItems.remove(
    //                         widget.controller.media.indexOf(asset),
    //                       );
    //                     } else {
    //                       widget.controller.currentItems.add(
    //                         widget.controller.media.indexOf(asset),
    //                       );
    //                     }
    //                     if (widget.controller.currentItems.isEmpty) {
    //                       widget.controller.isMultipleSelect.value = false;
    //                     }
    //                   } else {
    //                     widget.controller.currentIndex.value =
    //                         widget.controller.media.indexOf(asset);
    //                   }
    //                 },
    //                 child: Stack(
    //                   children: <Widget>[
    //                     Positioned.fill(
    //                       child: Image.memory(
    //                         snapshot.data!,
    //                         fit: BoxFit.cover,
    //                       ),
    //                     ),
    //                     if (asset.type == AssetType.video)
    //                       const Align(
    //                         alignment: Alignment.bottomRight,
    //                         child: Padding(
    //                           padding: EdgeInsets.only(right: 5, bottom: 5),
    //                           child: Icon(
    //                             Icons.videocam,
    //                             color: Colors.white,
    //                           ),
    //                         ),
    //                       ),
    //                     AnimatedSwitcher(
    //                       duration: const Duration(milliseconds: 150),
    //                       child: widget.controller.isMultipleSelect.isFalse &&
    //                               widget.controller.currentIndex.value ==
    //                                   widget.controller.media.indexOf(asset)
    //                           ? Align(
    //                               alignment: Alignment.center,
    //                               child: Container(
    //                                 decoration: BoxDecoration(
    //                                   color: Colors.white.withOpacity(0.2),
    //                                   borderRadius: BorderRadius.circular(10),
    //                                   border: Border.all(
    //                                     color: ColorUtils.blue,
    //                                     width: 3.5,
    //                                   ),
    //                                 ),
    //                                 width: 195,
    //                                 height: 195,
    //                               ),
    //                             )
    //                           : Container(),
    //                     ),
    //                     AnimatedSwitcher(
    //                       duration: const Duration(milliseconds: 150),
    //                       child: widget.controller.isMultipleSelect.isTrue
    //                           ? Align(
    //                               alignment: Alignment.topRight,
    //                               child: AnimatedContainer(
    //                                 margin: const EdgeInsets.all(8),
    //                                 padding: const EdgeInsets.all(8),
    //                                 duration: const Duration(milliseconds: 150),
    //                                 decoration: BoxDecoration(
    //                                   shape: BoxShape.circle,
    //                                   border: Border.all(
    //                                     color: Colors.white,
    //                                     width: 1,
    //                                   ),
    //                                   color: widget.controller.currentItems
    //                                           .contains(
    //                                     widget.controller.media.indexOf(asset),
    //                                   )
    //                                       ? Colors.blue
    //                                       : Colors.transparent,
    //                                 ),
    //                                 child: widget.controller.currentItems
    //                                         .contains(
    //                                   widget.controller.media.indexOf(asset),
    //                                 )
    //                                     ? Text(
    //                                         ((widget.controller.currentItems
    //                                                     .indexOf(widget
    //                                                         .controller.media
    //                                                         .indexOf(asset))) +
    //                                                 1)
    //                                             .toString(),
    //                                         style: const TextStyle(
    //                                           fontWeight: FontWeight.bold,
    //                                           fontSize: 10,
    //                                           color: Colors.white,
    //                                         ),
    //                                       )
    //                                     : const Text(''),
    //                               ),
    //                             )
    //                           : Container(),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           }
    //           return Container();
    //         },
    //       ),
    //     );
    //   }
    //   setState(() {
    //     _mediaList.addAll(temp);
    //     currentPage++;
    //   });
    // } else {
    //   PhotoManager.openSetting();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height / 1.35,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: ColorUtils.bgColor,
            appBar: AppBar(
              backgroundColor: ColorUtils.bgColor,
              toolbarHeight: 15,
              centerTitle: true,
              elevation: 1,
              shadowColor: ColorUtils.gray.withOpacity(0.3),
              title: Container(
                width: 50,
                height: 3,
                decoration: BoxDecoration(
                  color: ColorUtils.gray,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scroll) {
                  _handleScrollEvent(scroll);
                  return false;
                },
                child: Column(
                  children: [
                    if (widget.controller.cameraController != null) ...[
                      SizedBox(
                        height: Get.width / 3,
                        child: Row(
                          textDirection: TextDirection.ltr,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: widget.controller.cameraController!
                                          .value.isInitialized
                                      ? InkWell(
                                          onTap: () {
                                            Get.close(1);
                                            widget.controller
                                                .pickImage(ImageSource.camera);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: CameraPreview(
                                            widget.controller.cameraController!,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: ColorUtils.blue,
                                              size: 50,
                                            ),
                                          ),
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorUtils.gray.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () {
                                      Get.close(1);
                                      widget.controller
                                          .pickImage(ImageSource.gallery);
                                    },
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.photo_outlined,
                                            color: ColorUtils.blue,
                                            size: 40,
                                          ),
                                          Text(
                                            "ارسال از گالری",
                                            style: TextStyle(
                                              color: ColorUtils.blue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorUtils.gray.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () {
                                      Get.close(1);
                                      widget.controller.sendFile();
                                    },
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.attach_file,
                                            color: ColorUtils.blue,
                                            size: 40,
                                          ),
                                          Text(
                                            "ارسال فایل",
                                            style: TextStyle(
                                              color: ColorUtils.blue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: GridView.builder(
                        controller: widget.controller.scrollController,
                        itemCount: _mediaList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _mediaList[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            curve: Curves.bounceIn,
            right: 12,
            bottom: marginBottom.toDouble() + 12,
            child: FloatingActionButton(
              backgroundColor: ColorUtils.blue.shade200,
              onPressed: () {
                // Get.back(
                //     result: widget.controller.isMultipleSelect.isTrue
                //         ? widget.controller.currentItems
                //             .map(
                //               (element) => widget.controller.media[element],
                //             )
                //             .whereType<AssetEntity>()
                //             .toList()
                //         : [
                //             widget.controller
                //                 .media[widget.controller.currentIndex.value],
                //           ]);
              },
              child: Icon(
                Ionicons.send,
                color: ColorUtils.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
