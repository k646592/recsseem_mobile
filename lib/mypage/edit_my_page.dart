import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';
import 'edit_my_model.dart';

class EditMyPage extends StatefulWidget {
  final String name;
  final String email;
  final String group;
  final String grade;
  const EditMyPage({Key? key, required this.name, required this.email, required this.group, required this.grade}) : super(key:key);

  @override
  _EditMyPageState createState() => _EditMyPageState();
}

class _EditMyPageState extends State<EditMyPage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditMyPageModel>(
      create: (_) => EditMyPageModel(widget.name, widget.email, widget.group, widget.grade)..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ユーザー情報変更'),
        ),
        body: Center(
          child: Consumer<EditMyPageModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                          'メールアドレス：${model.email}',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      GestureDetector(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: model.imageFile != null ? Image.file(model.imageFile!) :
                          Container(
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () async {
                          await model.pickImage();
                        },
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      TextField(
                        controller: model.nameController,
                        decoration: const InputDecoration(
                          hintText: '名前(苗字のみ)',
                        ),
                        onChanged: (text) {
                          model.setName(text);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '選択した班：${model.group}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'Web班',
                                groupValue: model.group,
                                onChanged: (text) {
                                  model.setGroup(text!);
                                },
                              ),
                              Text('Web班'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'Grid班',
                                groupValue: model.group,
                                onChanged: (text) {
                                  model.setGroup(text!);
                                },
                              ),
                              Text('Grid班'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: 'Network班',
                                groupValue: model.group,
                                onChanged: (text) {
                                  model.setGroup(text!);
                                },
                              ),
                              Text('Network班'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: '教員',
                                groupValue: model.group,
                                onChanged: (text) {
                                  model.setGroup(text!);
                                },
                              ),
                              Text('教員'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '選択した学年：${model.grade}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      DropdownButton(
                          value: model.grade,
                          items: const [
                            DropdownMenuItem(
                              child: Text('B4'),
                              value: 'B4',
                            ),
                            DropdownMenuItem(
                              child: Text('M1'),
                              value: 'M1',
                            ),
                            DropdownMenuItem(
                              child: Text('M2'),
                              value: 'M2',
                            ),
                            DropdownMenuItem(
                              child: Text('D1'),
                              value: 'D1',
                            ),
                            DropdownMenuItem(
                              child: Text('D2'),
                              value: 'D2',
                            ),
                            DropdownMenuItem(
                              child: Text('D3'),
                              value: 'D3',
                            ),
                            DropdownMenuItem(
                              child: Text('教授'),
                              value: '教授',
                            ),
                          ],
                          onChanged: (text) {
                            model.setGrade(text!);
                          }
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          model.startLoading();
                          try {
                            await model.update();
                            //ユーザー登録
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) {
                                    return const Footer(pageNumber: 4);
                                  }
                              ),
                            );
                          } catch (error) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(error.toString()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } finally {
                            model.endLoading();
                          }
                        },
                        child: Text('変更する'),
                      ),
                    ],
                  ),
                ),
                if (model.isLoading)
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