import 'package:fashionet/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  final String _phoneNumber;

  const HomePage({Key key, @required String phoneNumber})
      : _phoneNumber = phoneNumber,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _user.onLoggedOut(),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(
              'Welcome $_phoneNumber',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
