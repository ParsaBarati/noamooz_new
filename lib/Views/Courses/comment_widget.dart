import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Controllers/Courses/comment_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/logic_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final RxBool isPlaying = false.obs;
  final CommentController controller;

  CommentWidget({
    Key? key,
    required this.comment,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () => controller.reply(comment),
        onLongPress: () {
          if (comment.user?.id == Globals.userStream.user!.id) {
            controller.commentActions(comment);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  if (comment.user is User) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: Image.network(
                      comment.user!.image,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    comment.user!.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorUtils.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  ],
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(comment.date * 1000)
                        .timeAgo(),
                    style: TextStyle(
                      fontSize: 10,
                      color: ColorUtils.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              ViewUtils.sizedBox(72),
              Row(
                children: [
                  if (comment.voice.isNotEmpty) ...[
                    Obx(
                      () => WidgetUtils.smallSoftIcon(
                        icon: isPlaying.isTrue ? Icons.pause : Icons.play_arrow,
                        onTap: () async {
                          print(controller.player.state);
                          if (controller.player.state == PlayerState.playing || controller.player.state == PlayerState.completed) {
                            isPlaying.value = false;
                            await controller.player.stop();

                          } else {
                            await controller.player
                                .play(UrlSource(comment.voice));
                            isPlaying.value = true;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                  ],
                  Expanded(
                    child: Text(
                      comment.text,
                      style: TextStyle(
                        color: ColorUtils.black,
                        fontSize: 14,
                        letterSpacing: 1.4,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ),
                    Column(
                      children:
                          comment.replies.map((e) => buildComment(e)).toList(),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.mail_outline,
                    color: ColorUtils.textColor,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "پاسخ",
                    style: TextStyle(
                      color: ColorUtils.textColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildComment(Comment comment) {
    return CommentWidget(comment: comment, controller: controller);
  }
}
