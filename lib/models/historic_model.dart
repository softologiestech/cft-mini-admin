import 'dart:convert';

class HistoricModel {
  num c;
  num h;
  num l;
  num n;
  num o;
  num v;
  num vw;
  int t;

  HistoricModel({
    required this.c,
    required this.h,
    required this.l,
    required this.n,
    required this.o,
    required this.v,
    required this.vw,
    required this.t,
  });

  HistoricModel copyWith({
    num? c,
    num? h,
    num? l,
    num? n,
    num? o,
    num? v,
    num? vw,
    int? t,
  }) {
    return HistoricModel(
      c: c ?? this.c,
      h: h ?? this.h,
      l: l ?? this.l,
      n: n ?? this.n,
      o: o ?? this.o,
      v: v ?? this.v,
      vw: vw ?? this.vw,
      t: t ?? this.t,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'c': c,
      'h': h,
      'l': l,
      'n': n,
      'o': o,
      'v': v,
      'vw': vw,
      't': t,
    };
  }

  factory HistoricModel.fromMap(Map<String, dynamic> map) {
    return HistoricModel(
      c: map['c'] ?? 0,
      h: map['h'] ?? 0,
      l: map['l'] ?? 0,
      n: map['n'] ?? 0,
      o: map['o'] ?? 0,
      v: map['v'] ?? 0,
      vw: map['vw'] ?? 0,
      t: map['t']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoricModel.fromJson(String source) =>
      HistoricModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HistoricModel(c: $c, h: $h, l: $l, n: $n, o: $o, v: $v, vw: $vw, t: $t)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HistoricModel &&
        other.c == c &&
        other.h == h &&
        other.l == l &&
        other.n == n &&
        other.o == o &&
        other.v == v &&
        other.vw == vw &&
        other.t == t;
  }

  @override
  int get hashCode {
    return c.hashCode ^
        h.hashCode ^
        l.hashCode ^
        n.hashCode ^
        o.hashCode ^
        v.hashCode ^
        vw.hashCode ^
        t.hashCode;
  }
}
