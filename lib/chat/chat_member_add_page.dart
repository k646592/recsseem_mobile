import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/chat/chat_room_info.dart';

import 'chat_member_add_model.dart';

class ChatMemberAddPage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String adminId;
  final String adminName;
  const ChatMemberAddPage({Key? key, required this.roomId, required this.roomName, required this.adminId, required this.adminName}) : super(key: key);

  @override
  State<ChatMemberAddPage> createState() => _ChatMemberAddPage();

}

class _ChatMemberAddPage extends State<ChatMemberAddPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatMemberAddModel>(
      create: (_) => ChatMemberAddModel()..fetchChatMemberAdd(widget.roomId),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.clear, color: Colors.red,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Consumer<ChatMemberAddModel>(builder: (context, model, child) {
              return Center(
                child: ElevatedButton(
                  onPressed: () async {
                    model.startLoading();
                    try {
                      await model.addMember(widget.roomId);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return ChatRoomInfo(roomId: widget.roomId, roomName: widget.roomName, adminId: widget.adminId, adminName: widget.adminName);
                            }
                        ),
                      );

                      final snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('新しいメンバーを追加しました'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } catch (e) {
                      //失敗した場合

                      final snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } finally {
                      model.endLoading();
                    }
                  },
                  child: Text("追加"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              );
            }),
          ],
          title: const Text('メンバー追加'),
        ),
        body: Scrollbar(
          child: Consumer<ChatMemberAddModel>(builder: (context, model, child) {
            return ListView.builder(
              itemCount: model.memberList.length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: model.memberList[index].imgURL != null ? NetworkImage(model.memberList[index].imgURL) : const NetworkImage('https://4thsight.xyz/wp-content/uploads/2020/02/1582801063-300x300.png'),
                      ),
                      title: Text(model.memberList[index].name),
                      subtitle: Text(model.memberList[index].group),
                      trailing: Checkbox(
                        value: model.memberList[index].join,
                        onChanged: (bool? val) {
                          model.itemChange(val!, index, model.memberList);
                        },
                      ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}