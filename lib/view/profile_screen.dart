import 'package:chatapp/common/text.dart';
import 'package:chatapp/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;

  String? email;

  String? status;

  String? image;

  Future getData() async {
    var user =
        await collectionReference.doc(firebaseAuth.currentUser!.uid).get();
    Map<String, dynamic>? getUser = user.data();
    name = getUser!['name'];
    email = getUser['email'];
    status = getUser['status'];
    setState(() {
      image = getUser['image'];
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Ts(
          text: 'Profile',
          size: 20,
        ),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Image.network(
                '$image',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Ts(
                    text: 'Name',
                    size: 12,
                    color: Colors.grey,
                  ),
                  Ts(
                    text: '${firebaseAuth.currentUser!.displayName}',
                    weight: FontWeight.w500,
                    size: 20,
                  ),
                ],
              ),
              subtitle: Ts(
                text: 'This is Your username ',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Ts(
                    text: 'Email',
                    size: 12,
                    color: Colors.grey,
                  ),
                  Ts(
                    text: '${firebaseAuth.currentUser!.email}',
                    weight: FontWeight.w500,
                    size: 20,
                  ),
                ],
              ),
              subtitle: Ts(
                text: 'This is Your email ',
              ),
            )
          ],
        ),
      ),
    );
  }
}
