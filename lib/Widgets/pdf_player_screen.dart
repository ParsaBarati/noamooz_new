import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';

class PdfPlayerScreen extends StatefulWidget {
  final String path;
  final String title;

  const PdfPlayerScreen({
    Key? key,
    required this.path,
    required this.title,
  }) : super(key: key);

  @override
  State<PdfPlayerScreen> createState() => _PdfPlayerScreenState();
}

class _PdfPlayerScreenState extends State<PdfPlayerScreen> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  final TextEditingController pageController = TextEditingController();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.white,
        elevation: 0,
        foregroundColor: ColorUtils.black,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: ColorUtils.white,
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: true,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,

            preventLinkNavigation: false,
            // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            pageController.text = currentPage.toString();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage! > 0)
                  FloatingActionButton.extended(
                    elevation: 0,
                    label: Text(
                      " صفحه ${currentPage! - 1}",
                      style: const TextStyle(
                        letterSpacing: 0,
                      ),
                    ),
                    onPressed: () async {
                      await snapshot.data!.setPage(currentPage! - 1);
                    },
                  ),
                SizedBox(
                  child: WidgetUtils.textField(
                      controller: pageController,
                      keyboardType: TextInputType.number,
                      onChanged: (res) {
                        int val = int.tryParse(res) ?? 0;
                        if (val > 0) {
                          snapshot.data!.setPage(val);
                        }
                      }),
                  width: 100,
                ),

                Row(
                  children: [
                    FloatingActionButton.extended(
                      elevation: 0,
                      label: Text(
                        " صفحه ${currentPage! + 1}",
                        style: const TextStyle(
                          letterSpacing: 0,
                        ),
                      ),
                      onPressed: () async {
                        await snapshot.data!.setPage(currentPage! + 1);
                      },
                    ),
                    const SizedBox(
                      width: 36,
                    ),
                  ],
                ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}
