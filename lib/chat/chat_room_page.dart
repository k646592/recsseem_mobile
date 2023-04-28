import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_room_page.dart';
import 'chat_page.dart';
import 'chat_room_model.dart';

class ChatRoomListPage extends StatefulWidget {
  const ChatRoomListPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomListPage> createState() => _ChatRoomListPage();
}

class _ChatRoomListPage extends State<ChatRoomListPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatRoomListModel>(
      create: (_) => ChatRoomListModel()..fetchChatRoomList(),
      child: Scaffold(
        body: SingleChildScrollView(
            child: Consumer<ChatRoomListModel>(builder: (context, model, child){

              final List<Widget> widgets = model.chatRooms.map(
                    (room) => Card(
                      child: ListTile(
                        title: Text(room.roomName,),
                        subtitle: Text(room.admin[1]),
                        trailing: IconButton(
                          icon: const Icon(Icons.input),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) {
                                    return ChatPage(roomId: room.id, roomName: room.roomName, adminId: room.admin[0], adminName: room.admin[1],);
                                  })
                            );
                          },
                        ),
                      ),
                    ),
              ).toList();

              if(model.chatRooms.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }
              else {
                return ListView(
                  shrinkWrap: true,
                  children: widgets,
                );
              }

            })
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) {
                    return const AddRoomPage();
                  }),
            );
          },
        ),
      ),
    );
  }
}


