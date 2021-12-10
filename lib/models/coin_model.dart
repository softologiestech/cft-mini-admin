import 'dart:convert';

class CoinModel {
  String ev;
  String pair;
  num lp;
  num ls;
  num bp;
  num bs;
  num ap;
  num as;
  num t;
  num x;
  num r;

  CoinModel({
    required this.ev,
    required this.pair,
    required this.lp,
    required this.ls,
    required this.bp,
    required this.bs,
    required this.ap,
    required this.as,
    required this.t,
    required this.x,
    required this.r,
  });

  CoinModel copyWith({
    String? ev,
    String? pair,
    num? lp,
    num? ls,
    num? bp,
    num? bs,
    num? ap,
    num? as,
    num? t,
    num? x,
    num? r,
  }) {
    return CoinModel(
      ev: ev ?? this.ev,
      pair: pair ?? this.pair,
      lp: lp ?? this.lp,
      ls: ls ?? this.ls,
      bp: bp ?? this.bp,
      bs: bs ?? this.bs,
      ap: ap ?? this.ap,
      as: as ?? this.as,
      t: t ?? this.t,
      x: x ?? this.x,
      r: r ?? this.r,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ev': ev,
      'pair': pair,
      'lp': lp,
      'ls': ls,
      'bp': bp,
      'bs': bs,
      'ap': ap,
      'as': as,
      't': t,
      'x': x,
      'r': r,
    };
  }

  factory CoinModel.fromMap(Map<String, dynamic> map) {
    return CoinModel(
      ev: map['ev'],
      pair: map['pair'],
      lp: map['lp'],
      ls: map['ls'],
      bp: map['bp'],
      bs: map['bs'],
      ap: map['ap'],
      as: map['as'],
      t: map['t'],
      x: map['x'],
      r: map['r'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CoinModel.fromJson(String source) =>
      CoinModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CoinModel(ev: $ev, pair: $pair, lp: $lp, ls: $ls, bp: $bp, bs: $bs, ap: $ap, as: $as, t: $t, x: $x, r: $r)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoinModel &&
        other.ev == ev &&
        other.pair == pair &&
        other.lp == lp &&
        other.ls == ls &&
        other.bp == bp &&
        other.bs == bs &&
        other.ap == ap &&
        other.as == as &&
        other.t == t &&
        other.x == x &&
        other.r == r;
  }

  @override
  int get hashCode {
    return ev.hashCode ^
        pair.hashCode ^
        lp.hashCode ^
        ls.hashCode ^
        bp.hashCode ^
        bs.hashCode ^
        ap.hashCode ^
        as.hashCode ^
        t.hashCode ^
        x.hashCode ^
        r.hashCode;
  }
}
