import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tendon_loader/shared/utils/extension.dart';

@immutable
class CountdownWidget extends StatefulWidget {
  const CountdownWidget({Key? key, required this.duration}) : super(key: key);

  final Duration duration;

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: widget.duration + const Duration(seconds: 1),
  );

  String get _getTime {
    final int _millies = (_ctrl.duration! * _ctrl.value).inMilliseconds;
    return _millies < 1000 ? 'GO!' : (_millies / 1000).truncate().toString();
  }

  @override
  void initState() {
    super.initState();
    _ctrl.reverse(from: _ctrl.value == 0.0 ? 1.0 : _ctrl.value);
    _ctrl.addStatusListener((_) => context.pop(true));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, Widget? child) {
          return Stack(alignment: Alignment.center, children: <Widget>[
            Positioned.fill(
              child: CustomPaint(painter: _ProgrssPainter(_ctrl)),
            ),
            FittedBox(
              child: Text(
                _getTime,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 130,
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class _ProgrssPainter extends CustomPainter {
  const _ProgrssPainter(this.ctrl) : super(repaint: ctrl);

  final Animation<double> ctrl;

  @override
  bool shouldRepaint(_) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 25
      ..color = const Color(0xff3ddc85)
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2,
      paint,
    );
    canvas.drawArc(
      Offset.zero & size,
      pi * 1.5,
      ctrl.value * 2 * pi,
      false,
      paint..color = const Color(0xffffffff),
    );
  }
}
