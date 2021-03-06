import 'package:admin_mini/methods/auth_methods.dart';
import 'package:admin_mini/methods/db_methods.dart';
import 'package:admin_mini/methods/storage.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:velocity_x/velocity_x.dart';

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final AuthMethods _authMethods = AuthMethods();
  final DbMethods _dbMethods = DbMethods();
  final Storage _storage = Storage();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String type = '';

  _createUser() {
    if (_nameController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _amountController.text.isNotEmpty) {
      if (type == 'admin') {
        _authMethods
            .register(_usernameController.text.toLowerCase(),
                _passwordController.text)
            .then((value) {
          _dbMethods.addUser(
            _nameController.text.toLowerCase(),
            _emailController.text.toLowerCase(),
            _passwordController.text,
            num.parse(_amountController.text),
            value.user!.uid,
            _usernameController.text.toLowerCase(),
            _authMethods.currentUser()!.uid,
          );

          Navigator.pop(context);
        }).catchError((err) {
          _btnController.reset();
          VxToast.show(context, msg: err.toString());
        });
      } else {
        _authMethods
            .register(_usernameController.text.toLowerCase(),
                _passwordController.text)
            .then((value) {
          _dbMethods.addUser(
            _nameController.text.toLowerCase(),
            _emailController.text.toLowerCase(),
            _passwordController.text,
            num.parse(_amountController.text),
            value.user!.uid,
            _usernameController.text.toLowerCase(),
            _authMethods.currentUser()!.uid,
          );

          // _dbMethods.addUserToManager(
          //   _nameController.text.toLowerCase(),
          //   _emailController.text.toLowerCase(),
          //   _passwordController.text,
          //   num.parse(_amountController.text),
          //   value.user!.uid,
          //   _usernameController.text.toLowerCase(),
          //   _authMethods.currentUser()!.uid,
          // );

          Navigator.pop(context);
        }).catchError((err) {
          _btnController.reset();
          VxToast.show(context, msg: err.toString());
        });
      }
    } else {
      _btnController.reset();
      VxToast.show(context, msg: 'Fields cannot be empty');
    }
  }

  @override
  void initState() {
    _storage.getType().then((value) {
      setState(() {
        type = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Create New User'.text.make(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              'Create a New User for Crypto Future Trade Mini'
                  .text
                  .bold
                  .color(Theme.of(context).primaryColor)
                  .size(22)
                  .make(),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                controller: _nameController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                controller: _usernameController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
              ),
              RoundedLoadingButton(
                child: 'Create'.text.make(),
                controller: _btnController,
                onPressed: () => _createUser(),
                color: Theme.of(context).primaryColor,
              ).pSymmetric(v: 10)
            ],
          ).p16(),
        ),
      ),
    );
  }
}
