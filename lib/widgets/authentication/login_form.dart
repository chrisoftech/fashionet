import 'package:fashionet/modules/modules.dart';
import 'package:flutter/material.dart';
import 'package:fashionet/repositories/repositories.dart';
import 'package:fashionet/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;
  final Function(bool) _onLoginSuccess;
  final Function(bool) _onRequestForNewCode;

  const LoginForm(
      {Key key,
      @required UserRepository userRepository,
      @required Function onLoginSuccess,
      @required Function onRequestForNewCode})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _onLoginSuccess = onLoginSuccess,
        _onRequestForNewCode = onRequestForNewCode,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;
  Function(bool) get _onLoginSuccess => widget._onLoginSuccess;
  Function(bool) get _onRequestForNewCode => widget._onRequestForNewCode;

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

  Widget _buildLoginFormTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'FASHIONet',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Text(
          'Sign in to continue to app',
          style: TextStyle(
              color: Colors.white70,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _loginFormSubTitle() {
    return Text(
      'Code Verification',
      style: TextStyle(
          color: Colors.white70, fontSize: 25.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLoginFormField() {
    return TextFormField(
      maxLength: 6,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      controller: _verificationCodeController,
      style: TextStyle(
          color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white10,
        counterText: '',
        border: InputBorder.none,
      ),
    );
  }

  Widget _buidRequestNewCodeControlButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onRequestForNewCode(true),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Text(
            'Request a new code',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginControlButton() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        onTap: () {
          // onLoginWithCredentialsButtonPressed();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ProfileFormWizard()));
        },
        child: Container(
          height: 50.0,
          width: 200.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.white70),
              borderRadius: BorderRadius.circular(30.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'VERIFY CODE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.arrow_right,
                size: 30.0,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildLoginFormTitle(),
          SizedBox(height: 30.0),
          _loginFormSubTitle(),
          SizedBox(height: 10.0),
          _buildLoginFormField(),
          SizedBox(height: 20.0),
          _buidRequestNewCodeControlButton(),
          SizedBox(height: 30.0),
          _buildLoginControlButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    // final double _deviceHeight = MediaQuery.of(context).size.height;
    // final double _deviceWidth = MediaQuery.of(context).size.width;

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
          // return Container(
          //   height: _deviceHeight,
          //   width: _deviceWidth,
          //   child: Center(
          //     child: SingleChildScrollView(
          //       child: Form(
          //         key: _formKey,
          //         child: Column(
          //           children: <Widget>[
          //             TextFormField(
          //               controller: _verificationCodeController,
          //               decoration: InputDecoration(),
          //             ),
          //             RaisedButton(
          //               child: Text('Verify code'),
          //               onPressed: isVerificationButtonEnabled(state: state)
          //                   ? onLoginWithCredentialsButtonPressed
          //                   : null,
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // );
          return _buildLoginForm();
        },
      ),
    );
  }
}
