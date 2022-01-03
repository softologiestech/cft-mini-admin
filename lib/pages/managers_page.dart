import 'package:admin_mini/methods/db_methods.dart';
import 'package:admin_mini/models/manager_model.dart';
import 'package:admin_mini/widgets/managerlist_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Managers extends StatefulWidget {
  const Managers({Key? key}) : super(key: key);

  @override
  _ManagersState createState() => _ManagersState();
}

class _ManagersState extends State<Managers> {
  final DbMethods _dbMethods = DbMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Managers'.text.make(),
      ),
      body: StreamBuilder(
        stream: _dbMethods.getAllManagers(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<ManagerModel> managers = [];

            for (var element in snapshot.data!.docs) {
              ManagerModel _managerModel =
                  ManagerModel.fromMap(element.data() as Map<String, dynamic>);

              managers.add(_managerModel);
            }

            // print(managers);

            return ManagerList(managers: managers);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
