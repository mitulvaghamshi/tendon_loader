import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tendon_loader/utils/bluetooth.dart';
import 'package:tendon_loader/utils/chart_data.dart';
import 'package:tendon_loader/utils/exercise_data.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key key, @required this.exerciseData})
      : assert(exerciseData != null, 'Exercise data required'),
        super(key: key);

  final ExerciseData exerciseData;

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  double _targetLoad;
  ExerciseData _exerciseData;
  List<ChartData> _targetLine;
  Bluetooth _bt = Bluetooth();
  Stopwatch _stopwatch = Stopwatch();
  ChartSeriesController _lineDataCtrl;
  ChartSeriesController _graphDataCtrl;
  List<ChartData> _measurement = [ChartData(weight: 0)];
  StreamController<double> _weightCtrl = StreamController<double>()..add(0);

  @override
  void initState() {
    super.initState();
    _exerciseData = widget.exerciseData;
    _targetLoad = _exerciseData.targetLoad;
    _targetLine = [ChartData(x: 0, weight: _targetLoad), ChartData(x: 2, weight: _targetLoad)];
    _bt.startNotify();
    _bt.listen(_getData);
  }

  @override
  void dispose() {
    if (!_weightCtrl.isClosed) _weightCtrl.close();
    _bt.stopNotify();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            StreamBuilder<int>(
              initialData: 0,
              stream: Stream.periodic(Duration(seconds: 1), (value) => (_stopwatch.elapsedMilliseconds ~/ 1000)),
              builder: (_, snapshot) {
                String _elapsedTime;
                if (snapshot.hasData) {
                  _elapsedTime =
                      '${(snapshot.data ~/ 60).toString().padLeft(2, '0')}:${(snapshot.data % 60).toString().padLeft(2, '0')}';
                }
                return Text(
                  'Time elapsed: $_elapsedTime',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
                );
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<double>(
              initialData: 0,
              stream: _weightCtrl.stream,
              builder: (_, snapshot) => Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: snapshot.data >= _targetLoad ? Colors.green : Colors.yellow,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                series: _getSeries(),
                plotAreaBorderWidth: 0,
                primaryXAxis: NumericAxis(minimum: 0, isVisible: false),
                primaryYAxis: NumericAxis(
                  maximum: 30,
                  labelFormat: '{value} kg',
                  axisLine: AxisLine(width: 0),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  heroTag: 'exercise-mode-start-btn',
                  child: const Icon(Icons.play_arrow_rounded),
                  onPressed: () async {
                    _stopwatch.start();
                    await _bt.startWeightMeas();
                  },
                ),
                FloatingActionButton(
                  heroTag: 'exercise-mode-stop-btn',
                  child: const Icon(Icons.stop_rounded),
                  onPressed: () async {
                    _stopwatch.stop();
                    await _bt.stopWeightMeas();
                  },
                ),
                FloatingActionButton(
                  heroTag: 'exercise-mode-reset-btn',
                  child: const Icon(Icons.replay_rounded),
                  onPressed: () async {
                    await _bt.stopWeightMeas();
                    _stopwatch.reset();
                    _weightCtrl.add(0);
                    _measurement.insert(0, const ChartData(weight: 0));
                    _lineDataCtrl.updateDataSource(updatedDataIndexes: [0, 1]);
                    _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<ChartSeries<ChartData, int>> _getSeries() {
    return <ChartSeries<ChartData, int>>[
      ColumnSeries<ChartData, int>(
        width: 0.9,
        color: Colors.blue,
        animationDuration: 0,
        dataSource: _measurement,
        xValueMapper: (data, _) => 1,
        yValueMapper: (data, _) => data.weight,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          showZeroValue: false,
          labelAlignment: ChartDataLabelAlignment.bottom,
          textStyle: const TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold),
        ),
        onRendererCreated: (controller) => _graphDataCtrl = controller,
        borderRadius: const BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20)),
      ),
      LineSeries<ChartData, int>(
        width: 5,
        color: Colors.red,
        animationDuration: 0,
        dataSource: _targetLine,
        xValueMapper: (data, _) => data.x,
        yValueMapper: (data, _) => data.weight,
        onRendererCreated: (controller) => _lineDataCtrl = controller,
      ),
    ];
  }

  void _getData(List<int> dataList) {
    int _counter = 0;
    // int _averageTime = 0;
    double _averageWeight = 0;
    if (dataList.isNotEmpty && dataList[0] == Bluetooth.RES_WEIGHT_MEAS) {
      for (int x = 2; x < dataList.length; x += 8) {
        _averageWeight +=
            Uint8List.fromList(dataList.getRange(x, x + 4).toList()).buffer.asByteData().getFloat32(0, Endian.little);
        // _averageTime += Uint8List.fromList(dataList.getRange(x + 4, x + 8).toList()).buffer.asByteData().getUint32(0, Endian.little);
        if (_counter++ == 8) {
          double _weight = double.parse((_averageWeight.abs() / 8.0).toStringAsFixed(2));
          // double _time = double.parse(((_averageTime / 8) / 1000000.0).toStringAsFixed(2));
          if (!_weightCtrl.isClosed) _weightCtrl.add(_weight);
          _measurement.insert(0, ChartData(weight: _weight));
          _graphDataCtrl.updateDataSource(updatedDataIndex: 0);
          _counter = 0;
          // _averageTime = 0;
          _averageWeight = 0;
        }
      }
    }
  }
}
