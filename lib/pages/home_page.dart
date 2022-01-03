import 'package:admin_mini/methods/auth_methods.dart';
import 'package:admin_mini/methods/db_methods.dart';
import 'package:admin_mini/methods/storage.dart';
import 'package:admin_mini/models/user_model.dart';
import 'package:admin_mini/pages/create_manager.dart';
import 'package:admin_mini/pages/create_page.dart';
import 'package:admin_mini/pages/login_page.dart';
import 'package:admin_mini/pages/managers_page.dart';
import 'package:admin_mini/pages/search_manager.dart';
import 'package:admin_mini/pages/search_user.dart';
import 'package:admin_mini/widgets/userlist_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Storage _storage = Storage();
  final DbMethods _dbMethods = DbMethods();
  final AuthMethods _authMethods = AuthMethods();

  String type = '';

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
    // print(type);

    return Scaffold(
      appBar: AppBar(
        title: 'Home'.text.make(),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  builder: (context) {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: 'Search User'.text.size(16).make(),
                          leading: const Icon(
                            Icons.person,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SearchUser()));
                          },
                        ),
                        type == 'admin'
                            ? ListTile(
                                title: 'Search Manager'.text.size(16).make(),
                                leading: const Icon(
                                  Icons.people,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SearchManager()));
                                },
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    builder: (context) {
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: 'Add User'.text.size(16).make(),
                            leading: const Icon(
                              Icons.person,
                              color: Vx.blue600,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Create()));
                            },
                          ),
                          type == 'admin'
                              ? ListTile(
                                  title: 'View Managers'.text.size(16).make(),
                                  leading: const Icon(
                                    Icons.person,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Managers()));
                                  },
                                )
                              : const SizedBox(
                                  height: 0,
                                ),
                          type == 'admin'
                              ? ListTile(
                                  title: 'Add Manager'.text.size(16).make(),
                                  leading: const Icon(
                                    Icons.people,
                                    color: Vx.green600,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CreateManager()));
                                  },
                                )
                              : const SizedBox(
                                  height: 0,
                                ),
                          ListTile(
                            title: 'Logout'.text.size(16).make(),
                            leading: const Icon(
                              Icons.logout,
                              color: Vx.red600,
                            ),
                            onTap: () {
                              _storage.clear();
                              _authMethods.logout();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()),
                                  (route) => false);
                            },
                          ),
                        ],
                      );
                    },
                  ),
              icon: const Icon(Icons.menu))
        ],
      ),
      body: StreamBuilder(
        stream: _dbMethods.getAllUsers(_authMethods.currentUser()!.uid, type),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<UserModel> users = [];

            for (var element in snapshot.data!.docs) {
              UserModel _userModel =
                  UserModel.fromMap(element.data() as Map<String, dynamic>);

              users.add(_userModel);
            }

            // print(users);

            return UserListWidget(users: users);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
