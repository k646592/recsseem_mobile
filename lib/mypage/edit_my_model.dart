import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditMyPageModel extends ChangeNotifier {
  EditMyPageModel(this.name, this.email, this.group, this.grade) {
    nameController.text = name;
    email = email;
    group = group;
    grade = grade;
  }

  final nameController = TextEditingController();

  String email;
  String name;
  String group;
  String grade;

  File? imageFile;
  final picker = ImagePicker();

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setGroup(String group) {
    this.group = group;
    notifyListeners();
  }

  void setGrade(String grade) {
    this.grade = grade;
    notifyListeners();
  }

  void fetchUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    email = snapshot.data()!['email'];
    name = snapshot.data()!['name'];
    group = snapshot.data()!['group'];
    grade = snapshot.data()!['grade'];
    notifyListeners();
  }

  Future update() async {
    name = nameController.text;

    if(name==''){
      throw '名前が入力されていません。';
    }
    if(group==''){
      throw 'グループが選択されていません。';
    }
    if(grade==''){
      throw '学年が選択されていません。';
    }

    
    final doc = FirebaseFirestore.instance.collection('users').doc();
    String? imgURL;
    if(imageFile!= null) {
      final task = await FirebaseStorage.instance.ref('users/${doc.id}').putFile(imageFile!);
      task.ref.getDownloadURL();
      imgURL = await task.ref.getDownloadURL();
    }
    
    
    //firestoreに更新
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'group': group,
      'grade': grade,
      'imgURL': imgURL,
    });
    notifyListeners();
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
  }

}