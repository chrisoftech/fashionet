import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionet/blocs/blocs.dart';
import 'package:fashionet/repositories/repositories.dart';
import 'package:meta/meta.dart';

// login state
@immutable
class LoginState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  // bool get isFormValid => isFieldValueValid;

  LoginState({
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory LoginState.empty() {
    return LoginState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  LoginState copyWith({
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return LoginState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}

// login event
@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String verificationCode;

  LoginWithCredentialsPressed({@required this.verificationCode})
      : super([verificationCode]);

  @override
  String toString() =>
      'LoginWithCredentialsPressed { verificationCode: $verificationCode }';
}

// login bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  void onLoginWithCredentialsPressed({@required String verificationCode}) {
    dispatch(LoginWithCredentialsPressed(verificationCode: verificationCode));
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          verificationCode: event.verificationCode);
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      {@required String verificationCode}) async* {
    yield LoginState.loading();

    try {
      await _userRepository.logInWithPhoneNumber(
          verificationCode: verificationCode);
      yield LoginState.success();
    } catch (e) {
      yield LoginState.failure();
    }
  }
}
