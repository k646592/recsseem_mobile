import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/domain/chat_room.dart';
import '../chat/chat_page.dart';
import 'my_model.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fetchMyModel(),
      child: Scaffold(

        body: Center(
          child: Consumer<MyModel>(builder: (context, model, child) {


            final email = model.email;
            final name = model.name;
            final group = model.group;
            final grade = model.grade;
            final status = model.status;

            final List<Widget> widgets = model.chats.map(
                  (room) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.deepOrange,
                    child: Text(room.roomName.substring(0,1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(room.roomName),
                  subtitle: Text(room.admin[1]),
                  trailing: IconButton(
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context){
                          return ChatPage(roomId: room.id, roomName: room.roomName, adminId: room.admin[0], adminName: room.admin[1]);
                        }),
                      );
                    },
                    icon: const Icon(Icons.login_outlined),
                  ),
                ),
              ),
            ).toList();

              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.white
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 50,
                        backgroundImage: model.imgURL != null ? NetworkImage(model.imgURL!) : const NetworkImage('https://4thsight.xyz/wp-content/uploads/2020/02/1582801063-300x300.png'),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white
                      ),
                      padding: const EdgeInsets.all(1),
                      alignment: Alignment.center,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white
                      ),
                      padding: const EdgeInsets.all(1),
                      alignment: Alignment.center,
                      child: Text(
                        email,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white
                      ),
                      padding: const EdgeInsets.all(1),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: groupColor(group),
                              ),
                              child: Text(group),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: gradeColor(grade),
                              ),
                              child: Text(grade),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: statusColor(status),
                              ),
                              child: Text(status),
                            ),
                          ),
                        ],
                      ),
                    ),
                    chatRoomList(model.chats, widgets),
                  ],
              );
            }),
        ),
        ),
    );
  }

  Widget chatRoomList(List<ChatRoom> chatRooms, List<Widget> widgets){
    if(chatRooms.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
        ),
      );
    }
    else {
      return ListView(
        shrinkWrap: true,
        children: widgets,
      );
    }
  }

  Color groupColor(String group) {
    if(group=='Web班') {
      return Colors.cyan;
    } else if(group=='Network班') {
      return Colors.yellowAccent;
    } else if(group=='教員') {
      return Colors.pinkAccent;
    } else {
      return Colors.greenAccent;
    }
  }

  Color gradeColor(String grade) {
    if(grade=='B4') {
      return Colors.lightGreenAccent;
    } else if(grade=='M1') {
      return Colors.purple;
    } else if(grade=='M2') {
      return Colors.orange;
    } else if(grade=='教授') {
      return Colors.redAccent;
    } else {
      return Colors.teal;
    }
  }

  Color statusColor(String status) {
    if(status=='出席') {
      return Colors.green;
    } else if(status=='欠席') {
      return Colors.red;
    } else if(status=='未出席') {
      return Colors.blue;
    } else if(status=='帰宅') {
      return Colors.grey;
    } else {
      return Colors.yellow;
    }
  }

}