import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recsseem_mobile/chat/chat_search_page.dart';
import 'package:url_launcher/link.dart';
import '../login/login_page.dart';
import '../mypage/edit_my_page.dart';
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
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) {
                            return const ChatSearchPage();
                          }
                      ),
                    );
                  }
              ),
            ),
          ],
          title: const Text('チャットルーム一覧'),
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0.0,
        ),
        drawer: Drawer(
          child: Consumer<ChatRoomListModel>(builder: (context, model, child) {
            return ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                      color: Colors.yellow
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Menu&MyAccount',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text('UserName：${model.name}'),
                      Text('Group：${model.group}'),
                      Text('Grade：${model.grade}'),
                      Text('Email：${model.email}'),
                      Text('出席状況：${model.status}'),
                    ],
                  ),
                ),
                ListTile(
                  title: TextButton.icon(
                    icon: const Icon(
                      Icons.logout_outlined,
                    ),
                    onPressed: () async {
                      try {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) {
                                return const LoginPage();
                              }
                          ),
                        );
                        const snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('ログアウトしました'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } catch (e) {
                        //失敗した場合
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    label: const Text('ログアウト'),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
                ListTile(
                  title: TextButton.icon(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return EditMyPage(name: model.name!, email: model.email!, group: model.group!, grade: model.grade!,);
                            }
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.manage_accounts,
                    ),
                    label: const Text('アカウント情報変更'),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
                ListTile(
                  title: Link(
                    // 開きたいWebページのURLを指定
                    uri: Uri.parse('https://p.al.kansai-u.ac.jp/'),
                    // targetについては後述
                    target: LinkTarget.self,
                    builder: (BuildContext ctx, FollowLink? openLink) {
                      return TextButton.icon(
                        onPressed: openLink,
                        label: const Text(
                          'Polemanage',
                        ),
                        icon: const Icon(Icons.poll),
                      );
                    },
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
                ListTile(
                  title: Link(
                    // 開きたいWebページのURLを指定
                    uri: Uri.parse('http://192.168.11.115:3000'),
                    // targetについては後述
                    target: LinkTarget.self,
                    builder: (BuildContext ctx, FollowLink? openLink) {
                      return TextButton.icon(
                        onPressed: openLink,
                        label: const Text(
                          '齋藤作 New bole (研究室内のみ)',
                        ),
                        icon: const Icon(Icons.library_books),
                      );
                    },
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
              ],
            );
          }),
        ),

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


