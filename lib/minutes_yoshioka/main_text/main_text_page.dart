import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';
import '../domain/memo.dart';
import 'main_text_model.dart';

class MainTextPage extends StatelessWidget {
  final Memo memo;
  MainTextPage(this.memo);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainTextModel>(
      create: (_) => MainTextModel(memo),
      child: Consumer<MainTextModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                model.update_main();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Footer(pageNumber: 4),
                  ),
                );
              },
            ),
            title: Text(memo.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  model.update_main();
                },
              ),
            ]
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 40,
                controller: model.mainTextController,
                onChanged: (text) {
                  model.setMainText(text);
                },
              ),
            ],
          ),
        );
      })
    );
  }
}