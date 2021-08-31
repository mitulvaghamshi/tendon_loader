import 'package:flutter/material.dart';
import 'package:tendon_loader/app.dart';
import 'package:tendon_loader/utils/common.dart';

Future<void> main() async {
  await initApp();
  runApp(const TendonLoader());
}
