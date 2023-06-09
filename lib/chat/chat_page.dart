import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';
import 'package:recsseem_mobile/chat/chat_model.dart';
import 'package:recsseem_mobile/chat/chat_room_info.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String adminId;
  final String adminName;
  final String imgURL;
  const ChatPage({Key? key,
    required this.roomId,
    required this.roomName,
    required this.adminId,
    required this.adminName,
    required this.imgURL,
  }) : super(key:key);

  @override
  State<ChatPage> createState() => _ChatPageState();
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

class _ChatPageState extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatPageModel>(
      create: (_) => ChatPageModel(roomId: widget.roomId)..fetchChatMessageList(),
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(widget.roomName),
            backgroundColor: Colors.deepOrange,
            actions: [
              IconButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return ChatRoomInfo(roomId: widget.roomId, roomName: widget.roomName, adminId: widget.adminId, adminName: widget.adminName, imgURL: widget.imgURL,);
                            })
                    );
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
        body: Consumer<ChatPageModel>(builder: (context, model, child) {
          final myUser = model.myUser;
          final messages = model.messages;
          return (myUser != null) ? Chat(
            user: myUser,
            messages: messages,
            onSendPressed: model.handleSendPressed,
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