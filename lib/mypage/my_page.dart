import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/login/login_page.dart';
import 'edit_my_page.dart';
import 'my_model.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyModel>(
      create: (_) => MyModel()..fetchUser(),
      child: Scaffold(
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
          title: Text('マイページ'),
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
          child: Consumer<MyModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Column(
                  children: [
                    Text('名前',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(model.email ?? 'メールアドレスなし'),
                    Text('自己紹介'),
                    Text(model.name ?? '名前なし'),
                    Text(model.group ?? '所属班なし'),
                    TextButton(
                        onPressed: () async {
                          //ログアウト
                          await model.logout();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginPage();
                              },
                            ),
                          );
                        },
                        child: Text('ログアウト')
                    ),
                  ],
                ),
                if(model.isLoading)
                  Container(
                    color: Colors.black45,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}