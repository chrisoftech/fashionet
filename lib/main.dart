import 'package:bloc/bloc.dart';
import 'package:fashionet/blocs/blocs.dart';
import 'package:fashionet/repositories/repositories.dart';
import 'package:fashionet/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'delegates/delegates.dart';
import 'modules/modules.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(BlocProvider(
    builder: (BuildContext context) =>
        AuthenticationBloc(userRepository: userRepository)..onAppStarted(),
    child: MyApp(userRepository: userRepository),
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  const MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FashionNet',
      theme: ThemeData(
        fontFamily: 'QuickSand',
        primarySwatch: Colors.indigo,
        accentColor: Colors.orange,
      ),
      home: _buildHomePage(context: context),
    );
  }

  Widget _buildHomePage({@required BuildContext context}) {
    return BlocBuilder(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      builder: (BuildContext context, AuthenticationState state) {
        if (state is Uninitialized) {
          return SplashPage();
        } else if (state is Authenticated) {
          return HomePage(phoneNumber: state.phoneNumber);
        } else if (state is Unauthenticated) {
          return IntroPage(userRepository: _userRepository);
          // return AuthenticationPage(userRepository: _userRepository);
        }
      },
    );
  }
}
