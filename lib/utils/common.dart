import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tendon_loader/custom/custom_dialog.dart';
import 'package:tendon_loader/modal/chartdata.dart';
import 'package:tendon_loader/modal/export.dart';
import 'package:tendon_loader/modal/patient.dart';
import 'package:tendon_loader/modal/prescription.dart';
import 'package:tendon_loader/modal/settings_state.dart';
import 'package:tendon_loader/modal/timestamp.dart';
import 'package:tendon_loader/modal/user_state.dart';
import 'package:tendon_loader/screens/app_settings.dart';
import 'package:tendon_loader/screens/exercise/exercise_mode.dart';
import 'package:tendon_loader/screens/exercise/new_exercise.dart';
import 'package:tendon_loader/screens/homescreen.dart';
import 'package:tendon_loader/screens/livedata/live_data.dart';
import 'package:tendon_loader/screens/login/login.dart';
import 'package:tendon_loader/screens/mvctest/mvc_testing.dart';
import 'package:tendon_loader/screens/mvctest/new_mvc_test.dart';
import 'package:tendon_loader/utils/constants.dart';
import 'package:tendon_loader/utils/empty.dart'
    if (dart.library.html) 'dart:html' show AnchorElement;
import 'package:tendon_loader/utils/extension.dart';
import 'package:tendon_loader/utils/themes.dart';
import 'package:tendon_loader/web/homepage.dart';

Future<void> useEmulator() async {
  const String host = '192.168.0.18';
  await FirebaseAuth.instance.useAuthEmulator(host, 10001);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 10002);
}

late final Box<bool> boxDarkMode;
late final Box<Export> boxExport;
late final Box<UserState> boxUserState;
late final Box<SettingsState> boxSettingsState;

enum PopupAction {
  isClinician,
  download,
  delete,
  prescribe,
  history,
  darkMode,
  logout,
  settings,
}

final ValueNotifier<int?> userClick = ValueNotifier<int?>(null);

final ValueNotifier<Export?> exportClick = ValueNotifier<Export?>(null);

Future<void> initApp() async {
  await Hive.initFlutter();
  await Firebase.initializeApp();
  Hive.registerAdapter(ExportAdapter());
  Hive.registerAdapter(UserStateAdapter());
  Hive.registerAdapter(ChartDataAdapter());
  Hive.registerAdapter(TimestampAdapter());
  Hive.registerAdapter(PrescriptionAdapter());
  Hive.registerAdapter(SettingsStateAdapter());
  boxExport = await Hive.openBox<Export>(keyExportBox);
  boxDarkMode = await Hive.openBox<bool>(keyDarkModeBox);
  boxUserState = await Hive.openBox<UserState>(keyUserStateBox);
  boxSettingsState = await Hive.openBox<SettingsState>(keySettingsStateBox);
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp],
    );
  }
  await useEmulator();
}

final Map<String, String> firebaseErrors = <String, String>{
  'email-already-in-use': 'The account already exists for that email.',
  'invalid-email': 'Invalid email.',
  'weak-password': 'The password is too weak.',
  'wrong-password': 'Invalid password.',
  'user-not-found': 'No user found for that email. '
      'Make sure you enter right credentials.',
  'user-disabled': 'This account is disabled.',
  'operation-not-allowed': 'This account is disabled.',
};

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  Login.route: (_) => const Login(),
  LiveData.route: (_) => const LiveData(),
  HomePage.route: (_) => const HomePage(),
  HomeScreen.route: (_) => const HomeScreen(),
  NewMVCTest.route: (_) => const NewMVCTest(),
  MVCTesting.route: (_) => const MVCTesting(),
  AppSettings.route: (_) => const AppSettings(),
  NewExercise.route: (_) => const NewExercise(),
  ExerciseMode.route: (_) => const ExerciseMode(),
};

Route<T> buildRoute<T>(String routeName, [bool? fullscreen = false]) {
  return PageRouteBuilder<T>(
    fullscreenDialog: fullscreen!,
    pageBuilder: (BuildContext context, __, ___) {
      return routes[routeName]!(context);
    },
    transitionsBuilder: (_, Animation<double> animation, ___, Widget child) {
      return SlideTransition(
        position: animation.drive(Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.ease))),
        child: child,
      );
    },
  );
}

Future<void> logout(BuildContext context) async {
  try {
    context.userState.keepSigned = false;
    await context.userState.save();
    await context.settingsState.save();
    await signOut();
  } finally {
    await Navigator.pushAndRemoveUntil<void>(
        context, buildRoute(Login.route), (_) => false);
  }
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } finally {}
}

Future<void> saveExcel({List<int>? bytes, required String name}) async {
  if (kIsWeb) {
    AnchorElement(href: 'data:application/zip;base64,${base64.encode(bytes!)}')
      ..setAttribute('download', name)
      ..click();
  }
}

Future<bool?> tryUpload(BuildContext context) async {
  if (boxExport.isEmpty) return false;
  if ((await Connectivity().checkConnectivity()) != ConnectivityResult.none) {
    int count = 0;
    for (final Export export in boxExport.values) {
      if (await export.upload(context)) count++;
    }
    await CustomDialog.show<void>(
      context,
      title: 'Upload success!!!',
      content: Text(
        '$count file(s) submitted successfully!',
        textAlign: TextAlign.center,
        style: tsG18B,
      ),
    );
  }
}

CollectionReference<Patient> get dbRoot {
  return FirebaseFirestore.instance.collection(keyBase).withConverter<Patient>(
      toFirestore: (Patient value, _) {
    return value.toMap();
  }, fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot, _) {
    return Patient.fromJson(snapshot.reference);
  });
}
