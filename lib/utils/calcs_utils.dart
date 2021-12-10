import 'package:admin_mini/models/coin_model.dart';

class Calcs {
  num pl = 0;

  calcBp(num bp) {
    return (bp - bp * 1 / 100).toStringAsFixed(2);
  }

  calcAp(num ap) {
    return (ap + ap * 1 / 100).toStringAsFixed(2);
  }

  calcPlSqOff(Map coinData, CoinModel coinModel) {
    num loss = 0;
    num profit = 0;

    if (coinData['trade'] == 'buy') {
      // Buy Loss
      if (coinData['ap'] > coinModel.bp) {
        loss = (coinModel.bp - coinData['ap']) *
            coinData['quantity'] *
            coinData['lotSize'];
      }
      // Buy Profit
      else if (coinData['ap'] < coinModel.bp) {
        profit = (coinModel.bp - coinData['ap']) *
            coinData['quantity'] *
            coinData['lotSize'];
      }
    } else if (coinData['trade'] == 'sell') {
      // Sell Loss
      if (coinData['bp'] > coinModel.ap) {
        loss = (coinData['bp'] - coinModel.ap) *
            coinData['quantity'] *
            coinData['lotSize'];
      }
      // Sell Profit
      else if (coinData['bp'] < coinModel.ap) {
        profit = (coinModel.ap - coinData['bp']) *
            coinData['quantity'] *
            coinData['lotSize'];
      }
    }

    return pl = loss == 0 ? profit : loss;

    // print(pl);
  }
}
