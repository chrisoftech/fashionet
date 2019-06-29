import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet/repositories/image_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProfileRepository {
  final Firestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final ImageRepository _imageRepository;

  ProfileRepository(
      {Firestore firestore,
      FirebaseAuth firebaseAuth,
      ImageRepository imageRepository})
      : _firestore = firestore ?? Firestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _imageRepository = imageRepository ?? ImageRepository();

  Future<String> get getUserId async => (await _firebaseAuth.currentUser()).uid;

  Future<void> _saveProfileAvatarDownloadUrlToProfile(
      {@required String avatarDownloadUrl}) async {
    final String userId = await getUserId;

    return await _firestore.collection('profiles').document(userId).setData({
      'avatarUrl': avatarDownloadUrl,
    });
  }

  Future<void> uploadProfileAvatar({@required Asset asset}) async {
    final String userId = await getUserId;

    final String avatarDownloadUrl =
        await _imageRepository.saveProfileAvatar(userId: userId, asset: asset);

    return await _saveProfileAvatarDownloadUrlToProfile(
        avatarDownloadUrl: avatarDownloadUrl);
  }
}
