import 'package:admin_mini/methods/db_methods.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class HistoryEditWidget extends StatefulWidget {
  const HistoryEditWidget(
      {Key? key,
      required this.sell,
      required this.buy,
      required this.uid,
      required this.txnId,
      required this.datetime})
      : super(key: key);

  final String sell;
  final String buy;
  final String uid;
  final String txnId;
  final num datetime;

  @override
  _HistoryEditWidgetState createState() => _HistoryEditWidgetState();
}

class _HistoryEditWidgetState extends State<HistoryEditWidget> {
  final DbMethods _dbMethods = DbMethods();

  TextEditingController? _sellController;
  TextEditingController? _buyController;

  int? date;

  @override
  void initState() {
    _sellController = TextEditingController(text: widget.sell);
    _buyController = TextEditingController(text: widget.buy);

    date = int.parse(widget.datetime.toString()) * 1000;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Change Details'.text.bold.size(20).make(),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.fromMicrosecondsSinceEpoch(date!),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                ).then((value) {
                  // showTimePicker(
                  //         context: context,
                  //         initialTime: TimeOfDay.fromDateTime(
                  //             DateTime.fromMicrosecondsSinceEpoch(date!)))
                  //     .then((v) =>
                  //         print(v!.hour.milliseconds + v.minute.milliseconds));

                  setState(() {
                    date = value!.microsecondsSinceEpoch;
                  });
                });
              },
              child: DateFormat.yMMMd()
                  .add_jms()
                  .format(DateTime.fromMicrosecondsSinceEpoch(date!))
                  .toString()
                  .text
                  .make()
                  .objectCenterRight(),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                        label: 'Sell'.text.make(),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                    controller: _sellController,
                    keyboardType: TextInputType.number,
                  ).pSymmetric(h: 5),
                ),
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                        label: 'Buy'.text.make(),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                    controller: _buyController,
                    keyboardType: TextInputType.number,
                  ).pSymmetric(h: 5),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                    onPressed: () {
                      _dbMethods
                          .editBuySell(
                              widget.uid,
                              widget.txnId,
                              num.parse(_sellController!.text),
                              num.parse(_buyController!.text),
                              int.parse((date! / 1000).toStringAsFixed(0)))
                          .then((value) {
                        Navigator.pop(context);
                        VxToast.show(context, msg: 'Successfully Updated');
                      });
                    },
                    child: 'Update'.text.size(20).make())
                .wPCT(context: context, widthPCT: 100)
                .h(50),
          ],
        ).p12(),
      ),
    );
  }
}
