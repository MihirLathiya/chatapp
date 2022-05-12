import 'dart:math';

import 'package:chatapp/common/text_field.dart';
import 'package:chatapp/constant.dart';
import 'package:chatapp/view/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnitAt(0) >
        user2.toLowerCase().codeUnitAt(0)) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  Map<String, dynamic>? userMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TsField(
              hintText: 'Search',
              validator: (value) {},
              controller: _search,
              hide: false,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onSearch();
            },
            child: Ts(
              text: 'SEARCH',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          userMap != null
              ? ListTile(
                  onTap: () {
                    String roomId = chatRoomId(
                        '${firebaseAuth.currentUser!.displayName}',
                        userMap!['name']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoom(
                          chatRoomId: roomId,
                          userMap: userMap,
                        ),
                      ),
                    );
                  },
                  leading: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Image.network(
                      userMap!['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Ts(
                    text: '${userMap!['name']}',
                    weight: FontWeight.w900,
                  ),
                  subtitle: Ts(
                    text: '${userMap!['email']}',
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  onSearch() async {
    await collectionReference
        .where('email', isEqualTo: _search.text)
        .get()
        .then(
      (value) {
        setState(
          () {
            userMap = value.docs[0].data();
          },
        );
      },
    );
  }
}
