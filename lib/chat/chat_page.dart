import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/login_page.dart';
import '../mypage/edit_my_page.dart';


class ChatPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              }
          ),
        ),
        title: Text('チャット'),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.yellow
              ),
              child: Text("アカウント&リンクメニュー"),
            ),
            ListTile(
              title: TextButton(
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
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_outlined,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('ログアウト'),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: TextButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) {
                          return EditMyPage();
                        }
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.manage_accounts,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('アカウント情報変更'),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('チャット'),
      ),
    );
  }
}