import 'package:admin_mini/methods/db_methods.dart';
import 'package:admin_mini/models/user_model.dart';
import 'package:admin_mini/widgets/userlist_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ManagerUsers extends StatefulWidget {
  const ManagerUsers({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _ManagerUsersState createState() => _ManagerUsersState();
}

class _ManagerUsersState extends State<ManagerUsers> {
  final DbMethods _dbMethods = DbMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Users'.text.make(),
      ),
      body: StreamBuilder(
        stream: _dbMethods.getManagerUsers(widget.uid),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<UserModel> users = [];

            for (var element in snapshot.data!.docs) {
              UserModel _userModel =
                  UserModel.fromMap(element.data() as Map<String, dynamic>);

              users.add(_userModel);
            }

            return UserListWidget(users: users);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
