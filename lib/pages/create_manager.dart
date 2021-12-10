import 'package:admin_mini/methods/auth_methods.dart';
import 'package:admin_mini/methods/db_methods.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateManager extends StatefulWidget {
  const CreateManager({Key? key}) : super(key: key);

  @override
  _CreateManagerState createState() => _CreateManagerState();
}

class _CreateManagerState extends State<CreateManager> {
  final AuthMethods _authMethods = AuthMethods();
  final DbMethods _dbMethods = DbMethods();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  _createManager() {
    if (_nameController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _amountController.text.isNotEmpty) {
      _authMethods
          .register(
              _usernameController.text.toLowerCase(), _passwordController.text)
          .then((value) {
        _dbMethods.addManager(
            _nameController.text.toLowerCase(),
            _emailController.text.toLowerCase(),
            _passwordController.text,
            num.parse(_amountController.text),
            value.user!.uid,
            _usernameController.text.toLowerCase());

        Navigator.pop(context);
      }).catchError((err) {
        _btnController.reset();
        VxToast.show(context, msg: err.toString());
      });
    } else {
      _btnController.reset();
      VxToast.show(context, msg: 'Fields cannot be empty');
    }
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
                onPressed: () => _createManager(),
                color: Theme.of(context).primaryColor,
              ).pSymmetric(v: 10)
            ],
          ).p16(),
        ),
      ),
    );
  }
}
