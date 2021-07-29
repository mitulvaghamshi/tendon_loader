import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tendon_loader/handlers/graph_handler.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/utils/extension.dart';

class ExerciseHandler extends GraphHandler {
  ExerciseHandler({required BuildContext context})
      : _pre = context.model.prescription!,
        super(context: context, lineData: <ChartData>[
          ChartData(load: context.model.prescription!.targetLoad),
          ChartData(time: 2, load: context.model.prescription!.targetLoad),
        ]) {
    _clear();
  }

  int _minTime = 0;

  late int _set;
  late int _rep;
  late int _rest;
  late int _lapTime;
  late bool isPush;
  late bool _isSetOver;
  final Prescription _pre;

  String get lapTime => '${isPush ? 'Push' : 'Rest'}: $_lapTime Sec';
  String get counterValue => 'Set: $_set/${_pre.sets} • Rep: $_rep/${_pre.reps}';

  void _clear() {
    isPush = true;
    _minTime = 0;
    _lapTime = _pre.holdTime;
    _set = _rep = _rest = 1;
    _isSetOver = isHit = false;
    GraphHandler.clear();
  }

  @override
  void update(ChartData data) {
    if (isRunning && !_isSetOver) {
      isHit = data.load > _pre.targetLoad;
      final int _time = data.time.truncate();
      if (!isPause && _time > _minTime) {
        _minTime = _time;
        if (_lapTime-- == 0) {
          if (isPush) {
            isPush = false;
            _rep++;
            _lapTime = _pre.restTime;
            if (_rep > _pre.reps && _rest > _pre.reps - 1) {
              _set++;
              if (_set > _pre.sets) {
                isComplete = true;
                stop();
              } else {
                _rest = _rep = 1;
                isPush = _isSetOver = true;
                _lapTime = _pre.holdTime;
                _setOver();
              }
            }
          } else {
            _rest++;
            isPush = true;
            _lapTime = _pre.holdTime;
          }
          HapticFeedback.heavyImpact();
        }
      }
    }
  }

  Future<void> _setOver() async {
    await Future<void>.microtask(() async {
      final bool? result = await startCountdown(
        context,
        title: 'Set Over, Rest!!!',
        duration: Duration(seconds: _pre.setRest),
      );
      await (result ?? false ? start : stop)();
    });
  }

  @override
  Future<void> start() async {
    if (isPause && isRunning) {
      isPause = false;
    } else if (_isSetOver && isRunning) {
      _isSetOver = false;
    } else if (hasData && !isRunning) {
      await exit();
    } else {
      await super.start();
    }
  }

  @override
  void pause() {
    if (isRunning) isPause = true;
  }

  @override
  Future<void> stop() async {
    if (isRunning) {
      isRunning = false;
      await super.stop();
      _clear();
      if (isComplete) await congratulate(context);
      await exit();
    }
  }

  @override
  Future<bool> exit() async {
    if (!hasData) return true;
    export ??= Export(prescription: _pre);
    return super.exit();
  }
}
