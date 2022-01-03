import 'package:admin_mini/methods/db_methods.dart';
import 'package:admin_mini/models/manager_model.dart';
import 'package:admin_mini/pages/manager_users.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ManagerList extends StatefulWidget {
  const ManagerList({Key? key, required this.managers}) : super(key: key);

  final List<ManagerModel> managers;

  @override
  _ManagerListState createState() => _ManagerListState();
}

class _ManagerListState extends State<ManagerList> {
  final DbMethods _dbMethods = DbMethods();

  final TextEditingController _amountController = TextEditingController();

  _bottomSheet(ManagerModel manager) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: 'Add Margin'.text.size(16).make(),
              leading: const Icon(
                Icons.monetization_on_outlined,
                color: Vx.blue600,
              ),
              onTap: () {
                Navigator.pop(context);
                _addMarginBottomSheet(manager);
              },
            ),
            ListTile(
              title: 'Withdraw Margin'.text.size(16).make(),
              leading: const Icon(
                Icons.monetization_on_outlined,
                color: Vx.red600,
              ),
              onTap: () {
                Navigator.pop(context);
                _withdrawMarginBottomSheet(manager);
              },
            ),
            ListTile(
              title: 'View Users'.text.size(16).make(),
              leading: const Icon(
                Icons.people,
                color: Vx.green600,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManagerUsers(
                              uid: manager.uid,
                            )));
              },
            ),
            ListTile(
              title: 'Delete Manager'.text.size(16).make(),
              leading: const Icon(
                Icons.delete,
                color: Vx.red600,
              ),
              // onTap: () => _authMethods.deleteUser(manager.uid).then((value) {
              //   // debugPrint(value.body);

              //   Navigator.pop(context);
              // }),
            ),
          ],
        );
      },
    );
  }

  _addMarginBottomSheet(ManagerModel manager) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              'Add Amount to Wallet'
                  .text
                  .bold
                  .size(20)
                  .make()
                  .pOnly(bottom: 10),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                controller: _amountController,
              ).py8().px4(),
              ElevatedButton(
                onPressed: () {
                  if (_amountController.text.isNotEmpty) {
                    _dbMethods
                        .addAmountToManager(
                            num.parse(_amountController.text), manager)
                        .then((value) {
                      _amountController.clear();
                      VxToast.show(context, msg: 'Margin Successfuly Added');
                      Navigator.pop(context);
                    }).catchError((err) {
                      VxToast.show(context, msg: 'Something went wrong');
                    });
                  } else {
                    VxToast.show(context, msg: 'Margin cannot be empty');
                  }
                },
                child: 'Add Margin'.text.bold.size(20).make(),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Vx.blue600)),
              ).wPCT(context: context, widthPCT: 100).px4().h(50)
            ],
          ).p16(),
        );
      },
    );
  }

  _withdrawMarginBottomSheet(ManagerModel manager) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              'Withdraw Amount from Wallet'
                  .text
                  .bold
                  .size(20)
                  .make()
                  .pOnly(bottom: 10),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                controller: _amountController,
              ).py8().px4(),
              ElevatedButton(
                onPressed: () {
                  if (_amountController.text.isNotEmpty) {
                    _dbMethods
                        .withdrawAmountFromManager(
                            num.parse(_amountController.text), manager)
                        .then((value) {
                      _amountController.clear();
                      VxToast.show(context, msg: 'Withdraw Successful');
                      Navigator.pop(context);
                    }).catchError((err) {
                      VxToast.show(context, msg: 'Something went wrong');
                    });
                  } else {
                    VxToast.show(context, msg: 'Amount cannot be empty');
                  }
                },
                child: 'Withdraw Margin'.text.bold.size(20).make(),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Vx.red600)),
              ).wPCT(context: context, widthPCT: 100).px4().h(50)
            ],
          ).p16(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.managers.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _bottomSheet(widget.managers[index]),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.managers[index].name.text.bold.white.capitalize
                          .size(20)
                          .make(),
                      widget.managers[index].email.text.white.make(),
                    ],
                  ),
                  ('Amount : ' +
                          widget.managers[index].amount.toStringAsFixed(2))
                      .text
                      .bold
                      .white
                      .make()
                      .pSymmetric(v: 5)
                      .centered()
                ],
              ).p16().backgroundColor(index % 2 == 0
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).backgroundColor),
            ),
          ),
        );
      },
    );
  }
}
