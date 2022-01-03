import 'package:admin_mini/methods/auth_methods.dart';
import 'package:admin_mini/methods/storage.dart';
import 'package:admin_mini/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:velocity_x/velocity_x.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Storage _storage = Storage();
  final AuthMethods _authMethods = AuthMethods();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _type = '';

  _login() {
    try {
      if (_usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _type != '') {
        _authMethods
            .login(_usernameController.text.toLowerCase(),
                _passwordController.text)
            .then((value) {
          // print(value.user!.uid);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
              (route) => false);
        }).catchError((err) {
          VxToast.show(context, msg: err.toString());
          _btnController.reset();
        });
      }
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.message.toString());
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/bull.png',
                height: 250,
              ),
              const SizedBox(height: 40),
              'Login To Crypto Future Trade Mini Admin'
                  .text
                  .bold
                  .color(Theme.of(context).primaryColor)
                  .size(22)
                  .make(),
              const SizedBox(height: 40),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                controller: _usernameController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
              ),
              DropdownButtonFormField<String>(
                hint: 'Select type'.text.make(),
                items: <String>['Admin', 'Manager'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  // print(_type);
                  setState(() {
                    _type = value.toString().toLowerCase();
                    _storage.addType(value.toString().toLowerCase());
                  });
                },
              ).h(50),
              const SizedBox(height: 40),
              RoundedLoadingButton(
                child: 'LOGIN'.text.bold.size(20).make(),
                controller: _btnController,
                onPressed: () => _login(),
                color: Theme.of(context).primaryColor,
              ).pSymmetric(v: 10)
            ],
          ).p16(),
        ),
      ),
    );
  }
}
