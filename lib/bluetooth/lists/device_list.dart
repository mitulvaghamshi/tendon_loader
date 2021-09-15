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
import 'package:tendon_loader/bluetooth/device_handler.dart';
import 'package:tendon_loader/bluetooth/tiles/connected_tile.dart';
import 'package:tendon_loader/bluetooth/tiles/start_scan_tile.dart';
import 'package:tendon_loader/custom/custom_button.dart';
import 'package:tendon_loader/utils/themes.dart';

class DeviceList extends StatelessWidget {
  DeviceList({Key? key, required Iterable<BluetoothDevice> devices})
      : _devices = devices.where((BluetoothDevice device) {
          return device.name.contains('Progressor');
        }),
        super(key: key);

  final Iterable<BluetoothDevice> _devices;

  @override
  Widget build(BuildContext context) {
    if (_devices.isEmpty) return const StartScanTile();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _buildDeviceItem().toList(),
    );
  }

  Iterable<Widget> _buildDeviceItem() sync* {
    final Iterator<BluetoothDevice> _iterator = _devices.iterator;
    final bool _isNotEmpty = _iterator.moveNext();
    BluetoothDevice _device = _iterator.current;
    while (_iterator.moveNext()) {
      yield _buildDevicetile(_device);
      _device = _iterator.current;
    }
    if (_isNotEmpty) yield _buildDevicetile(_device, isLast: true);
  }

  StreamBuilder<BluetoothDeviceState> _buildDevicetile(BluetoothDevice device,
      {bool isLast = false}) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: device.state,
      builder: (_, AsyncSnapshot<BluetoothDeviceState> snapshot) {
        if (snapshot.data == BluetoothDeviceState.connected) {
          return ConnectedTile(device: device);
        }
        if (isLast) {
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            _buildDisconnectedTile(device),
            const CustomButton(
              left: Icon(Icons.search),
              right: Text('Scan'),
              onPressed: startScan,
            ),
          ]);
        }
        return _buildDisconnectedTile(device);
      },
    );
  }

  ListTile _buildDisconnectedTile(BluetoothDevice device) {
    return ListTile(
      onTap: device.connect,
      contentPadding: const EdgeInsets.all(5),
      title: Text(
        device.name.isEmpty ? device.id.id : device.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: const CustomButton(
        rounded: true,
        color: colorErrorRed,
        left: Icon(Icons.bluetooth, color: colorPrimaryWhite),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      subtitle: const Text('Click to connect', style: TextStyle(fontSize: 12)),
    );
  }
}
