/// MIT License
/// 
/// Copyright (c) 2021 Mitul Vaghamshi
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:tendon_loader/custom/app_logo.dart';
import 'package:tendon_loader/utils/themes.dart';

class AboutTile extends StatelessWidget {
  const AboutTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AboutListTile(
      applicationVersion: 'v0.1.0',
      applicationName: 'Tendon Loader',
      applicationLegalese: 'Please see the tendon_loader'
          ' license for copyright notice.',
      applicationIcon: SizedBox(
        width: 50,
        height: 50,
        child: AppLogo(),
      ),
      aboutBoxChildren: <Widget>[
        Divider(),
        Text(
          'Tendon Loader',
          style: tsG24B,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Tendon Loader is a project designed to measure '
          'and help overcome the Achilles Tendon Problems.',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        Text(
          'Contact us:\n'
          'kohlemerry@gmail.com\n'
          'mitulvaghmashi@gmail.com',
          style: TextStyle(fontSize: 12),
        ),
      ],
      child: Text('About'),
    );
  }
}
