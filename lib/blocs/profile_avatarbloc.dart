import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionet/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProfileAvatarState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  ProfileAvatarState(
      {@required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure});

  factory ProfileAvatarState.empty() {
    return ProfileAvatarState(
        isSubmitting: false, isSuccess: false, isFailure: false);
  }

  factory ProfileAvatarState.loading() {
    return ProfileAvatarState(
        isSubmitting: true, isSuccess: false, isFailure: false);
  }

  factory ProfileAvatarState.failure() {
    return ProfileAvatarState(
        isSubmitting: false, isSuccess: false, isFailure: true);
  }

  factory ProfileAvatarState.success() {
    return ProfileAvatarState(
        isSubmitting: false, isSuccess: true, isFailure: false);
  }

  @override
  String toString() {
    return '''ProfileAvatarState {
     isSubmitting: $isSubmitting,
     isSuccess: $isSuccess,
     isFailure: $isFailure,
   }''';
  }
}

// profileAvatar events
class ProfileAvatarEvent extends Equatable {
  ProfileAvatarEvent([List props = const []]) : super(props);
}

class UploadProfileImageButtonClicked extends ProfileAvatarEvent {
  final Asset profileAvatarAsset;

  UploadProfileImageButtonClicked({@required this.profileAvatarAsset})
      : super([profileAvatarAsset]);

  @override
  String toString() =>
      'UploadProfileImageButtonClicked { profileAvatarAsset: ${profileAvatarAsset.toString()} }';
}

class ProfileAvatarBloc extends Bloc<ProfileAvatarEvent, ProfileAvatarState> {
  final ProfileRepository _profileRepository;

  ProfileAvatarBloc({@required ProfileRepository profileRepository})
      : assert(profileRepository != null),
        _profileRepository = profileRepository;

  @override
  ProfileAvatarState get initialState => ProfileAvatarState.empty();

  void onUploadProfileImageButtonClicked({@required Asset profileAvatarAsset}) {
    dispatch(UploadProfileImageButtonClicked(
        profileAvatarAsset: profileAvatarAsset));
  }

  @override
  Stream<ProfileAvatarState> mapEventToState(ProfileAvatarEvent event) async* {
    if (event is UploadProfileImageButtonClicked) {
      yield* _mapProfileAvatarStateToEvent(
          profileAvatarAsset: event.profileAvatarAsset);
    }
  }

  Stream<ProfileAvatarState> _mapProfileAvatarStateToEvent(
      {@required Asset profileAvatarAsset}) async* {
    yield ProfileAvatarState.loading();

    try {
      // Future.delayed(Duration(seconds: 10));
      await _profileRepository.uploadProfileAvatar(asset: profileAvatarAsset);
      yield ProfileAvatarState.success();
    } catch (e) {
      print(e.toString());
      yield ProfileAvatarState.failure();
    }
  }
}
