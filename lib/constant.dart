import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

GetStorage storage = GetStorage();

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

CollectionReference collectionReference = firebaseFirestore.collection('users');
