import 'package:admin_mini/models/coin_model.dart';
import 'package:admin_mini/models/manager_model.dart';
import 'package:admin_mini/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class DbMethods {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var uuid = const Uuid();

  Future addUser(String name, String email, String password, num amount,
      String uid, String username, String createdBy) {
    return _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'username': username,
      'password': password,
      'uid': uid,
      'amount': amount,
      'equity': amount,
      'free_margin': amount,
      'margin': 0,
      'net_commission': 0,
      'commission': 1,
      'createdBy': createdBy
    });
  }

  Future addUserToManager(String name, String email, String password,
      num amount, String uid, String username, String managerUid) {
    return _db.doc('manager/$managerUid').collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'username': username,
      'password': password,
      'uid': uid,
      'amount': amount,
    });
  }

  Future addManager(String name, String email, String password, num amount,
      String uid, String username) {
    return _db.collection('manager').doc(uid).set({
      'name': name,
      'email': email,
      'username': username,
      'password': password,
      'uid': uid,
      'amount': amount,
      'equity': amount,
      'free_margin': amount,
      'margin': 0,
      'net_commission': 0,
      'commission': 1,
      'type': 'manager'
    });
  }

  Stream<QuerySnapshot> getAllUsers(String uid, String type) {
    if (type == 'admin') {
      return _db.collection('users').snapshots();
    } else {
      return _db
          .collection('users')
          .where('createdBy', isEqualTo: uid)
          .snapshots();

      // return _db.doc('manager/$uid').collection('users').snapshots();
    }
  }

  Stream<DocumentSnapshot> getUserData(String uid) {
    return _db.doc('users/$uid').snapshots();
  }

  Stream<QuerySnapshot> getUserTrades(String uid) {
    return _db.doc('users/$uid').collection('trades').snapshots();
  }

  Future sqOffBuy(
      CoinModel coinModel, Map<String, dynamic> trade, String uid, num pl) {
    return _db
        .doc('users/$uid')
        .collection('history')
        .doc(trade['transactionId'])
        .set({
      'pair': coinModel.pair,
      'ap': coinModel.ap,
      'bp': coinModel.bp,
      'at': DateTime.now().millisecondsSinceEpoch,
      'name': trade['name'],
      'margin': trade['margin'],
      'lotSize': trade['lotSize'],
      'o': trade['o'],
      'h': trade['h'],
      'l': trade['l'],
      'c': trade['c'],
      'pl': pl,
      'todaysChange': trade['todaysChange'],
      'todaysChangePerc': trade['todaysChangePerc'],
      'trade': 'buy',
      'logo': trade['logo'],
      'quantity': trade['quantity'],
      'transactionId': trade['transactionId'],
      'currentExp': trade['currentExp']
    }).then((value) {
      _db
          .doc('users/$uid')
          .collection('trades')
          .doc(trade['transactionId'])
          .delete();
    });
  }

  Future sqOffBuyFut(
      CoinModel coinModel, Map<String, dynamic> trade, String uid, num pl) {
    return _db
        .doc('users/$uid')
        .collection('history')
        .doc(trade['transactionId'])
        .set({
      'pair': coinModel.pair,
      'ap': coinModel.ap,
      'bp': coinModel.bp,
      'at': DateTime.now().millisecondsSinceEpoch,
      'name': trade['name'],
      'margin': trade['margin'],
      'lotSize': trade['lotSize'],
      'o': trade['o'],
      'h': trade['h'],
      'l': trade['l'],
      'c': trade['c'],
      'pl': pl,
      'todaysChange': trade['todaysChange'],
      'todaysChangePerc': trade['todaysChangePerc'],
      'trade': 'buy',
      'logo': trade['logo'],
      'quantity': trade['quantity'],
      'transactionId': trade['transactionId'],
      'futExp': trade['futExp']
    }).then((value) {
      _db
          .doc('users/$uid')
          .collection('trades')
          .doc(trade['transactionId'])
          .delete();
    });
  }

  Future sqOffSell(
      CoinModel coinModel, Map<String, dynamic> trade, String uid, num pl) {
    return _db
        .doc('users/$uid')
        .collection('history')
        .doc(trade['transactionId'])
        .set({
      'pair': coinModel.pair,
      'ap': coinModel.ap,
      'bp': coinModel.bp,
      'at': DateTime.now().millisecondsSinceEpoch,
      'name': trade['name'],
      'margin': trade['margin'],
      'lotSize': trade['lotSize'],
      'o': trade['o'],
      'h': trade['h'],
      'l': trade['l'],
      'c': trade['c'],
      'pl': pl,
      'todaysChange': trade['todaysChange'],
      'todaysChangePerc': trade['todaysChangePerc'],
      'trade': 'sell',
      'logo': trade['logo'],
      'quantity': trade['quantity'],
      'transactionId': trade['transactionId'],
      'currentExp': trade['currentExp']
    }).then((value) {
      _db
          .doc('users/$uid')
          .collection('trades')
          .doc(trade['transactionId'])
          .delete();
    });
  }

  Future sqOffSellFut(
      CoinModel coinModel, Map<String, dynamic> trade, String uid, num pl) {
    return _db
        .doc('users/$uid')
        .collection('history')
        .doc(trade['transactionId'])
        .set({
      'pair': coinModel.pair,
      'ap': coinModel.ap,
      'bp': coinModel.bp,
      'at': DateTime.now().millisecondsSinceEpoch,
      'name': trade['name'],
      'margin': trade['margin'],
      'lotSize': trade['lotSize'],
      'o': trade['o'],
      'h': trade['h'],
      'l': trade['l'],
      'c': trade['c'],
      'pl': pl,
      'todaysChange': trade['todaysChange'],
      'todaysChangePerc': trade['todaysChangePerc'],
      'trade': 'sell',
      'logo': trade['logo'],
      'quantity': trade['quantity'],
      'transactionId': trade['transactionId'],
      'futExp': trade['futExp']
    }).then((value) {
      _db
          .doc('users/$uid')
          .collection('trades')
          .doc(trade['transactionId'])
          .delete();
    });
  }

  Future updatePrice(String uid, num price, Map<String, dynamic> trade) {
    if (trade['trade'] == 'buy') {
      return _db
          .doc('users/$uid')
          .collection('trades')
          .doc(trade['transactionId'])
          .update({'ap': price});
    } else {
      return _db
          .doc('users/$uid')
          .collection('trades')
          .doc(trade['transactionId'])
          .update({'bp': price});
    }
  }

  Future addAmount(num amount, UserModel user) {
    return _db.doc('users/${user.uid}').update({
      'amount': user.amount + amount,
      'equity': user.equity + amount,
      'free_margin': user.free_margin + amount,
    });
  }

  Future withdrawAmount(num amount, UserModel user) {
    return _db.doc('users/${user.uid}').update({
      'amount': user.amount - amount,
      'equity': user.equity - amount,
      'free_margin': user.free_margin - amount,
    });
  }

  Future withdrawAmountFromManager(num amount, ManagerModel manager) {
    return _db.doc('manager/${manager.uid}').update({
      'amount': manager.amount - amount,
    });
  }

  Future addAmountToManager(num amount, ManagerModel manager) {
    return _db.doc('manager/${manager.uid}').update({
      'amount': manager.amount + amount,
    });
  }

  Future updateTradeDelete(
      num amount, UserModel user, num margin, num lotSize) {
    return _db.doc('users/${user.uid}').update({
      'amount': user.amount + amount,
      'equity': user.equity + amount,
      'free_margin': user.free_margin + amount,
      'margin': user.margin - (margin * lotSize)
    });
  }

  Stream<QuerySnapshot> searchTxnId(String txnId, String uid) {
    return _db
        .doc('users/$uid')
        .collection('history')
        .orderBy('transactionId')
        .startAt([txnId]).endAt([txnId + '\uf8ff']).snapshots();
  }

  Stream<QuerySnapshot> searchUser(String key) {
    return _db
        .collection('users')
        .orderBy('username')
        .startAt([key]).endAt([key + '\uf8ff']).snapshots();
  }

  Stream<QuerySnapshot> searchManager(String key) {
    return _db
        .collection('manager')
        .orderBy('username')
        .startAt([key]).endAt([key + '\uf8ff']).snapshots();
  }

  Stream<QuerySnapshot> getManagerUsers(String uid) {
    return _db
        .collection('users')
        .where('createdBy', isEqualTo: uid)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllManagers() {
    return _db.collection('manager').snapshots();
  }

  Future editBuySell(
      String uid, String txnId, num sell, num buy, int datetime) {
    return _db.doc('users/$uid').collection('history').doc(txnId).update({
      'bp': sell,
      'ap': buy,
      'at': datetime,
    });
  }

  Future disableUser(String uid) {
    return _db.doc('users/$uid').update({'isDisabled': true});
  }

  Future enableUser(String uid) {
    return _db.doc('users/$uid').update({'isDisabled': false});
  }
}
