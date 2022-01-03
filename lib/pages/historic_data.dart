import 'dart:convert';

import 'package:admin_mini/methods/api.dart';
import 'package:admin_mini/models/historic_model.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class HistoricData extends StatefulWidget {
  const HistoricData({Key? key, required this.pair}) : super(key: key);

  final String pair;

  @override
  _HistoricDataState createState() => _HistoricDataState();
}

class _HistoricDataState extends State<HistoricData>
    with SingleTickerProviderStateMixin {
  final API _api = API();

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  TabController? _tabController;

  String from = '';
  String to = '';
  String timespan = '';

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Historic Data (${widget.pair})'.text.make(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(01 - 01 - 2021),
                              lastDate: DateTime.now())
                          .then((value) {
                        setState(() {
                          from = value.toString().split(' ')[0];
                          // print(from);
                        });
                      });
                    },
                    decoration: InputDecoration(
                      label: 'From'.text.make(),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    controller: _fromController..text = from,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: TextFormField(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(01 - 01 - 2021),
                              lastDate: DateTime.now())
                          .then((value) {
                        setState(() {
                          to = value.toString().split(' ')[0];
                          // print(to);
                        });
                      });
                    },
                    decoration: InputDecoration(
                      label: 'To'.text.make(),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    controller: _toController..text = to,
                  ),
                ),
              ],
            ),
            DropdownButtonFormField(
              hint: 'Timespan'.text.make(),
              items: [
                'minute',
                'hour',
                'day',
                'week',
                'month',
                'quarter',
                'year'
              ]
                  .map((e) => DropdownMenuItem(
                      child: e.allWordsCapitilize().text.make(),
                      value: e.toString()))
                  .toList(),
              onChanged: (value) {
                // print(value);
                setState(() {
                  timespan = value.toString();
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: 'Historic Data'.text.make(),
                ),
                Tab(
                  child: 'Candles'.text.make(),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .6,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (from.isEmptyOrNotNull &&
                      to.isEmptyOrNotNull &&
                      timespan.isEmptyOrNotNull)
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          '${widget.pair} OHLC rates with time'
                              .text
                              .bold
                              .size(20)
                              .make()
                              .py16(),
                          FutureBuilder(
                            future: _api.getHistoricData(
                                widget.pair, from, to, timespan),
                            builder:
                                (context, AsyncSnapshot<Response> snapshot) {
                              if (snapshot.hasData) {
                                // print(snapshot.data!.body);

                                Map<String, dynamic> data =
                                    jsonDecode(snapshot.data!.body);
                                List hData = data['results'];
                                List<HistoricModel> history = [];

                                for (var element in hData) {
                                  HistoricModel _h =
                                      HistoricModel.fromMap(element);

                                  history.add(_h);
                                }

                                // print(history);

                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .7,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: history.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: Column(
                                          children: [
                                            DateFormat.MMMEd()
                                                .add_jms()
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        history[index].t))
                                                .text
                                                .white
                                                .bold
                                                .make()
                                                .objectCenterRight()
                                                .py8(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    history[index]
                                                        .o
                                                        .toStringAsFixed(2)
                                                        .text
                                                        .white
                                                        .size(16)
                                                        .make(),
                                                    'Open '
                                                        .text
                                                        .white
                                                        .bold
                                                        .size(16)
                                                        .make(),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    history[index]
                                                        .h
                                                        .toStringAsFixed(2)
                                                        .text
                                                        .white
                                                        .size(16)
                                                        .make(),
                                                    'High '
                                                        .text
                                                        .white
                                                        .bold
                                                        .size(16)
                                                        .make(),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    history[index]
                                                        .l
                                                        .toStringAsFixed(2)
                                                        .text
                                                        .white
                                                        .size(16)
                                                        .make(),
                                                    'Low '
                                                        .text
                                                        .white
                                                        .bold
                                                        .size(16)
                                                        .make(),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    history[index]
                                                        .c
                                                        .toStringAsFixed(2)
                                                        .text
                                                        .white
                                                        .size(16)
                                                        .make(),
                                                    'Close '
                                                        .text
                                                        .white
                                                        .bold
                                                        .size(16)
                                                        .make(),
                                                  ],
                                                )
                                              ],
                                            ).p(5),
                                          ],
                                        ).p8().backgroundColor(index % 2 == 0
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .backgroundColor),
                                      );
                                    },
                                  ),
                                );
                              }

                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  else
                    'Please Select a from and to date and a timespan'
                        .text
                        .size(28)
                        .align(TextAlign.center)
                        .make()
                        .py64(),
                  Column(
                    children: [
                      'Candles Data from API per minute'
                          .text
                          .bold
                          .size(20)
                          .make()
                          .py16(),
                      AspectRatio(
                        aspectRatio: 1,
                        child: FutureBuilder(
                          future: _api.getHistoricData(
                              widget.pair, from, to, 'minute'),
                          builder: (context, AsyncSnapshot<Response> snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> data =
                                  jsonDecode(snapshot.data!.body);
                              List hData = data['results'];
                              List<HistoricModel> history = [];

                              for (var element in hData) {
                                HistoricModel _h =
                                    HistoricModel.fromMap(element);

                                history.add(_h);
                              }

                              return Candlesticks(
                                candles: history
                                    .map((e) => Candle(
                                          date: DateTime
                                              .fromMillisecondsSinceEpoch(e.t),
                                          high: double.parse(e.h.toString()),
                                          low: double.parse(e.l.toString()),
                                          open: double.parse(e.o.toString()),
                                          close: double.parse(e.c.toString()),
                                          volume: double.parse(e.v.toString()),
                                        ))
                                    .toList(),
                                onIntervalChange: (p0) {
                                  return p();
                                },
                                interval: 'min',
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ).p12(),
      ),
    );
  }

  p() {
    debugPrint('print');
  }
}
