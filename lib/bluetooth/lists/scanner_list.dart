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
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/bluetooth/lists/device_list.dart';
import 'package:tendon_loader/bluetooth/tiles/bluetooth_tile.dart';
import 'package:tendon_loader/custom/progress_tile.dart';

class ScannerList extends StatelessWidget {
  const ScannerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<BluetoothDevice>>(
      stream: FlutterBlue.instance.scanResults.asyncMap(
          (List<ScanResult> results) =>
              results.map((ScanResult result) => result.device)),
      builder: (_, AsyncSnapshot<Iterable<BluetoothDevice>> snapshot) {
        if (!snapshot.hasData) return const CustomProgress();
        return snapshot.data!.isEmpty
            ? const BluetoothTile()
            : DeviceList(devices: snapshot.data!);
      },
    );
  }
}
