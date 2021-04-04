import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommunipop/src/blocs/auth_bloc/bloc.dart';
import 'package:kommunipop/src/blocs/register_bloc/bloc.dart';
import 'package:kommunipop/src/ui/register/register_button.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // Dos variables
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
      // Si estado es submitting
      if (state.isSubmitting) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Creando Cuenta...'),
              CircularProgressIndicator()
            ],
          ),
        ));
      }
      // Si estado es success
      if (state.isSuccess) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        Navigator.pop(context);
      }
      // Si estado es failure
      if (state.isFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[Text('Registro fallido'), Icon(Icons.error)],
          ),
          backgroundColor: Colors.red,
        ));
      }
    }, child: BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 60.0,
                ),

                SizedBox(
                  height: 30.0,
                ),
                // Un textForm para email
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Correo',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (_) {
                    return !state.isEmailValid ? 'Correo Inválido' : null;
                  },
                ),
                // Un textForm para password
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock), labelText: 'Contraseña'),
                  obscureText: true,
                  autocorrect: false,
                  validator: (_) {
                    return !state.isPasswordValid
                        ? 'Contraseña Incorrecta'
                        : null;
                  },
                ),
                SizedBox(
                  height: 30.0,
                ),
                // Un button
                RegisterButton(
                  onPressed:
                      isRegisterButtonEnabled(state) ? _onFormSubmitted : null,
                )
              ],
            ),
          ),
        );
      },
    ));
  }

  void _onEmailChanged() {
    _registerBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _registerBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _registerBloc.add(Submitted(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }
}
