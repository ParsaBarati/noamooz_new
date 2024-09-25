import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final String highlight;
  final TextStyle style;
  final TextStyle highlightStyle;
  Color? highlightColor;
  final bool ignoreCase;

  TextAlign textAlign = TextAlign.right;

  HighlightText({
    Key? key,
    required this.text,
    required this.highlight,
    required this.style,
    this.highlightColor,
    this.textAlign = TextAlign.center,
    TextStyle? highlightStyle,
    this.ignoreCase: false,
  })  : highlightStyle =
            highlightStyle ?? style.copyWith(color: highlightColor),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = this.text;
    if ((highlight.isEmpty) || text.isEmpty) {
      return Text(text, style: style);
    }

    var sourceText = ignoreCase ? text.toLowerCase() : text;
    var targetHighlight = ignoreCase ? highlight.toLowerCase() : highlight;

    List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;
    do {
      indexOfHighlight = sourceText.indexOf(targetHighlight, start);
      if (indexOfHighlight < 0) {
        // no highlight
        spans.add(_normalSpan(text.substring(start)));
        break;
      }
      if (indexOfHighlight > start) {
        // normal text before highlight
        spans.add(_normalSpan(text.substring(start, indexOfHighlight)));
      }
      start = indexOfHighlight + highlight.length;
      spans.add(_highlightSpan(text.substring(indexOfHighlight, start)));
    } while (true);

    return Text.rich(TextSpan(children: spans),textAlign: textAlign,);
  }

  TextSpan _highlightSpan(String content) {
    return TextSpan(text: content, style: highlightStyle);
  }

  TextSpan _normalSpan(String content) {
    return TextSpan(text: content, style: style);
  }
}
