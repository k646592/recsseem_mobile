/*
Stack(
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
 */


/*
DateFormat outputDate = DateFormat('yyyy年MM月dd日(EEE) a hh:mm');
final List<Memo> memo = model.memoList;
            memo.sort(((a, b) => b.date.compareTo(a.date)));

            final List<Widget> widgets = memo.map(
              (memo) => Slidable(
                actionPane: const SlidableDrawerActionPane(),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '編集',
                    color: Colors.grey[350],
                    icon: Icons.edit,
                    onTap: () async {
                      final String? title = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditMemoPage(memo),
                        ),
                      );
                      if (title != null) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('『$title』を編集しました'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                      model.fetchMemoList();
                    },
                  ),
                  IconSlideAction(
                    caption: '削除',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () async {
                      // 削除しますか？って聞いて、はいだったら削除
                      await showConfirmDialog(context, memo, model);
                    },
                  ),
                ],
                child: ListTile(
                  title: Text('${memo.title}　${memo.team}'),
                  subtitle: Text('${outputDate.format(memo.date)}    製作者名 ${memo.name}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.login_outlined),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainTextPage(memo)),
                      );
                      model.fetchMemoList();
                    },
                  ),
                ),
              ),
            ).toList();
 */

/*
List<Memo> pageMemoList = memoList.getRange(_selectedIndex*10, _selectedIndex*10 + 10).toList();

    if(memoList.length % 10 != 0 && _selectedIndex == memoList.length ~/ 10) {
      pageMemoList = memoList.getRange(_selectedIndex*10, memoList.length-1).toList();
      print('a');
    }
    else {
      pageMemoList = memoList.getRange(_selectedIndex*10, _selectedIndex*10 + 10).toList();
      print('b');
    }

    DateFormat outputDate = DateFormat('yyyy年MM月dd日(EEE) a hh:mm');

    final List<Widget> widgets = pageMemoList.map(
          (memo) => Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: '編集',
            color: Colors.grey[350],
            icon: Icons.edit,
            onTap: () async {
              final String? title = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMemoPage(memo),
                ),
              );
              if (title != null) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('『$title』を編集しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          IconSlideAction(
            caption: '削除',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () async {
              // 削除しますか？って聞いて、はいだったら削除
              await showConfirmDialog(context, memo, memoList);
            },
          ),
        ],
        child: ListTile(
          title: Text('${memo.title}　${memo.team}'),
          subtitle: Text('${outputDate.format(memo.date)}    製作者名 ${memo.name}'),
          trailing: IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainTextPage(memo)),
              );
            },
          ),
        ),
      ),
    ).toList();
 */
/*
//EmailJSを用いたメール送信機能(reply_toは使用できる)

import 'package:http/http.dart' as http;
import 'dart:convert';

sendEmail() async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final service_id = "service_0dffs6s";
    final template_id = "template_qu36w3w";
    final user_id = "mUoppOrruL5s4QJCG";
    var respond = await http.post(url,
        headers: {
          'origin': 'http:/localhost',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
      "service_id": service_id,
      "template_id": template_id,
      "user_id": user_id,
      "template_params": {
        "to_email": 'atukunare2@gmail.com',
        "to_name": '西尾',
        "from_email": 'k646592@kansai-u.ac.jp',
        "name": 'k646592',
        "reply_to": 'anperdesu238@gmail.com',
        "message": 'test',
      },
    }));
    print(respond.body);
  }

 */