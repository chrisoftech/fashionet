import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRepository {
  final Firestore _firestore;

  ProfileRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

      // Future<bool> hasProfile() {
      //   _firestore.collection('profile')
      // }
}
