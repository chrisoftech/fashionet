import 'package:flutter/material.dart';
import 'package:fashionet/repositories/repositories.dart';
import 'package:fashionet/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyPhoneNumberForm extends StatefulWidget {
  final UserRepository _userRepository;
  final Function(bool) _onVerifyPhoneNumberSuccess;

  const VerifyPhoneNumberForm(
      {Key key,
      @required UserRepository userRepository,
      @required Function onVerifyPhoneNumberSuccess})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _onVerifyPhoneNumberSuccess = onVerifyPhoneNumberSuccess,
        super(key: key);

  @override
  _VerifyPhoneNumberFormState createState() => _VerifyPhoneNumberFormState();
}

class _VerifyPhoneNumberFormState extends State<VerifyPhoneNumberForm> {
  VerificationBloc _verificationBloc;

  UserRepository get _userRepository => widget._userRepository;
  Function(bool) get _onVerifyPhoneNumberSuccess => widget._onVerifyPhoneNumberSuccess;

  GlobalKey<State> _formKey = GlobalKey<State>();
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _verificationBloc = VerificationBloc(userRepository: _userRepository);
  }

  bool isVerificationButtonEnabled({VerificationState state}) {
    return !state.isSubmitting;
  }

  void onVerifyPhoneNumberButtonPressed() {
    _verificationBloc.onVerifyPhoneNumberButtonPressed(
        phoneNumber: _phoneNumberController.text);
  }

  @override
  Widget build(BuildContext context) {
    // final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return BlocListener(
      bloc: _verificationBloc,
      listener: (BuildContext context, VerificationState state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Verification Failure'), Icon(Icons.error)],
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
                    Text('Sending verification code...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          _onVerifyPhoneNumberSuccess(true);
        }
      },
      child: BlocBuilder(
        bloc: _verificationBloc,
        builder: (BuildContext context, VerificationState state) {
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
                        controller: _phoneNumberController,
                        decoration: InputDecoration(),
                      ),
                      RaisedButton(
                        child: Text('Verify phone number'),
                        onPressed: isVerificationButtonEnabled(state: state)
                            ? onVerifyPhoneNumberButtonPressed
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
