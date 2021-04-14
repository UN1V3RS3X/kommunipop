import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommunipop/src/resources/firebase_repository.dart';
import 'package:kommunipop/src/ui/home.dart';
import 'package:kommunipop/src/ui/initial_setting/initial_config.dart';
import 'package:kommunipop/src/ui/login/login_screen.dart';
import 'package:kommunipop/src/ui/splash.dart';

import 'blocs/auth_bloc/bloc.dart';

class App extends StatelessWidget {
  final UserRepository _userRepository;
  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Authenticated) {
              return Home(
                userRepository: _userRepository,
              );
            }
            if (state is AuthenticatedButNotSet) {
              return Home(
                userRepository: _userRepository,
              );
            }
            if (state is Unauthenticated) {
              return LoginScreen(userRepository: _userRepository);
            }
            return Container();
          },
        ));
  }
}
