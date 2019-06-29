import 'package:fashionet/blocs/blocs.dart';
import 'package:fashionet/enums/enums.dart';
import 'package:fashionet/repositories/repositories.dart';
import 'package:fashionet/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  UserRepository get _userRepository => widget._userRepository;

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
      onRequestForNewCode: (bool onRequestForNewCode) {
        print('Request for new code! $onRequestForNewCode');
        if (onRequestForNewCode) {
          setState(() {
            _authState = AuthState.Verification;
          });
        }
      },
      onLoginSuccess: (bool isLoginSuccessfull) {
        print('Login is $isLoginSuccessfull');
      },
    );
  }

  Widget _buildAuthenticationPageBody(
      {@required double deviceHeight, @required double deviceWidth}) {
    return Container(
      height: deviceHeight,
      width: deviceWidth,
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30.0),
                _authState == AuthState.Verification
                    ? _buildVerifyPhoneNumberForm()
                    : _buildLoginWithPhoneNumberForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopGradientBackground(
      {@required deviceHeight, @required deviceWidth}) {
    final double _gradientHeight = deviceHeight / 4;

    return Positioned(
      top: 0.0,
      height: _gradientHeight,
      width: deviceWidth,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.transparent,
              Colors.black54,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomGradientBackground(
      {@required deviceHeight, @required deviceWidth}) {
    final double _gradientHeight = deviceHeight / 4.5;

    return Positioned(
      bottom: 0.0,
      height: _gradientHeight,
      width: deviceWidth,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black87,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocProvider<LoginBloc>(
        builder: (BuildContext context) =>
            LoginBloc(userRepository: widget._userRepository),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Stack(
            children: <Widget>[
              _buildAuthenticationPageBody(
                  deviceHeight: _deviceHeight, deviceWidth: _deviceWidth),
              _buildBottomGradientBackground(
                  deviceHeight: _deviceHeight, deviceWidth: _deviceWidth),
              _buildTopGradientBackground(
                  deviceHeight: _deviceHeight, deviceWidth: _deviceWidth),
            ],
          ),
        ),
      ),
    );
  }
}
