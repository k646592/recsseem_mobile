import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import '../login/login_page.dart';
import '../mypage/edit_my_page.dart';
import 'package:provider/provider.dart';

import 'add_room_page.dart';
import 'chat_message.dart';
import 'chat_model.dart';



class ChatRoomListPage extends StatefulWidget {
  ChatRoomListPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomListPage> createState() => _ChatRoomListPage();
}

class _ChatRoomListPage extends State<ChatRoomListPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                //Navigator.of(context).pop();
              }
          ),
        ),
        title: Text('チャット'),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: Drawer(
        child: Consumer<ChatRoomListModel>(builder: (context, model, child) {
          return ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.yellow
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Menu&MyAccount',
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
                  icon: Icon(
                    Icons.logout_outlined,
                  ),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return LoginPage();
                            }
                        ),
                      );
                      final snackBar = SnackBar(
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
                  label: Text('ログアウト'),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
                title: TextButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) {
                            return EditMyPage();
                          }
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.manage_accounts,
                  ),
                  label: Text('アカウント情報変更'),
                ),
              ),
              Divider(
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
                      icon: Icon(Icons.poll),
                    );
                  },
                ),
              ),
              Divider(
                color: Colors.black,
              ),
            ],
          );
        }),
      ),
      body: Column(
          children: [

          ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) {
                  return AddRoomPage();
                }
            ),
          );
        },
      ),
    );
  }
}


