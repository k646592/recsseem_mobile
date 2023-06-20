import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';
import 'individual_chat_model.dart';

class IndividualChatPage extends StatefulWidget {
  final String myId;
  final String partnerId;
  const IndividualChatPage({Key? key,
    required this.myId, required this.partnerId
  }) : super(key:key);

  @override
  State<IndividualChatPage> createState() => _IndividualChatPageState();
}

class ChatL10nJa extends ChatL10n {
  const ChatL10nJa({
    super.attachmentButtonAccessibilityLabel = '画像アップロード',
    super.emptyChatPlaceholder = 'メッセージがありません。',
    super.fileButtonAccessibilityLabel = 'ファイル',
    super.inputPlaceholder = 'メッセージを入力してください',
    super.sendButtonAccessibilityLabel = '送信', required super.unreadMessagesLabel,
  });
}

class _IndividualChatPageState extends State<IndividualChatPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IndividualChatPageModel>(
      create: (_) => IndividualChatPageModel(myId: widget.myId, partnerId: widget.partnerId)..fetchChatMessageList(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text('個人チャット'),
          backgroundColor: Colors.deepOrange,
          actions: [
            IconButton(
                onPressed: () async {

                },
                icon: const Icon(Icons.info)
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) {
                        return  const Footer(pageNumber: 2);
                      })
              );
            },
          ),
        ),
        body: Consumer<IndividualChatPageModel>(builder: (context, model, child) {
          final myUser = model.myUser;
          final messages = model.messages;
          return (myUser != null) ? Chat(
            user: myUser,
            messages: messages,
            onSendPressed: model.handleSendPressed,
            onAttachmentPressed: model.handleImageSelection,
            showUserAvatars: true,
            showUserNames: true,
            theme: const DefaultChatTheme(
              primaryColor: Colors.green,  // メッセージの背景色の変更
              userAvatarNameColors: [Colors.green],  // ユーザー名の文字色の変更
            ),
            l10n: const ChatL10nJa(unreadMessagesLabel: ''),
          ) : Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }),
      ),
    );
  }

}