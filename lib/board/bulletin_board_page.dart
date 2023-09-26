import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/board/bulletin_board_show.dart';
import 'package:recsseem_mobile/domain/board.dart';

import 'bulletin_board_model.dart';


class BulletinBoardPage extends StatefulWidget {
  const BulletinBoardPage({Key? key}) : super(key: key);

  @override
  State<BulletinBoardPage> createState() => _BulletinBoardPage();
}

class _BulletinBoardPage extends State<BulletinBoardPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BulletinBoardModel>(
      create: (_) => BulletinBoardModel()..fetchBoard(),
      child: Consumer<BulletinBoardModel>(builder: (context, model, child) {

        final List<Widget> widgets = model.boardsList.map(
              (board) => Card(
            child: ListTile(

              title: Text(board.title),
              subtitle: Text(board.userId),
              trailing: IconButton(
                onPressed: () async {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){
                        return BoardShow(board);
                      })
                  );
                },
                icon: const Icon(Icons.login_outlined),
              ),
            ),
          ),
        ).toList();

        return boardsList(model.boardsList, widgets);
      }),
    );
  }

  Widget boardsList(List<Board> boardsList, List<Widget> widgets){
    if(boardsList.isEmpty) {
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

}


