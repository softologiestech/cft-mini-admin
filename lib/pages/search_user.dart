import 'package:admin_mini/methods/db_methods.dart';
import 'package:admin_mini/models/user_model.dart';
import 'package:admin_mini/widgets/userlist_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final DbMethods _dbMethods = DbMethods();

  final TextEditingController _usernameController = TextEditingController();

  String searchKey = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Search User'.text.make(),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              label: 'Username'.text.make(),
            ),
            controller: _usernameController,
            onChanged: (value) {
              setState(() {
                searchKey = value;
              });
            },
          ),
          StreamBuilder(
            stream: _dbMethods.searchUser(searchKey),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<UserModel> users = [];

                for (var element in snapshot.data!.docs) {
                  UserModel _userModel =
                      UserModel.fromMap(element.data() as Map<String, dynamic>);

                  users.add(_userModel);
                }

                print(users);

                return Flexible(child: UserListWidget(users: users));
              }

              return ''.text.make();
            },
          ),
        ],
      ).p12(),
    );
  }
}
