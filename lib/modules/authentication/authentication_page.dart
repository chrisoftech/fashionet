import 'package:fashionet/blocs/blocs.dart';
import 'package:fashionet/repositories/repositories.dart';
import 'package:fashionet/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState {
  Verification,
  Authentication,
}

class AuthenticationPage extends StatefulWidget {
  final UserRepository _userRepository;

  const AuthenticationPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  AuthState _authState = AuthState.Verification;

  Widget _buildVerifyPhoneNumberForm() {
    return VerifyPhoneNumberForm(
      userRepository: widget._userRepository,
      onVerifyPhoneNumberSuccess: (bool isVerified) {
        print('Authentication Page! $isVerified');
        if (isVerified) {
          setState(() {
            _authState = AuthState.Authentication;
          });
        }
      },
    );
  }

  Widget _buildLoginWithPhoneNumberForm() {
    return LoginForm(
      userRepository: widget._userRepository,
      onLoginSuccess: (bool isLoginSuccessfull) {
        print(isLoginSuccessfull);
        // Navigator
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: BlocProvider<LoginBloc>(
        builder: (BuildContext context) => LoginBloc(
            userRepository: widget._userRepository,
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        child: _authState == AuthState.Verification
            ? _buildVerifyPhoneNumberForm()
            : _buildLoginWithPhoneNumberForm(),
      ),
    );
  }
}
