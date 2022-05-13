import 'dart:io';

import 'package:chatapp/common/text_field.dart';
import 'package:chatapp/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatefulWidget {
  final String? chatRoomId;
  final String? name;
  final String? image;
  final String? hi;

  ChatRoom({
    Key? key,
    this.chatRoomId,
    this.name,
    this.image,
    this.hi,
  }) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  File? images;
  final picker = ImagePicker();
  final _message = TextEditingController();

  /// pick Image
  Future setImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(
        () {
          images = File(pickedFile.path);
          uploadImg();
        },
      );
    }
  }

  /// upload image
  ///
  Future uploadImg() async {
    String fileName = Uuid().v1();
    int status = 1;
    await firebaseFirestore
        .collection('chatRoom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      'sendBy': firebaseAuth.currentUser!.displayName,
      'message': '',
      'type': 'img',
      'time': FieldValue.serverTimestamp()
    });
    var ref =
        FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
    var uploadTask = await ref.putFile(images!).catchError((error) async {
      await firebaseFirestore
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();
      status = 0;
    });
    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await firebaseFirestore
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({'message': imageUrl});
      print(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: 35,
              width: 35,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Image.network(
                '${widget.image}',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text('${widget.name}'),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://wallpapercave.com/wp/wp4410716.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: firebaseFirestore
                  .collection('chatRoom')
                  .doc(widget.chatRoomId)
                  .collection('chats')
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data != null) {
                  return Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map =
                            snapshot.data!.docs[index].data();
                        return map['type'] == 'text'
                            ? Container(
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
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
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
                              )
                            : Container(
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
                                  height: 200,
                                  width: 200,
                                  alignment: Alignment.center,
                                  child: map['message'] != ''
                                      ? Image.network(
                                          map['message'],
                                          fit: BoxFit.cover,
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ),
                              );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            // Spacer(),
            Container(
              height: 60,
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TsField(
                        icon: Icons.document_scanner,
                        onPress: () {
                          setImage();
                        },
                        align: TextAlign.left,
                        hintText: 'Write here...',
                        validator: (value) {
                          return null;
                        },
                        controller: _message,
                        hide: false,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      onSendMessage();
                    },
                    icon: const Icon(Icons.send_outlined),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'sendBy': firebaseAuth.currentUser!.displayName,
        'message': _message.text,
        'type': 'text',
        'time': FieldValue.serverTimestamp()
      };
      await firebaseFirestore
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
      _message.clear();
    } else {
      print('some text add');
    }
  }
}
