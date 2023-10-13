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