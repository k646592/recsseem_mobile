import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPageModel  {

  getChats(String roomId) async {
    return FirebaseFirestore.instance.collection('rooms').doc(roomId).collection('messages').orderBy('time').snapshots();
  }

  getSender() async {
    final user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    return snapshot.data()!['name'];
  }

  sendMessageStore(String roomId, Map<String, dynamic> chatMessageData) async {
    FirebaseFirestore.instance.collection('rooms').doc(roomId).collection('messages').add(chatMessageData);

    FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['senderId'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });

  }

}