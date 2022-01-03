import 'dart:convert';

import 'package:admin_mini/methods/api.dart';
import 'package:admin_mini/methods/db_methods.dart';
import 'package:admin_mini/models/coin_model.dart';
import 'package:admin_mini/models/user_model.dart';
import 'package:admin_mini/utils/calcs_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class BottomWidget extends StatefulWidget {
  const BottomWidget({Key? key, required this.trade, required this.uid})
      : super(key: key);

  final Map<String, dynamic> trade;
  final String uid;

  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  final API _api = API();
  final Calcs _calcs = Calcs();
  final DbMethods _dbMethods = DbMethods();

  TextEditingController? _lotController;
  TextEditingController? _priceController;

  UserModel? user;

  @override
  void initState() {
    _lotController =
        TextEditingController(text: widget.trade['quantity'].toString());
    _priceController = widget.trade['trade'].toString() == 'buy'
        ? TextEditingController(text: widget.trade['ap'].toString())
        : TextEditingController(text: widget.trade['bp'].toString());

    _dbMethods.getUserData(widget.uid).listen((event) {
      user = UserModel.fromMap(event.data() as Map<String, dynamic>);
    });

    // print(user);

    super.initState();
  }

  @override
  void dispose() {
    _api.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _api.getSpecificCoinData(widget.trade['pair']),
        builder: (context, AsyncSnapshot snapshot) {
          // print(snapshot.data);

          if (snapshot.hasData) {
            List data = jsonDecode(snapshot.data);
            CoinModel _coinModel = CoinModel.fromMap(data.asMap()[0]);
            // print(_coinModel);

            return SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      widget.trade['logo'],
                    ).pOnly(right: 10).wh(50, 50),
                    widget.trade['pair'].toString().text.bold.size(24).make(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        'Expiry: '.text.bold.make(),
                        widget.trade['currentExp'] == null
                            ? DateFormat.yMMMd()
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    widget.trade['futExp'].seconds * 1000))
                                .toString()
                                .text
                                .bold
                                .make()
                            : DateFormat.yMMMd()
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    widget.trade['currentExp'].seconds * 1000))
                                .toString()
                                .text
                                .bold
                                .make()
                      ],
                    ),
                    DateFormat.yMMMd()
                        .add_jms()
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            widget.trade['at']))
                        .toString()
                        .text
                        .bold
                        .make(),
                  ],
                ).pSymmetric(v: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _coinModel.bp < _coinModel.ap
                        ? _coinModel.bp
                            .toString()
                            .text
                            .bold
                            .italic
                            .size(24)
                            .color(Theme.of(context).primaryColor)
                            .make()
                        : _coinModel.ap
                            .toString()
                            .text
                            .bold
                            .italic
                            .size(24)
                            .color(Theme.of(context).primaryColor)
                            .make(),
                    _coinModel.ap > _coinModel.bp
                        ? _coinModel.ap
                            .toString()
                            .text
                            .bold
                            .italic
                            .size(24)
                            .color(Theme.of(context).primaryColor)
                            .make()
                        : _coinModel.bp
                            .toString()
                            .text
                            .bold
                            .italic
                            .size(24)
                            .color(Theme.of(context).primaryColor)
                            .make()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        _calcs.calcPlSqOff(widget.trade, _coinModel) > 0
                            ? double.parse(_calcs
                                    .calcPlSqOff(widget.trade, _coinModel)
                                    .toString())
                                .toStringAsFixed(2)
                                .text
                                .green600
                                .capitalize
                                .bold
                                .size(16)
                                .make()
                            : double.parse(_calcs
                                    .calcPlSqOff(widget.trade, _coinModel)
                                    .toString())
                                .toStringAsFixed(2)
                                .text
                                .red600
                                .capitalize
                                .bold
                                .size(16)
                                .make(),
                        'Profit/Loss: '.text.bold.make(),
                      ],
                    ),
                    Column(
                      children: [
                        widget.trade['lotSize']
                            .toString()
                            .text
                            .bold
                            .size(16)
                            .italic
                            .make(),
                        'Lot Size'.text.bold.size(16).make()
                      ],
                    ),
                    Column(
                      children: [
                        widget.trade['margin']
                            .toString()
                            .text
                            .bold
                            .size(16)
                            .italic
                            .make(),
                        'Margin'.text.bold.size(16).make()
                      ],
                    ),
                  ],
                ).py8(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        widget.trade['o']
                            .toString()
                            .text
                            .bold
                            .size(16)
                            .italic
                            .make(),
                        'Open'.text.bold.size(16).make()
                      ],
                    ),
                    Column(
                      children: [
                        widget.trade['h']
                            .toString()
                            .text
                            .bold
                            .size(16)
                            .italic
                            .make(),
                        'High'.text.bold.size(16).make()
                      ],
                    ),
                    Column(
                      children: [
                        widget.trade['l']
                            .toString()
                            .text
                            .bold
                            .size(16)
                            .italic
                            .make(),
                        'Low'.text.bold.size(16).make()
                      ],
                    ),
                    Column(
                      children: [
                        widget.trade['c']
                            .toString()
                            .text
                            .bold
                            .size(16)
                            .italic
                            .make(),
                        'Close'.text.bold.size(16).make()
                      ],
                    ),
                  ],
                ).py8(),
                Column(
                  children: [
                    widget.trade['trade'] == 'buy'
                        ? TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.price_check_outlined),
                              border: OutlineInputBorder(),
                              labelText: 'Buy',
                            ),
                            keyboardType: TextInputType.number,
                            controller: _priceController,
                          ).py8().px4()
                        : TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.price_check_outlined),
                              border: OutlineInputBorder(),
                              labelText: 'Sell',
                            ),
                            keyboardType: TextInputType.number,
                            controller: _priceController,
                          ).py8().px4(),
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.price_check_outlined),
                        border: OutlineInputBorder(),
                        labelText: 'Lots (Quantity)',
                      ),
                      enabled: false,
                      keyboardType: TextInputType.number,
                      controller: _lotController,
                    ).py8().px4(),
                  ],
                ).pSymmetric(v: 10),
                widget.trade['trade'] == 'buy'
                    ? ElevatedButton(
                        onPressed: () {
                          if (widget.trade['currentExp'] != null) {
                            _dbMethods
                                .sqOffSell(
                                    _coinModel,
                                    widget.trade,
                                    widget.uid,
                                    _calcs.calcPlSqOff(
                                        widget.trade, _coinModel))
                                .then((value) {
                              _dbMethods.updateTradeDelete(
                                  num.parse(_priceController!.text),
                                  user!,
                                  widget.trade['margin'],
                                  widget.trade['lotSize']);

                              Navigator.pop(context);
                              VxToast.show(context,
                                  msg: 'Trade Completed Successfully');
                            }).catchError((err) {
                              VxToast.show(context,
                                  msg: 'Something went wrong');
                            });
                          } else {
                            _dbMethods
                                .sqOffSellFut(
                                    _coinModel,
                                    widget.trade,
                                    widget.uid,
                                    _calcs.calcPlSqOff(
                                        widget.trade, _coinModel))
                                .then((value) {
                              _dbMethods.updateTradeDelete(
                                  num.parse(_priceController!.text),
                                  user!,
                                  widget.trade['margin'],
                                  widget.trade['lotSize']);

                              Navigator.pop(context);
                              VxToast.show(context,
                                  msg: 'Trade Completed Successfully');
                            }).catchError((err) {
                              VxToast.show(context,
                                  msg: 'Something went wrong');
                            });
                          }
                        },
                        child: 'Sell'.text.bold.size(20).make(),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Vx.red600)),
                      ).wPCT(context: context, widthPCT: 100).px4().h(50)
                    : ElevatedButton(
                        onPressed: () {
                          if (widget.trade['currentExp'] != null) {
                            _dbMethods
                                .sqOffBuy(
                                    _coinModel,
                                    widget.trade,
                                    widget.uid,
                                    _calcs.calcPlSqOff(
                                        widget.trade, _coinModel))
                                .then((value) {
                              _dbMethods.updateTradeDelete(
                                  num.parse(_priceController!.text),
                                  user!,
                                  widget.trade['margin'],
                                  widget.trade['lotSize']);

                              Navigator.pop(context);
                              VxToast.show(context,
                                  msg: 'Trade Completed Successfully');
                            }).catchError((err) {
                              VxToast.show(context,
                                  msg: 'Something went wrong');
                            });
                          } else {
                            _dbMethods
                                .sqOffBuyFut(
                                    _coinModel,
                                    widget.trade,
                                    widget.uid,
                                    _calcs.calcPlSqOff(
                                        widget.trade, _coinModel))
                                .then((value) {
                              _dbMethods.updateTradeDelete(
                                  num.parse(_priceController!.text),
                                  user!,
                                  widget.trade['margin'],
                                  widget.trade['lotSize']);

                              Navigator.pop(context);
                              VxToast.show(context,
                                  msg: 'Trade Completed Successfully');
                            }).catchError((err) {
                              VxToast.show(context,
                                  msg: 'Something went wrong');
                            });
                          }
                        },
                        child: 'Buy'.text.bold.size(20).make(),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Vx.blue600)),
                      ).wPCT(context: context, widthPCT: 100).px4().h(50),
                ElevatedButton(
                  onPressed: () {
                    if (_priceController!.text.isNotEmpty ||
                        num.parse(_priceController!.text) <= 0) {
                      _dbMethods
                          .updatePrice(widget.uid,
                              num.parse(_priceController!.text), widget.trade)
                          .then((value) {
                        Navigator.pop(context);
                        VxToast.show(context,
                            msg: 'Price Successfully Updated');
                      }).catchError((err) {
                        VxToast.show(context, msg: err.toString());
                      });
                    } else {
                      VxToast.show(context,
                          msg: 'Price Field cannot be empty or negative');
                    }
                  },
                  child: 'Update'.text.bold.size(20).make(),
                )
                    .wPCT(context: context, widthPCT: 100)
                    .h(50)
                    .pSymmetric(h: 4, v: 5)
              ],
            ).p16());
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
