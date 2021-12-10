import 'package:admin_mini/utils/calcs_utils.dart';
import 'package:admin_mini/widgets/bottom_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class TradesWidget extends StatefulWidget {
  const TradesWidget(
      {Key? key, required this.trade, required this.uid, required this.index})
      : super(key: key);

  final Map<String, dynamic> trade;
  final String uid;
  final int index;

  @override
  _TradesWidgetState createState() => _TradesWidgetState();
}

class _TradesWidgetState extends State<TradesWidget> {
  final Calcs calcs = Calcs();

  _bottomSheet(Map<String, dynamic> trade) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BottomWidget(
            trade: trade,
            uid: widget.uid,
          ),
        );
      },
    );
  }

  // @override
  // void dispose() {
  //   _api.channel.sink.close();

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _bottomSheet(widget.trade),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.network(
                      widget.trade['logo'],
                      color: Vx.white,
                    ).pOnly(right: 10).wh(50, 50),
                    widget.trade['pair']
                        .toString()
                        .split('-')[0]
                        .text
                        .bold
                        .white
                        .size(24)
                        .make()
                        .p8(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        'Expiry: '.text.white.bold.white.make(),
                        widget.trade['currentExp'] == null
                            ? DateFormat.yMMMd()
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    widget.trade['futExp'].seconds * 1000))
                                .toString()
                                .text
                                .bold
                                .white
                                .make()
                            : DateFormat.yMMMd()
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    widget.trade['currentExp'].seconds * 1000))
                                .toString()
                                .text
                                .bold
                                .white
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
                        .white
                        .make(),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                widget.trade['trade'] == 'buy'
                    ? Row(
                        children: [
                          'Buy: '.text.bold.white.make(),
                          double.parse(widget.trade['ap'].toString())
                              .toStringAsFixed(2)
                              .text
                              .bold
                              .white
                              .italic
                              .size(24)
                              .make(),
                        ],
                      )
                    : Row(
                        children: [
                          'Sell: '.text.bold.white.make(),
                          double.parse(widget.trade['bp'].toString())
                              .toStringAsFixed(2)
                              .text
                              .bold
                              .white
                              .italic
                              .size(24)
                              .make(),
                        ],
                      ),
                Row(
                  children: [
                    'Trade: '.text.bold.white.make(),
                    widget.trade['trade'] == 'buy'
                        ? widget.trade['trade']
                            .toString()
                            .text
                            .white
                            .capitalize
                            .bold
                            .white
                            .make()
                        : widget.trade['trade']
                            .toString()
                            .text
                            .red600
                            .capitalize
                            .bold
                            .white
                            .make(),
                  ],
                )
                // widget.trade['trade'] == 'buy'
                //     ? widget.trade['currentExp'] != null
                //         ? coinModel.bp < coinModel.ap
                //             ? coinModel.bp
                //                 .toStringAsFixed(2)
                //                 .text
                //                 .bold
                //                 .white
                //                 .italic
                //                 .size(24)
                //                 .make()
                //             : coinModel.ap
                //                 .toStringAsFixed(2)
                //                 .text
                //                 .bold
                //                 .white
                //                 .italic
                //                 .size(24)
                //                 .make()
                //         : coinModel.bp > coinModel.ap
                //             ? calcs
                //                 .calcBp(coinModel.bp)
                //                 .toString()
                //                 .text
                //                 .bold
                //                 .white
                //                 .italic
                //                 .size(24)
                //                 .make()
                //             : calcs
                //                 .calcBp(coinModel.ap)
                //                 .toString()
                //                 .text
                //                 .bold
                //                 .white
                //                 .italic
                //                 .size(24)
                //                 .make()
                //     : widget.trade['currentExp'] != null
                //         ? coinModel.bp < coinModel.ap
                //             ? coinModel.bp
                //                 .toStringAsFixed(2)
                //                 .text
                //                 .bold
                //                 .white
                //                 .italic
                //                 .size(24)
                //                 .make()
                //             : coinModel.ap
                //                 .toStringAsFixed(2)
                //                 .text
                //                 .bold
                //                 .white
                //                 .italic
                //                 .size(24)
                //                 .make()
                //         : coinModel.bp > coinModel.ap
                //             ? calcs
                //                 .calcBp(coinModel.bp)
                //                 .toString()
                //                 .text
                //                 .bold
                //                 .white
                //                 .italic
                //                 .size(24)
                //                 .make()
                //             : calcs
                //                 .calcBp(coinModel.ap)
                //                 .toString()
                //                 .text
                //                 .bold
                //                 .white
                //                 .italic
                //                 .size(24)
                //                 .make(),
              ],
            ).py8(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     // Row(
            //     //   children: [
            //     //     'Profit/Loss: '.text.bold.white.make(),
            //     //     calcs.calcPlSqOff(widget.trade, coinModel) > 0
            //     //         ? double.parse(calcs
            //     //                 .calcPlSqOff(widget.trade, coinModel)
            //     //                 .toString())
            //     //             .toStringAsFixed(2)
            //     //             .text
            //     //             .green600
            //     //             .capitalize
            //     //             .bold
            //     //             .white
            //     //             .make()
            //     //         : double.parse(calcs
            //     //                 .calcPlSqOff(widget.trade, coinModel)
            //     //                 .toString())
            //     //             .toStringAsFixed(2)
            //     //             .text
            //     //             .red600
            //     //             .capitalize
            //     //             .bold
            //     //             .white
            //     //             .make(),
            //     //   ],
            //     // ),

            //   ],
            // ).py2(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    'Lot Size: '.text.bold.white.make(),
                    widget.trade['lotSize']
                        .toString()
                        .text
                        .bold
                        .white
                        .italic
                        .make(),
                  ],
                ),
                Row(
                  children: [
                    'Margin: '.text.bold.white.make(),
                    widget.trade['margin']
                        .toString()
                        .text
                        .bold
                        .white
                        .italic
                        .make(),
                  ],
                ),
                Row(
                  children: [
                    'Quantity: '.text.bold.white.make(),
                    widget.trade['quantity']
                        .toString()
                        .text
                        .bold
                        .white
                        .italic
                        .make(),
                  ],
                )
              ],
            ).py2(),
          ],
        ).p12().backgroundColor(widget.index % 2 == 0
            ? Theme.of(context).primaryColor
            : Theme.of(context).backgroundColor),
      ),
    );
  }
}
