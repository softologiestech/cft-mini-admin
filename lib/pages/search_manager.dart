import 'package:admin_mini/methods/db_methods.dart';
import 'package:admin_mini/models/manager_model.dart';
import 'package:admin_mini/widgets/managerlist_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchManager extends StatefulWidget {
  const SearchManager({Key? key}) : super(key: key);

  @override
  _SearchManagerState createState() => _SearchManagerState();
}

class _SearchManagerState extends State<SearchManager> {
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
              border:
                  const OutlineInputBorder(borderSide: BorderSide(width: 1)),
            ),
            controller: _usernameController,
            onChanged: (value) {
              setState(() {
                searchKey = value;
              });
            },
          ),
          StreamBuilder(
            stream: _dbMethods.searchManager(searchKey),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<ManagerModel> managers = [];

                for (var element in snapshot.data!.docs) {
                  ManagerModel _managerModel = ManagerModel.fromMap(
                      element.data() as Map<String, dynamic>);

                  managers.add(_managerModel);
                }

                // print(users);

                return Flexible(child: ManagerList(managers: managers));
              }

              return ''.text.make();
            },
          ),
        ],
      ).p12(),
    );
  }
}
