import 'package:flutter/material.dart';

class ConexionScreen extends StatelessWidget {
  const ConexionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conexiones'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: const ConexionOptions(),
    );
  }
}

class ConexionOptions extends StatefulWidget {
  const ConexionOptions({super.key});

  @override
  State<ConexionOptions> createState() => _ConexionOptionsState();
}

class _ConexionOptionsState extends State<ConexionOptions> {
  bool _showBluetoothDevices = false;
  bool _showWifiDevices = false;
  bool _showScreenDevices = false;

  String? _bluetoothDevice;
  String? _wifiDevice;
  String? _screenDevice;

  List<String> _availableDevices = [
    'Dispositivo 1',
    'Dispositivo 2',
    'Dispositivo 3',
    'Dispositivo 4'
  ];

  void _toggleDeviceMenu(String type) {
    setState(() {
      if (type == 'Bluetooth') {
        _showBluetoothDevices = !_showBluetoothDevices;
        _showWifiDevices = false;
        _showScreenDevices = false;
      } else if (type == 'Wi-Fi') {
        _showWifiDevices = !_showWifiDevices;
        _showBluetoothDevices = false;
        _showScreenDevices = false;
      } else if (type == 'Pantalla') {
        _showScreenDevices = !_showScreenDevices;
        _showBluetoothDevices = false;
        _showWifiDevices = false;
      }
    });
  }

  void _selectDevice(String type, String device) {
    setState(() {
      if (type == 'Bluetooth') {
        _bluetoothDevice = device;
        _showBluetoothDevices = false;
      } else if (type == 'Wi-Fi') {
        _wifiDevice = device;
        _showWifiDevices = false;
      } else if (type == 'Pantalla') {
        _screenDevice = device;
        _showScreenDevices = false;
      }
    });
    _showSnackBar('$type conectado a $device');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildConnectionTile(
            type: 'Bluetooth',
            icon: Icons.bluetooth,
            device: _bluetoothDevice,
            showDevices: _showBluetoothDevices,
            onToggleMenu: () => _toggleDeviceMenu('Bluetooth'),
          ),
          if (_showBluetoothDevices)
            _buildDeviceList('Bluetooth', _availableDevices),
          const SizedBox(height: 20),
          _buildConnectionTile(
            type: 'Wi-Fi',
            icon: Icons.wifi,
            device: _wifiDevice,
            showDevices: _showWifiDevices,
            onToggleMenu: () => _toggleDeviceMenu('Wi-Fi'),
          ),
          if (_showWifiDevices) _buildDeviceList('Wi-Fi', _availableDevices),
          const SizedBox(height: 20),
          _buildConnectionTile(
            type: 'Pantalla',
            icon: Icons.cast,
            device: _screenDevice,
            showDevices: _showScreenDevices,
            onToggleMenu: () => _toggleDeviceMenu('Pantalla'),
          ),
          if (_showScreenDevices) _buildDeviceList('Pantalla', _availableDevices),
        ],
      ),
    );
  }

  Widget _buildConnectionTile({
    required String type,
    required IconData icon,
    String? device,
    required bool showDevices,
    required VoidCallback onToggleMenu,
  }) {
    return GestureDetector(
      onTap: onToggleMenu,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blueAccent, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    device ?? 'No conectado',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Icon(
              showDevices ? Icons.expand_less : Icons.expand_more,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceList(String type, List<String> devices) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: devices.map((device) {
        return ListTile(
          title: Text(device),
          trailing: _isDeviceSelected(type, device)
              ? const Icon(Icons.check, color: Colors.green)
              : null,
          onTap: () => _selectDevice(type, device),
        );
      }).toList(),
    );
  }

  bool _isDeviceSelected(String type, String device) {
    if (type == 'Bluetooth') return _bluetoothDevice == device;
    if (type == 'Wi-Fi') return _wifiDevice == device;
    if (type == 'Pantalla') return _screenDevice == device;
    return false;
  }
}
