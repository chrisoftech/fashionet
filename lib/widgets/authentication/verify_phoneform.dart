import 'package:flutter/material.dart';
import 'package:fashionet/repositories/repositories.dart';
import 'package:fashionet/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';

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
  Function(bool) get _onVerifyPhoneNumberSuccess =>
      widget._onVerifyPhoneNumberSuccess;

  GlobalKey<State> _formKey = GlobalKey<State>();
  final _phoneNumberController = TextEditingController();

  String _selectedCountryCode;

  @override
  void initState() {
    super.initState();

    _verificationBloc = VerificationBloc(userRepository: _userRepository);
  }

  bool isVerificationButtonEnabled({VerificationState state}) {
    return !state.isSubmitting;
  }

  void onVerifyPhoneNumberButtonPressed() {
    final String _phoneNumberWithCode =
        '$_selectedCountryCode${_phoneNumberController.text}';

    _verificationBloc.onVerifyPhoneNumberButtonPressed(
        phoneNumber: _phoneNumberWithCode);
  }

  // Widget _buildBlocBuilderContent() {
  //   return Container(
  //     height: _deviceHeight,
  //     width: _deviceWidth,
  //     child: Center(
  //       child: SingleChildScrollView(
  //         child: Form(
  //           key: _formKey,
  //           child: Column(
  //             children: <Widget>[
  //               TextFormField(
  //                 controller: _phoneNumberController,
  //                 decoration: InputDecoration(),
  //               ),
  //               RaisedButton(
  //                 child: Text('Verify phone number'),
  //                 onPressed: isVerificationButtonEnabled(state: state)
  //                     ? onVerifyPhoneNumberButtonPressed
  //                     : null,
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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

  Widget _buildVerificationFormFields() {
    return Row(
      children: <Widget>[
        CountryCodePicker(
          onChanged: (CountryCode countryCode) =>
              _selectedCountryCode = countryCode.toString(),
          initialSelection: '+233',
          favorite: ['+233'],
          showCountryOnly: false,
          textStyle: TextStyle(color: Colors.white, fontSize: 28.0),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: _phoneNumberController,
            style: TextStyle(color: Colors.white, fontSize: 30.0),
            decoration:
                InputDecoration(contentPadding: EdgeInsets.only(bottom: 5.0)),
            validator: (String value) {
              return value.isEmpty ? 'Enter a valid phone number!' : null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationControlButton({@required VerificationState state}) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        onTap: isVerificationButtonEnabled(state: state)
            ? onVerifyPhoneNumberButtonPressed
            : null,
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
                'LOGIN',
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

  Widget _buildVerificationForm({@required VerificationState state}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildLoginFormTitle(),
          SizedBox(height: 30.0),
          Text(
            'Please select your country code and enter your phone number (+xxx xxxx xxxx xxx)',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.0),
          _buildVerificationFormFields(),
          SizedBox(height: 30.0),
          _buildVerificationControlButton(state: state),
        ],
      ),
    );
  }

  // Widget _buildLoginForm() {
  //   return Form(
  //     key: _formKey,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           'Please select your country code and enter your phone number (+xxx xxxx xxxx xxx)',
  //           style: TextStyle(
  //             color: Colors.white,
  //           ),
  //         ),
  //         SizedBox(height: 10.0),
  //         _buildFormField(),
  //         SizedBox(height: 30.0),
  //         _buildLoginControlButton(),
  //       ],
  //     ),
  //   );
  // }

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
          return _buildVerificationForm(state: state);
        },
      ),
    );
  }
}
