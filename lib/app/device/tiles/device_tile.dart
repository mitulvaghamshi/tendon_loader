import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/app/handler/bluetooth_handler.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  String get _deviceName => device.name.isEmpty ? device.id.toString() : device.name;

  @override
  Widget build(_) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: device.state,
      builder: (_, AsyncSnapshot<BluetoothDeviceState> snapshot) =>
          _buildTile(snapshot.data == BluetoothDeviceState.connected),
    );
  }

  ListTile _buildTile(bool isConnected) {
    return ListTile(
      horizontalTitleGap: 0,
      title: Text(_deviceName),
      contentPadding: const EdgeInsets.all(5),
      subtitle: Text('Click to ${isConnected ? 'disconnect' : 'connect'}'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onTap: isConnected
          ? Bluetooth.disconnect
          : () {
              Bluetooth.connect(device).then((_) => Bluetooth.startNotify());
            },
      leading: Icon(isConnected ? Icons.bluetooth_connected_rounded : Icons.bluetooth_rounded, size: 40),
      trailing: CircleAvatar(radius: 20, backgroundColor: isConnected ? Colors.green : Colors.deepOrange),
    );
  }
}
