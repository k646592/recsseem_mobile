import 'package:flutter/material.dart';

import 'custom_text_span.dart';

class TextWithUrl extends StatelessWidget {
  const TextWithUrl({
    required this.text,
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    /// URL検知の正規表現で、テキストがURLを含むか確認
    final urlRegExp = RegExp(
        r'((https?:www\.)|(https?://)|(www\.))[-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(/[-a-zA-Z0-9()@:%_+.~#?&/=]*)?');
    final urlMatches = urlRegExp.allMatches(text);

    /// URLが含まれていない場合はそのままのText, 含まれている場合はRichTextを返す
    if (urlMatches.isEmpty) {
      return SelectableText(
        text,
        style: const TextStyle(
          fontSize: 16,
        ),
      );
    } else {
      /// 返り値としてのTextSpanのリスト
      final textSpanList = <TextSpan>[];
      var remainingText = text;

      for (final regExpMatch in urlMatches) {
        final url = text.substring(regExpMatch.start, regExpMatch.end);
        final index = remainingText.indexOf(url);

        /// 文字列の初めがURLでない場合は通常のテキストとして生成し、文字列を分割
        if (index != 0) {
          textSpanList.add(
              CustomTextSpan.normalTextSpan(remainingText.substring(0, index)));
          remainingText = remainingText.substring(index);
        }

        /// URL文字列をハイパーリンクとして生成、文字列を分割して次のループに入る
        textSpanList.add(
            CustomTextSpan.urlTextSpan(remainingText.substring(0, url.length)));
        remainingText = remainingText.substring(url.length);
      }

      /// 文字列の最後がURLでない場合はremainingTextに残るので、通常のテキストとして生成
      if (remainingText.isNotEmpty) {
        textSpanList.add(CustomTextSpan.normalTextSpan(remainingText));
      }

      return SelectableText.rich(
        TextSpan(
          children: textSpanList,
        ),
      );
    }
  }
}