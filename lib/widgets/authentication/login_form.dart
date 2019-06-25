import 'package:flutter/material.dart';
import 'package:fashionet/repositories/repositories.dart';
import 'package:fashionet/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;
  final Function(bool) _onLoginSuccess;

  const LoginForm(
      {Key key,
      @required UserRepository userRepository,
      @required Function onLoginSuccess})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _onLoginSuccess = onLoginSuccess,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;
  Function(bool) get _onLoginSuccess => widget._onLoginSuccess;

  GlobalKey<State> _formKey = GlobalKey<State>();
  final _verificationCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
    );
  }

  bool isVerificationButtonEnabled({LoginState state}) {
    return !state.isSubmitting;
  }

  void onLoginWithCredentialsButtonPressed() {
    _loginBloc.onLoginWithCredentialsPressed(
        verificationCode: _verificationCodeController.text);
  }

  @override
  Widget build(BuildContext context) {
    // final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return BlocListener(
      bloc: _loginBloc,
      listener: (BuildContext context, LoginState state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          print('LoggedIn successfully');
          _onLoginSuccess(true);
        }
      },
      child: BlocBuilder(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          return Container(
            height: _deviceHeight,
            width: _deviceWidth,
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _verificationCodeController,
                        decoration: InputDecoration(),
                      ),
                      RaisedButton(
                        child: Text('Verify code'),
                        onPressed: isVerificationButtonEnabled(state: state)
                            ? onLoginWithCredentialsButtonPressed
                            : null,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
