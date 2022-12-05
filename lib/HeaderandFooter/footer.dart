import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recsseem_mobile/event/event_index_page.dart';

import '../attendancemanagement/attendance_management_page.dart';
import '../chat/chat_page.dart';
import '../mypage/my_page.dart';

class Footer extends StatefulWidget {
  Footer({Key? key}) : super(key:key);

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;
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
    'イベント一覧',
    '出席管理',
    'チャット',
    'マイページ',
  ];

  var _routes = [
    EventIndexPage(),
    AttendanceManagementPage(),
    ChatPage(),
    MyPage(),
  ];

  @override
  void initState() {
    super.initState();
    _bottomNavigationBarItems.add(_UpdateActiveState(0));
    for ( var i =1; i < _footerItemNames.length; i++) {
      _bottomNavigationBarItems.add(_UpdateDeactiveState(i));
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