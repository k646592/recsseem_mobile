import 'package:flutter/material.dart';
import 'package:recsseem_mobile/newcalendar/view/new_event_index_page.dart';

import '../attendancemanagement/attendance_management_page.dart';
import '../chat/chat_room_page.dart';
import '../mypage/my_page.dart';

class Footer extends StatefulWidget {

  final int pageNumber;
  const Footer({super.key, required this.pageNumber});

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  late int _selectedIndex;
  final _bottomNavigationBarItems = <BottomNavigationBarItem>[];

  //アイコン情報
  static const _footerIcons = [
    Icons.calendar_month,
    Icons.groups,
    Icons.chat,
    Icons.account_circle,
  ];

  //アイコン文字列
  static const _footerItemNames = [
    'イベント',
    '出席管理',
    'チャット',
    'マイページ',
  ];

  final _routes = [
    TopPage(),
    const AttendanceManagementPage(),
    const ChatRoomListPage(),
    const MyPage(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.pageNumber;
    super.initState();
    for ( var i =0; i < _footerItemNames.length; i++) {
      if(_selectedIndex != i) {
        _bottomNavigationBarItems.add(_UpdateDeactiveState(i));
      }
      else {
        _bottomNavigationBarItems.add(_UpdateActiveState(_selectedIndex));
      }
    }
  }

  // インデックスのアイテムをアクティベートする
  BottomNavigationBarItem _UpdateActiveState(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _footerIcons[index],
        color: Colors.black87,
      ),
      label: _footerItemNames[index],
    );
  }

  // インデックスのアイテムをディアクティベートする
  BottomNavigationBarItem _UpdateDeactiveState(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _footerIcons[index],
        color: Colors.black26,
      ),
      label: _footerItemNames[index],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavigationBarItems[_selectedIndex] = _UpdateDeactiveState(_selectedIndex);
      _bottomNavigationBarItems[index] = _UpdateActiveState(index);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _routes.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,  //これを書かないと３つまでしか表示されない
        items: _bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}