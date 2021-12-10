import 'package:admin_mini/methods/db_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class Search extends StatefulWidget {
  const Search({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _SearchState createState() => _SearchState();
}

// Test txn id - 401814699f89459492d51b7465a84710

class _SearchState extends State<Search> {
  final TextEditingController _txnIdController = TextEditingController();
  final DbMethods _dbMethods = DbMethods();

  String searchKey = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Search By TXN Id'.text.make(),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              label: 'Transaction Id'.text.make(),
            ),
            controller: _txnIdController,
            onChanged: (value) {
              setState(() {
                searchKey = value;
              });
            },
          ).pOnly(bottom: 10),
          Flexible(
            child: StreamBuilder(
              stream: _dbMethods.searchTxnId(searchKey, widget.uid),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> history = [];

                  for (var element in snapshot.data!.docs) {
                    history.add(element.data() as Map<String, dynamic>);
                  }

                  print(history);

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                history[index]['pair']
                                    .toString()
                                    .split('-')[0]
                                    .text
                                    .bold
                                    .size(25)
                                    .white
                                    .make(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    DateFormat.yMMMd()
                                        .add_jms()
                                        .format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                history[index]['at'] * 1000))
                                        .toString()
                                        .text
                                        .white
                                        .make(),
                                    Row(
                                      children: [
                                        'Expiry: '.text.white.bold.make(),
                                        history[index]['currentExp'] != null
                                            ? DateFormat.yMMMd()
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        history[index][
                                                                    'currentExp']
                                                                .seconds *
                                                            1000))
                                                .toString()
                                                .text
                                                .white
                                                .make()
                                            : DateFormat.yMMMd()
                                                .add_jms()
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        history[index]['futExp']
                                                                .seconds *
                                                            1000))
                                                .toString()
                                                .text
                                                .white
                                                .make(),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                'Txn Id: '.text.bold.white.make(),
                                history[index]['transactionId']
                                    .toString()
                                    .text
                                    .white
                                    .make(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                history[index]['bp']
                                    .toString()
                                    .text
                                    .bold
                                    .white
                                    .size(22)
                                    .make(),
                                history[index]['ap']
                                    .toString()
                                    .text
                                    .bold
                                    .white
                                    .size(22)
                                    .make(),
                              ],
                            ).py8(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    history[index]['lotSize']
                                        .toString()
                                        .text
                                        .bold
                                        .white
                                        .italic
                                        .make(),
                                    'Lot Size'.text.white.bold.make()
                                  ],
                                ),
                                Column(
                                  children: [
                                    history[index]['margin']
                                        .toString()
                                        .text
                                        .bold
                                        .white
                                        .italic
                                        .make(),
                                    'Margin'.text.white.bold.make()
                                  ],
                                ),
                                Column(
                                  children: [
                                    double.parse(
                                            history[index]['pl'].toString())
                                        .toStringAsFixed(2)
                                        .text
                                        .white
                                        .bold
                                        .italic
                                        .make(),
                                    'Profit/Loss'.text.white.bold.make()
                                  ],
                                )
                              ],
                            ).py8(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    history[index]['o']
                                        .toString()
                                        .text
                                        .bold
                                        .white
                                        .italic
                                        .make(),
                                    'Open'.text.bold.white.make()
                                  ],
                                ),
                                Column(
                                  children: [
                                    history[index]['h']
                                        .toString()
                                        .text
                                        .bold
                                        .white
                                        .italic
                                        .make(),
                                    'High'.text.bold.white.make()
                                  ],
                                ),
                                Column(
                                  children: [
                                    history[index]['l']
                                        .toString()
                                        .text
                                        .bold
                                        .white
                                        .italic
                                        .make(),
                                    'Low'.text.bold.white.make()
                                  ],
                                ),
                                Column(
                                  children: [
                                    history[index]['c']
                                        .toString()
                                        .text
                                        .bold
                                        .white
                                        .italic
                                        .make(),
                                    'Close'.text.bold.white.make()
                                  ],
                                )
                              ],
                            ).py8()
                          ],
                        ).p12().backgroundColor(index % 2 == 0
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).backgroundColor),
                      );
                    },
                  );
                }

                return ''.text.make();
              },
            ),
          )
        ],
      ).p16(),
    );
  }
}
