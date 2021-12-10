import 'package:admin_mini/methods/auth_methods.dart';
import 'package:admin_mini/methods/db_methods.dart';
import 'package:admin_mini/models/user_model.dart';
import 'package:admin_mini/pages/trades_page.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class UserListWidget extends StatefulWidget {
  const UserListWidget({Key? key, required this.users}) : super(key: key);

  final List<UserModel> users;

  @override
  _UserListWidgetState createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  final AuthMethods _authMethods = AuthMethods();
  final DbMethods _dbMethods = DbMethods();

  final TextEditingController _amountController = TextEditingController();

  _bottomSheet(UserModel user) {
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
                _addMarginBottomSheet(user);
              },
            ),
            // ListTile(
            //   title: 'Withdraw Margin'.text.size(16).make(),
            //   leading: const Icon(
            //     Icons.monetization_on_outlined,
            //     color: Vx.blue600,
            //   ),
            //   onTap: () => {},
            // ),
            ListTile(
              title: 'View Trades'.text.size(16).make(),
              leading: const Icon(
                Icons.bar_chart_rounded,
                color: Vx.orange600,
              ),
              onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Trades(uid: user.uid)))
                  .then((value) => Navigator.pop(context)),
            ),
            ListTile(
              title: 'Delete User'.text.size(16).make(),
              leading: const Icon(
                Icons.delete,
                color: Vx.red600,
              ),
              onTap: () => _authMethods.deleteUser(user.uid).then((value) {
                // debugPrint(value.body);

                Navigator.pop(context);
              }),
            ),
          ],
        );
      },
    );
  }

  _addMarginBottomSheet(UserModel user) {
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
                        .addAmount(num.parse(_amountController.text), user)
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
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _bottomSheet(widget.users[index]),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.users[index].name.text.bold.white.capitalize
                        .size(20)
                        .make(),
                    widget.users[index].email.text.white.make(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ('A ' + widget.users[index].amount.toStringAsFixed(2))
                        .text
                        .bold
                        .white
                        .make(),
                    ('E ' + widget.users[index].equity.toStringAsFixed(2))
                        .text
                        .bold
                        .white
                        .make(),
                    ('M ' + widget.users[index].margin.toStringAsFixed(2))
                        .text
                        .bold
                        .white
                        .make()
                  ],
                ).pSymmetric(v: 5)
              ],
            ).p16().backgroundColor(index % 2 == 0
                ? Theme.of(context).primaryColor
                : Theme.of(context).backgroundColor),
          ),
        );
      },
    );
  }
}
