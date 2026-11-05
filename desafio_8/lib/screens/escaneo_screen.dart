import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/asistencia_service.dart';

class EscaneoScreen extends StatefulWidget {
  const EscaneoScreen({super.key});

  @override
  State<EscaneoScreen> createState() => _EscaneoScreenState();
}

class _EscaneoScreenState extends State<EscaneoScreen> {
  final MobileScannerController _ctrl = MobileScannerController();
  bool _procesando = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _procesarCodigo(String codigo) async {
    if (_procesando) return;
    _procesando = true;

    String mensaje = await registrarAsistencia(codigo);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }

    await Future.delayed(const Duration(seconds: 3));
    _procesando = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _ctrl.toggleTorch(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: _ctrl,
        onDetect: (BarcodeCapture capture) {
          if (capture.barcodes.isNotEmpty) {
            final codigo = capture.barcodes.first.rawValue;
            if (codigo != null) _procesarCodigo(codigo);
          }
        },
      ),
    );
  }
}
