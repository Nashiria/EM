// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class hz {
  int index;
  double value;
  hz(this.index, this.value);
}

class emClass {
  double dx = 1;
  double dt = 0.1;
  int N = 100;
  int halfN = 0;
  List<double> hzs = [];
  List<hz> hzClass = [];
  List<double> ey = [];
  List<List<double>> x = [];
  emClass() {
    dx = 1;
    dt = 0.1;
    N = 100;
    halfN = N ~/ 2;
    hzs = ones(N + 1, 0);
    ey = ones(N + 1, 0);
    ey[halfN] = 1;
    step();
  }
  Widget build(BuildContext context) {
    return new charts.LineChart(_createSampleData(), animate: false);
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<hz, int>> _createSampleData() {
    List<hz> data = [];
    for (int i = 0; i < hzs.length; i++) {
      data.add(hz(i, hzs[i]));
    }
    return [
      new charts.Series<hz, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (hz sales, _) => sales.index,
        measureFn: (hz sales, _) => sales.value,
        data: data,
      )
    ];
  }

  step() {
    hzs = hzUpdate(ey, hzs);
    ey = eyUpdate(ey, hzs);
  }

  double exp(double arg) {
    return 1 +
        arg *
            (1 +
                arg *
                    (1 / 2 +
                        arg *
                            (1 / 6 +
                                arg *
                                    (1 /
                                        24 *
                                        arg *
                                        (1 / 120 + arg * (1 / 720))))));
  }

  List<double> ones(int size, double fill) {
    return List<double>.filled(size, fill);
  }

  List<double> hzUpdate(List<double> ey, List<double> hz) {
    ey[0] = 0;
    ey[N] = 0;
    var hzTemp = ones(hz.length, 0);
    for (int i = 0; i < hz.length; i++) {
      int index = i + 1;
      if (index > hz.length - 1) {
        index = 0;
      }
      hzTemp[i] = hz[i] + (dt / dx) * (ey[index] - ey[i]);
    }
    return hzTemp;
  }

  List<double> eyUpdate(List<double> ey, List<double> hz) {
    hz[0] = 0;
    hz[N] = 0;
    var eyTemp = ones(ey.length, 0);
    for (int i = 1; i < ey.length; i++) {
      int index = i - 1;
      if (index < 0) {
        index = ey.length - 1;
      }
      eyTemp[i] = ey[i] + (dt / dx) * (hz[i] - hz[index]);
    }
    return eyTemp;
  }
}

class emScreen extends StatefulWidget {
  const emScreen({Key? key}) : super(key: key);
  @override
  State<emScreen> createState() => _emScreenState();
}

class _emScreenState extends State<emScreen> {
  late DateTime _initialTime;
  emClass em = emClass();
  late final Timer _timer;
  Duration _elapsed = Duration.zero;
  @override
  void initState() {
    super.initState();
    _initialTime = DateTime.now();
    _timer = Timer.periodic(Duration(milliseconds: 5), (_) {
      final now = DateTime.now();
      setState(() {
        em.step();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, body: Center(child: em.build(context)));
  }
}
