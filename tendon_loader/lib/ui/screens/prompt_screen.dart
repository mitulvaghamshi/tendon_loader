import 'package:flutter/material.dart';
import 'package:tendon_loader/router/router.dart';
import 'package:tendon_loader/ui/widgets/raw_button.dart';
import 'package:tendon_loader/utils/constants.dart';

@immutable
class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  late final _autoUpload = false;
  // AppScope.of(context).settingsState.settings.autoUpload;

  double? painScore;
  Tolerance? painTolerance;
  Submission? submitDecision;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Congratulations',
          style: TextStyle(color: Colors.green, fontSize: 26),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _CardWidget(
                children: [
                  Text(
                    'Exercise session completed,\nGreat work!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Please answer few questions about '
                    'this session to finish!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              _CardWidget(
                children: [
                  const Text(
                    '1. Pain score',
                    style: Styles.whiteBold22,
                  ),
                  const Divider(thickness: 2),
                  const Text(
                    'Please describe your '
                    'pain during that session,\n'
                    'move slider to select (0 - 10).',
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: PainSelector(onSelect: (value) {
                      setState(() => painScore = value);
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPainText(
                        '0\n\nNo\npain',
                        const Color(0xff00e676),
                      ),
                      _buildPainText(
                        '5\n\nModerate\npain',
                        const Color(0xff7f9c61),
                      ),
                      _buildPainText(
                        '10\n\nWorst\npain',
                        const Color(0xffff534d),
                      ),
                    ],
                  ),
                ],
              ),
              _CardWidget(
                children: [
                  const Text(
                    '2. Pain tolerance',
                    style: Styles.whiteBold22,
                  ),
                  const Divider(thickness: 2),
                  const Text(
                    'Was the pain during that '
                    'session tolerable for you?',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RawButton.tile(
                        color: painTolerance == Tolerance.yes
                            ? Colors.blueGrey
                            : null,
                        leading: const Icon(Icons.check),
                        child: Text(Tolerance.yes.value),
                        onTap: () =>
                            setState(() => painTolerance = Tolerance.yes),
                      ),
                      const SizedBox(width: 5),
                      RawButton.tile(
                        color: painTolerance == Tolerance.no
                            ? Colors.blueGrey
                            : null,
                        leading: const Icon(Icons.clear),
                        child: Text(Tolerance.no.value),
                        onTap: () =>
                            setState(() => painTolerance = Tolerance.no),
                      ),
                      const SizedBox(width: 5),
                      RawButton.tile(
                        color: painTolerance == Tolerance.noPain
                            ? Colors.blueGrey
                            : null,
                        leading: const Icon(Icons.remove),
                        child: Text(Tolerance.noPain.value),
                        onTap: () =>
                            setState(() => painTolerance = Tolerance.noPain),
                      ),
                    ],
                  ),
                ],
              ),
              if (!_autoUpload)
                _CardWidget(children: [
                  const Text(
                    '3. Submit data?',
                    style: Styles.whiteBold22,
                  ),
                  const Divider(thickness: 2),
                  const Text(
                    'Would you like to submit your answers '
                    'and Exercise/MVC Test data to clinician?',
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    tileColor: submitDecision == Submission.now
                        ? Colors.blueGrey
                        : null,
                    leading: const Icon(Icons.cloud_upload,
                        color: Color(0xff3ddc85)),
                    title: Text(Submission.now.value),
                    onTap: () =>
                        setState(() => submitDecision = Submission.now),
                  ),
                  ListTile(
                    tileColor: submitDecision == Submission.leter
                        ? Colors.blueGrey
                        : null,
                    leading: const Icon(Icons.save, color: Color(0xffe18f3c)),
                    title: Text(Submission.leter.value),
                    onTap: () =>
                        setState(() => submitDecision = Submission.leter),
                  ),
                  ListTile(
                    tileColor: submitDecision == Submission.discard
                        ? Colors.blueGrey
                        : null,
                    leading: const Icon(Icons.clear, color: Color(0xffff534d)),
                    title: Text(Submission.discard.value),
                    onTap: () =>
                        setState(() => submitDecision = Submission.discard),
                  ),
                ]),
              const Divider(thickness: 2),
              _CardWidget(children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      ((_autoUpload || submitDecision == Submission.discard) ||
                              painScore != null && painTolerance != null)
                          ? RawButton.tile(
                              onTap: _onFinished,
                              leading: const Icon(Icons.check),
                              child: const Text('Finish'),
                            )
                          : const Text(
                              'Please answer all three questions to finish.'),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

extension on _PromptScreenState {
  Widget _buildPainText(String text, Color color) {
    return SizedBox(
      width: 80,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          letterSpacing: 1,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _onFinished() async {
    // final Exercise export = AppScope.of(context).userState;

    // // export.painScore ??= painScore;
    // // export.isTolerable ??= painTolerance?.value;

    // if (_autoUpload) {
    //   if (!((await Connectivity().checkConnectivity()) !=
    //       ConnectivityResult.none)) await export.upload();
    // } else {
    //   switch (submitDecision) {
    //     case Submission.now:
    //       await export.upload();
    //     case Submission.discard:
    //     case Submission.leter:
    //     default:
    //   }
    // }

    if (mounted) const TendonLoaderRoute().go(context);
  }
}

enum Tolerance {
  yes('Yes'),
  no('No'),
  noPain('No Pain');

  const Tolerance(this.value);

  final String value;
}

enum Submission {
  now('Okay, submit now'),
  leter('Save, and ask me leter'),
  discard('No, discard this session');

  const Submission(this.value);

  final String value;
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(children: children),
      ),
    );
  }
}

@immutable
class PainSelector extends StatefulWidget {
  const PainSelector({super.key, required this.onSelect});

  final ValueChanged<double> onSelect;

  @override
  State<PainSelector> createState() => _PainSelectorState();
}

class _PainSelectorState extends State<PainSelector> {
  double painScore = 0;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 30,
        thumbShape: _CustomShape(),
        trackShape: RoundedRectSliderTrackShape(),
        showValueIndicator: ShowValueIndicator.never,
        valueIndicatorTextStyle: Styles.bold18,
      ),
      child: Slider(
        max: 10,
        value: painScore,
        activeColor: _trackColor,
        inactiveColor: _trackColor,
        label: painScore.toStringAsFixed(1),
        onChangeEnd: widget.onSelect,
        onChanged: (value) => setState(() => painScore = value),
      ),
    );
  }
}

@immutable
class _CustomShape extends SliderComponentShape {
  const _CustomShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    context.canvas.drawCircle(
      center,
      sliderTheme.trackHeight! * 0.7,
      Paint()..color = Colors.blueGrey,
    );
    labelPainter.paint(
      context.canvas,
      Offset(center.dx - (labelPainter.width / 2),
          center.dy - (labelPainter.height / 2)),
    );
  }
}

extension on _PainSelectorState {
  Color? get _trackColor => Color.lerp(
      const Color(0xff00e676), const Color(0xffff534d), painScore / 10);
}
