import 'package:admin_mini/methods/db_methods.dart';
import 'package:admin_mini/utils/calcs_utils.dart';
import 'package:admin_mini/widgets/trades_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Trades extends StatefulWidget {
  const Trades({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _TradesState createState() => _TradesState();
}

class _TradesState extends State<Trades> {
  final DbMethods _dbMethods = DbMethods();
  final Calcs calcs = Calcs();

  // _bottomSheet(Map<String, dynamic> trade) {
  //   showModalBottomSheet(
  //     enableDrag: true,
  //     context: context,
  //     builder: (context) {
  //       return Padding(
  //         padding:
  //             EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  //         child: BottomWidget(
  //           trade: trade,
  //           uid: widget.uid,
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Trades'.text.make(),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => Search(
        //                       uid: widget.uid,
        //                     )));
        //       },
        //       icon: const Icon(Icons.search)),
        // ],
      ),
      body: StreamBuilder(
        stream: _dbMethods.getUserTrades(widget.uid),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List trades = [];

            for (var element in snapshot.data!.docs) {
              trades.add(element.data() as Map<String, dynamic>);
            }

            // print(trades);

            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: trades.length,
              itemBuilder: (context, index) {
                return TradesWidget(
                    trade: trades[index], uid: widget.uid, index: index);
              },
            );
          } else {
            return Center(child: 'No Trades Yet!'.text.bold.size(20).make());
          }
        },
      ),
    );
  }
}
