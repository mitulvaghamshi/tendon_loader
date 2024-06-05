import 'package:flutter/material.dart';
import 'package:tendon_loader/handlers/mvc_handler.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/widgets/graph_widget.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class MVCTesting extends StatelessWidget {
  const MVCTesting({super.key, required this.handler});

  final MVCHandler handler;

  static const String name = 'MVC Testing';

  @override
  Widget build(BuildContext context) {
    return GraphWidget(
      onExit: (key) {
        const PromptScreenRoute().go(context);
        return true;
      },
      handler: handler,
      title: MVCTesting.name,
      builder: () => Column(children: [
        Text(handler.maxForceValue, style: Styles.headerText),
        Text(
          handler.timeDiffValue,
          style: Styles.headerText.copyWith(color: const Color(0xffff534d)),
        ),
      ]),
    );
  }
}
