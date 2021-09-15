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
import 'package:tendon_loader/screens/graph/custom_graph.dart';
import 'package:tendon_loader/screens/mvctest/mvc_handler.dart';
import 'package:tendon_loader/utils/themes.dart';

class MVCTesting extends StatefulWidget {
  const MVCTesting({Key? key}) : super(key: key);

  static const String name = 'MVC Testing';
  static const String route = '/mvcTesting';

  @override
  _MVCTestingState createState() => _MVCTestingState();
}

class _MVCTestingState extends State<MVCTesting> {
  late final MVCHandler _handler = MVCHandler(context: context);

  @override
  Widget build(BuildContext context) {
    return CustomGraph(
      handler: _handler,
      title: MVCTesting.name,
      builder: () => Column(children: <Widget>[
        Text(_handler.maxForceValue, style: tsG40B),
        Text(_handler.timeDiffValue, style: tsR40B),
      ]),
    );
  }
}
