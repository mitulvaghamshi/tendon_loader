import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/livedata_handler.dart';
import 'package:tendon_loader/ui/widgets/graph_widget.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class LiveData extends StatelessWidget {
  const LiveData({super.key, required this.handler});

  final LiveDataHandler handler;

  static const String name = 'Live Data';

  @override
  Widget build(BuildContext context) {
    return GraphWidget(
      onExit: (_) => true,
      handler: handler,
      title: LiveData.name,
      builder: () => Text(
        handler.timeElapsed,
        textAlign: TextAlign.center,
        style: Styles.headerText,
      ),
    );
  }
}
