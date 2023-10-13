import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../HeaderandFooter/footer.dart';
import '../add_memo/add_memo_page.dart';
import '../domain/memo.dart';
import '../edit_memo/edit_memo_page.dart';
import '../main_text/main_text_page.dart';

class MemoListShow extends StatelessWidget {

  final List<Memo> memo;
  const MemoListShow({super.key, required this.memo});

  @override
  Widget build(BuildContext context) {
    DateFormat outputDate = DateFormat('yyyy年MM月dd日(EEE) a hh:mm');
    memo.sort(((a, b) => b.date.compareTo(a.date)));

    List<Memo> memoList = memo;

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('議事録一覧'),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Footer(pageNumber: 4),
                ),
              );
            },
          ),
        ),
        body: Center(
            child: ListView(
              children: widgets,
            ),

        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMemoPage(),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                const snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('議事録を追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),

        ),
    );
  }

  Future showConfirmDialog(BuildContext context, Memo memo, List<Memo> memoList) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("削除の確認"),
          content: Text("『${memo.title}』を削除しますか？"),
          actions: [
            TextButton(
              child: const Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("はい"),
              onPressed: () async {
                // modelで削除
                await delete(memo);
                memoList.remove(memo);
                await Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => MemoListShow(memo: memoList),
                    fullscreenDialog: true,
                  ),
                );
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('『${memo.title}』を削除しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }

  Future delete(Memo memo) {
    return FirebaseFirestore.instance.collection('memolist').doc(memo.id).delete();
  }
}