import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:app_ciel/servicios/conexion/bluetooth/bluetooth_service.dart';
import 'dart:async';

class BluetoothMenu extends StatefulWidget {
  final BluetoothService bluetoothService;

  BluetoothMenu({required this.bluetoothService});

  @override
  _BluetoothMenuState createState() => _BluetoothMenuState();
}

class _BluetoothMenuState extends State<BluetoothMenu> {
  fbp.BluetoothDevice? _selectedDevice;
  List<fbp.ScanResult> _devices = [];
  StreamSubscription? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _iniciarEscaneo();
  }

  /// **Inicia escaneo usando BluetoothService**
  void _iniciarEscaneo() {
    widget.bluetoothService.detenerEscaneo();
    _scanSubscription = widget.bluetoothService.escanearDispositivos().listen((results) {
      if (mounted) {
        setState(() {
          _devices = results;
        });
      }
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blueGrey[800],
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dispositivos Bluetooth",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Dropdown de dispositivos escaneados
            DropdownButtonFormField<fbp.BluetoothDevice>(
              dropdownColor: Colors.grey[850],
              value: _selectedDevice,
              items: _devices.map((scanResult) {
                final device = scanResult.device;
                final nombre = scanResult.advertisementData.localName.isNotEmpty
                    ? scanResult.advertisementData.localName
                    : device.platformName;
                return DropdownMenuItem(
                  value: device,
                  child: Text(nombre.isNotEmpty ? nombre : "Desconocido",
                      style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (device) {
                setState(() {
                  _selectedDevice = device;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[700],
                labelText: "Seleccionar dispositivo",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),

            // Botón conectar o desconectar
            ElevatedButton(
              onPressed: _selectedDevice != null
                  ? () => widget.bluetoothService.conectarODesconectar(_selectedDevice!)
                  : null,
              child: Text(widget.bluetoothService.isConnected ? "Desconectar" : "Conectar",
                  style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.bluetoothService.isConnected ? Colors.red : Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 10),

            // Botón para reescanear
            ElevatedButton(
              onPressed: _iniciarEscaneo,
              child: Text("Actualizar Lista"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

