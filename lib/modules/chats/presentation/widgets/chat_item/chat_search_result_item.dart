import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';

class ChatSearchResultItem extends StatelessWidget {
  
  final String title;
  final String contentText;
  final String time;
  final String searchText;

  ChatSearchResultItem({
    @required this.title,
    @required this.contentText,
    @required this.time,
    @required this.searchText
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppFontStyles.headerMediumStyle,
                textAlign: TextAlign.left,
              ),
              Text(
                time,
                style: AppFontStyles.grey14w400,
                textAlign: TextAlign.right
              ),
            ],
          ),
          SizedBox(height: 8,),
          HighlightText(
            text: contentText,
            highlight: searchText,
            style: AppFontStyles.grey14w400,
            highlightColor: AppColors.accentBlueColor
          )
        ],
      ),
    );
  }
}


class HighlightText extends StatelessWidget {
  final String text;
  final String highlight;
  final TextStyle style;
  final Color highlightColor;
  final int maxLines;

  const HighlightText({
    Key key,
    this.text,
    this.highlight,
    this.style,
    this.highlightColor,
    this.maxLines
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = this.text ?? '';
    if ((highlight?.isEmpty ?? true) || text.isEmpty) {
      return Text(text, style: style);
    }

    List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;
    
    do {
      indexOfHighlight = text.indexOf(highlight, start);
      if (indexOfHighlight < 0) {
        
        // Показываем простой текст
        spans.add(_normalSpan(text.substring(start, text.length)));
        break;
      }
      if (indexOfHighlight == start) {
        // Начинается с highlighted
        spans.add(_highlightSpan(highlight));
        start += highlight.length;
      } else {
        // Начинается не с highlighted text 
        spans.add(_normalSpan(text.substring(start, indexOfHighlight)));
        spans.add(_highlightSpan(highlight));
        start = indexOfHighlight + highlight.length;
      }
    } while (true);

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
    );
  }

  TextSpan _highlightSpan(String content) {
    return TextSpan(text: content, style: style.copyWith(color: highlightColor));
  }

  TextSpan _normalSpan(String content) {
    return TextSpan(text: content, style: style);
  }
}
