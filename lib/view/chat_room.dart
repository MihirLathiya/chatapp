import 'package:chatapp/common/text_field.dart';
import 'package:chatapp/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  final Map<String, dynamic>? userMap;
  final String? chatRoomId;

  final _message = TextEditingController();

  ChatRoom({
    Key? key,
    this.userMap,
    this.chatRoomId,
  }) : super(key: key);

  onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'sendBy': firebaseAuth.currentUser!.displayName,
        'message': _message.text,
        'time': FieldValue.serverTimestamp()
      };
      await firebaseFirestore
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
      _message.clear();
    } else {
      print('some text add');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        width: double.infinity,
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: TsField(
                hintText: 'Write here...',
                validator: (value) {
                  return null;
                },
                controller: _message,
                hide: false,
              ),
            ),
            IconButton(
              onPressed: () {
                // await onSend();
                onSendMessage();
              },
              icon: const Icon(Icons.send_outlined),
            )
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: 35,
              width: 35,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue),
              child: Image.network(
                '${userMap!['image']}',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text('${userMap!['name']}'),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 500,
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseFirestore
                    .collection('chatRoom')
                    .doc(chatRoomId)
                    .collection('chats')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map =
                            snapshot.data!.docs[index].data();
                        return Container(
                          width: double.infinity,
                          alignment: map['sendBy'] ==
                                  firebaseAuth.currentUser!.displayName
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: Text(
                              map['message'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
