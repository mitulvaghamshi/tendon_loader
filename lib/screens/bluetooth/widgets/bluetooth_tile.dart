import 'package:app_settings/app_settings.dart' as ast;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tendon_loader/common/constants.dart';
import 'package:tendon_loader/common/widgets/custom_widget.dart';
import 'package:tendon_loader/common/widgets/image_widget.dart';
import 'package:tendon_loader/screens/bluetooth/widgets/location_tile.dart';

/// This class, when loaded, prompts user to (Enable / Turn on / Power on)
/// the Bluetooth, on this device.
/// User can use "Open Settings" button to enable bluetooth, it will
/// take user to device specific Bluetooth Settings screen,
/// where user have to manually torn on the Bluetooth.
/// Alternatively, user can user "Control Center" to do the same.
class BluetoothTile extends StatelessWidget {
  const BluetoothTile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      builder: (_, snapshot) {
        // If the Bluetooth is "ON", check if Location is enabled...
        if (snapshot.hasData && snapshot.data == BluetoothState.on) {
          return const LocationTile();
        }
        // A visual content to inform user about Bluetooth requirements.
        return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const ImageWidget(name: Images.enableBluetooth),
          const Text(
            Strings.enableBluetooth,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          CustomWidget.two(
            left: const Icon(Icons.bluetooth),
            right: const Text('Open Settings'),
            onPressed: ast.AppSettings.openBluetoothSettings,
          ),
        ]);
      },
    );
  }
}
