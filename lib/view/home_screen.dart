import 'dart:math';

import 'package:chatapp/common/text_field.dart';
import 'package:chatapp/constant.dart';
import 'package:chatapp/service/email_auth.dart';
import 'package:chatapp/view/auth_screens/log_in_screen.dart';
import 'package:chatapp/view/chat_room.dart';
import 'package:chatapp/view/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<String> menu = ['Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Ts(
          text: 'LET\'_S TALK',
          weight: FontWeight.w900,
          size: 19,
          latterSpace: 1.5,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(
                        Icons.person_outline,
                        color: Colors.black,
                      ),
                      Text("Profile"),
                    ],
                  ),
                ),
              ),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () async {
                    await EmailAuth.logOut().whenComplete(
                      () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogInScreen(),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(
                        Icons.login,
                        color: Colors.black,
                      ),
                      Text("Log Out"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(20, 100),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: TsField(
              hintText: 'Search',
              validator: (value) {},
              controller: _search,
              hide: false,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          /// search Button
          // ElevatedButton(
          //   onPressed: () {
          //     onSearch();
          //   },
          //   child: Ts(
          //     text: 'SEARCH',
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),

          /// search result show
          // _search.text.isNotEmpty
          //     ? Container(
          //         child: userMap != null
          //             ? ListTile(
          //                 onTap: () {
          //                   String roomId = chatRoomId(
          //                       '${firebaseAuth.currentUser!.displayName}',
          //                       userMap!['name']);
          //                   Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => ChatRoom(
          //                         chatRoomId: roomId,
          //                         userMap: userMap,
          //                       ),
          //                     ),
          //                   );
          //                 },
          //                 leading: Container(
          //                   height: 50,
          //                   width: 50,
          //                   clipBehavior: Clip.antiAliasWithSaveLayer,
          //                   decoration:
          //                       const BoxDecoration(shape: BoxShape.circle),
          //                   child: Image.network(
          //                     userMap!['image'],
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //                 title: Ts(
          //                   text: '${userMap!['name']}',
          //                   weight: FontWeight.w900,
          //                 ),
          //                 subtitle: Ts(
          //                   text: '${userMap!['email']}',
          //                 ),
          //               )
          //             : Center(
          //                 child: Ts(
          //                   text: 'NotFound',
          //                 ),
          //               ),
          //       )
          StreamBuilder<QuerySnapshot>(
            stream: collectionReference.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(
                          '${collectionReference.doc(firebaseAuth.currentUser!.uid)}');
                      var data = snapshot.data!.docs[index];

                      snapshot.data!.docs.forEach((element) {
                        element['email'] != firebaseAuth.currentUser!.email;
                      });

                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              String roomId = chatRoomId(
                                  '${firebaseAuth.currentUser!.displayName}',
                                  '${data.get('name')}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                      chatRoomId: roomId,
                                      image: '${data.get('image')}',
                                      name: '${data.get('name')}'),
                                ),
                              );
                            },
                            leading: Container(
                              height: 50,
                              width: 50,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: Image.network(
                                firebaseAuth.currentUser!.photoURL ==
                                        snapshot.data!.docs[index]['image']
                                    ? ''
                                    : '${data.get('image')}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Ts(
                              text: firebaseAuth.currentUser!.displayName ==
                                      snapshot.data!.docs[index]['name']
                                  ? ''
                                  : '${data.get('name')}',
                              weight: FontWeight.w900,
                            ),
                            subtitle: Ts(
                              text: firebaseAuth.currentUser!.email ==
                                      snapshot.data!.docs[index]['email']
                                  ? ''
                                  : '${data.get('email')}',
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0),
                            child: Divider(
                              thickness: 1,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// on search press
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
