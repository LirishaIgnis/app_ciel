import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:app_ciel/servicios/conexion/bluetooth/bluetooth_service.dart';

class BluetoothMenu extends StatefulWidget {
  final BluetoothService bluetoothService;

  BluetoothMenu({required this.bluetoothService});

  @override
  _BluetoothMenuState createState() => _BluetoothMenuState();
}

class _BluetoothMenuState extends State<BluetoothMenu> {
  BluetoothDevice? _selectedDevice;
  List<BluetoothDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    _fetchPairedDevices();
  }

  /// **Busca dispositivos Bluetooth emparejados**
  Future<void> _fetchPairedDevices() async {
    try {
      List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      print("Error al obtener dispositivos emparejados: $e");
    }
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
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // **Dropdown con lista de dispositivos**
            DropdownButtonFormField<BluetoothDevice>(
              dropdownColor: Colors.grey[850],
              value: _selectedDevice,
              items: _devices.isNotEmpty
                  ? _devices.map((device) {
                      return DropdownMenuItem(
                        value: device,
                        child: Text(device.name ?? "Desconocido",
                            style: TextStyle(color: Colors.white)),
                      );
                    }).toList()
                  : [], // Si no hay dispositivos, lista vacía
              onChanged: (device) {
                setState(() {
                  _selectedDevice = device;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[700],
                labelText: _devices.isNotEmpty ? "Seleccionar dispositivo" : "No hay dispositivos",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),

            // **Botón Conectar / Desconectar**
            ElevatedButton(
              onPressed: _selectedDevice != null
                  ? () => widget.bluetoothService.conectarDispositivo(_selectedDevice!)
                  : null,
              child: Text(widget.bluetoothService.isConnected ? "Desconectar" : "Conectar",
                  style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.bluetoothService.isConnected ? Colors.red : Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),

            SizedBox(height: 10),

            // **Botón de actualización de dispositivos**
            ElevatedButton(
              onPressed: _fetchPairedDevices,
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

