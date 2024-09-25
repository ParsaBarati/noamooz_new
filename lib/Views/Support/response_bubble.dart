import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Models/Support/ticket_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/logic_utils.dart';

class ResponseBubble extends StatelessWidget {
  final TicketModel ticket;
  const ResponseBubble({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: const EdgeInsets.fromLTRB(
        false ? 64.0 : 16.0,
        4,
        false ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: false ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    !false ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: false
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                            bottomLeft: Radius.circular(25.0),
                            topRight: Radius.circular(4),
                          )
                        : const BorderRadius.only(
                            topRight: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                            bottomLeft: Radius.circular(25.0),
                            topLeft: Radius.circular(4.0),
                          ),
                    child: Container(
                      // chat bubble decoration
                      decoration: BoxDecoration(
                        color: ColorUtils.gray.withOpacity(0.5)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ticket.text,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: !false
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          Text(
                            DateTime.fromMillisecondsSinceEpoch(
                              ticket.createdAt * 1000,
                            ).chatTime(),
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.2,
                              color: ColorUtils.textBlack.withOpacity(0.7),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
