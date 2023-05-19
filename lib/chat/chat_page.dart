import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';
import 'package:recsseem_mobile/chat/chat_model.dart';
import 'package:recsseem_mobile/chat/chat_room_info.dart';
import 'package:recsseem_mobile/chat/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String adminId;
  final String adminName;
  const ChatPage({Key? key,
    required this.roomId,
    required this.roomName,
    required this.adminId,
    required this.adminName,
  }) : super(key:key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final user = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot>? chats;
  String? senderName;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getChats();
    getSender();
    super.initState();
  }

  getChats() {
    ChatPageModel().getChats(widget.roomId).then((val) {
      setState(() {
        chats = val;
      });
    });
  }

  getSender() {
    ChatPageModel().getSender().then((val) {
      setState(() {
        senderName = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            return ChatRoomInfo(roomId: widget.roomId, roomName: widget.roomName, adminId: widget.adminId, adminName: widget.adminName);
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
                        return  const Footer(pageNumber: 3);
                      })
              );
            },
          ),
        ),
        body: Stack(
              children: <Widget>[
                chatMessages(),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    color: Colors.grey[700],
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                              controller: messageController,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Send a message...',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                        ),
                        const SizedBox(width: 12,),
                        GestureDetector(
                          onTap: () {
                            sendMessage();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }


  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return MessageTile(
                  message: snapshot.data.docs[index]['message'],
                  senderId: snapshot.data.docs[index]['senderId'],
                  senderName: snapshot.data.docs[index]['senderName'],
                  sentByMe: user!.uid == snapshot.data.docs[index]['senderId']);
            },
          ) : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        'message': messageController.text,
        'senderId': user!.uid,
        'senderName': senderName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      ChatPageModel().sendMessageStore(widget.roomId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

}