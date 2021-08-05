import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/custom/custom_frame.dart';
import 'package:tendon_loader/handlers/auth_handler.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/screens/web/data_list.dart';
import 'package:tendon_loader/screens/web/data_view.dart';
import 'package:tendon_loader/screens/web/session_info.dart';
import 'package:tendon_loader/screens/web/user_list.dart';
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';

final ValueNotifier<Export?> clickNotifier = ValueNotifier<Export?>(null);

enum PopupAction { download, delete, prescribe }

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/homePage';
  static const String name = 'Tendon Loader - Clinician';

  @override
  Widget build(BuildContext context) {
    // if (currentUser == null) context.push(Login.route, replace: true);
    final bool _isWide = MediaQuery.of(context).size.width > 1080;
    // final bool _isMedium = MediaQuery.of(context).size.width > 760;

    return Scaffold(
      appBar: AppBar(title: const Text(name), actions: <Widget>[
        if (!_isWide && clickNotifier.value != null)
          CustomButton(
            left: const Icon(Icons.info),
            right: const Text('Session Info'),
            onPressed: () => sessionInfo(context),
          ),
        const SizedBox(width: 5),
        CustomButton(
          radius: 8,
          left: const Text('Logout'),
          right: const Icon(Icons.logout),
          onPressed: () async => firebaseLogout().then((_) async => context.push(Login.route, replace: true)),
        ),
      ]),
      body: _isWide ? const _WideScreen() : const DataView(),
      drawer: _isWide ? null : const Drawer(child: UserList()),
    );
  }
}

class _WideScreen extends StatelessWidget {
  const _WideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: const <Widget>[UserList(), CenterPanel(), Expanded(child: DataView())]);
  }
}

class CenterPanel extends StatelessWidget {
  const CenterPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppFrame(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: SizedBox(
        width: 260,
        child: Column(children: const <Widget>[SessionInfo(), Expanded(child: DataList())]),
      ),
    );
  }
}

Future<void> sessionInfo(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (_) => const CustomDialog(title: 'Session Info', content: SessionInfo()),
  );
}

Future<void> confirmDelete(BuildContext context, VoidCallback onDelete) async {
  return showDialog<void>(
    context: context,
    builder: (_) => CustomDialog(
      title: 'Delete export(s)?',
      content: CustomButton(
        onPressed: () {
          onDelete();
          clickNotifier.value = null;
          context.view.refresh();
          context.pop();
        },
        radius: 8,
        color: colorRed900,
        left: const Icon(Icons.delete, color: colorWhite),
        right: const Text('Permanently delete', style: TextStyle(color: colorWhite)),
      ),
    ),
  );
}
