import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart' show ChartSeriesController;
import 'package:tendon_loader/custom/confirm_dialod.dart';
import 'package:tendon_loader/custom/countdown.dart';
import 'package:tendon_loader/custom/custom_controls.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/custom/custom_graph.dart';
import 'package:tendon_loader/custom/extensions.dart';
import 'package:tendon_loader/handler/bluetooth_handler.dart'
    show exportDataList, deviceName, isDeviceRunning, startWeightMeasuring, stopWeightMeasuring;
import 'package:tendon_loader/handler/clip_player.dart';
import 'package:tendon_loader/handler/data_handler.dart' show graphDataStream, clearGraphData;
import 'package:tendon_loader/handler/export_handler.dart';
import 'package:tendon_loader/handler/user.dart';
import 'package:tendon_loader_lib/tendon_loader_lib.dart';

class BarGraph extends StatefulWidget {
  const BarGraph({Key? key}) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  final List<ChartData> _lineData = <ChartData>[const ChartData(), const ChartData(time: 2)];
  final List<ChartData> _graphData = <ChartData>[];

  ChartSeriesController? _graphCtrl;
  ChartSeriesController? _lineCtrl;
  late DateTime _dateTime;

  bool _isComplete = false;
  bool _isRunning = false;
  bool _hasData = false;

  double _minLoad = 0;

  Future<void> _start() async {
    if (!_isRunning && _hasData) {
      await _onExit();
    } else if (!_isRunning && (await CountDown.start(context) ?? false)) {
      _dateTime = DateTime.now();
      _isComplete = false;
      _isRunning = true;
      _hasData = true;
      _minLoad = 0;
      play(Clip.start);
      exportDataList.clear();
      await startWeightMeasuring();
    }
  }

  void _stop() {
    stopWeightMeasuring();
    _isRunning = false;
    play(Clip.stop);
    Future<void>.delayed(const Duration(seconds: 1), _onExit);
  }

  void _reset() {
    if (_isRunning) _stop();
    _graphData.insert(0, const ChartData());
    _graphCtrl?.updateDataSource(updatedDataIndex: 0);
    _lineData.insertAll(0, <ChartData>[const ChartData(), const ChartData(time: 2)]);
    _lineCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
  }

  Future<bool> _onExit() async {
    if (!_hasData) return true;
    final DataModel _dataModel = DataModel(
      dataList: exportDataList,
      sessionInfo: SessionInfo(
        dateTime: _dateTime,
        dataStatus: _isComplete,
        progressorId: deviceName,
        exportType: keyPrefixMVC,
        userId: context.read<User>().userId,
      ),
    );
    final bool? result;
    if (context.read<User>().autoUpload ?? false) {
      result = await export(_dataModel, false);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Data stored successfully...'),
        ));
      }
    } else {
      result = await ConfirmDialog.show(context, model: _dataModel);
    }
    if (result == null) {
      return false;
    } else {
      _hasData = false;
    }
    return result;
  }

  @override
  void dispose() {
    _reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      onExit: _onExit,
      child: Column(
        children: <Widget>[
          StreamBuilder<ChartData>(
            initialData: const ChartData(),
            stream: graphDataStream,
            builder: (_, AsyncSnapshot<ChartData> snapshot) {
              if (5 - snapshot.data!.time! == 0) {
                _isComplete = true;
                if (_isRunning) _stop();
              } else if (snapshot.data!.load! > _minLoad) {
                _minLoad = snapshot.data!.load!;
                _lineData.insertAll(0, <ChartData>[
                  ChartData(load: _minLoad),
                  ChartData(time: 2, load: _minLoad),
                ]);
                _lineCtrl?.updateDataSource(updatedDataIndexes: <int>[0, 1]);
              }
              _graphData.insert(0, snapshot.data!);
              _graphCtrl?.updateDataSource(updatedDataIndex: 0);
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: Column(
                  children: <Widget>[
                    Text(
                      'MVC: ${_minLoad.toStringAsFixed(2)} Kg',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      snapshot.data!.time!.toRemaining,
                      style: const TextStyle(color: Colors.deepOrange, fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
          CustomGraph(
            lineData: _lineData,
            graphData: _graphData,
            lineCtrl: (ChartSeriesController ctrl) => _lineCtrl = ctrl,
            graphCtrl: (ChartSeriesController ctrl) => _graphCtrl = ctrl,
          ),
          GraphControls(start: _start, reset: _reset),
        ],
      ),
    );
  }
}
