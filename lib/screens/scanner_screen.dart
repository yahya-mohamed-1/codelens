import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../bloc/barcode/barcode_bloc.dart';
import '../models/barcode_item.dart' as model;

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Code'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () {
              context.read<BarcodeBloc>().add(ImportBarcodeFromGallery());
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (!isScanning) {
                isScanning = true;
                final List<Barcode> barcodes = capture.barcodes;

                if (barcodes.isNotEmpty) {
                  final String code = barcodes.first.rawValue ?? '';
                  final model.BarcodeType type = _getBarcodeType(
                    barcodes.first.type,
                  );
                  context.read<BarcodeBloc>().add(
                    ScanBarcode(data: code, type: type),
                  );

                  // Show result dialog
                  _showScanResult(context, code, type);

                  // Reset scanning after a delay
                  Future.delayed(
                    Duration(seconds: 2),
                    () => isScanning = false,
                  );
                }
              }
            },
          ),
          _buildScannerOverlay(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return CustomPaint(painter: ScannerOverlay(), child: Container());
  }

  void _showScanResult(
    BuildContext context,
    String data,
    model.BarcodeType type,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Scan Result'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${type.toString().split('.').last}'),
                SizedBox(height: 8),
                Text('Data:'),
                SelectableText(data, style: TextStyle(fontFamily: 'Monospace')),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  model.BarcodeType _getBarcodeType(dynamic mobileScannerType) {
    // Map the external barcode type to your model.BarcodeType
    switch (mobileScannerType.toString()) {
      case 'BarcodeType.qrCode':
        return model.BarcodeType.qrCode;
      case 'BarcodeType.code128':
        return model.BarcodeType.code128;
      case 'BarcodeType.code39':
        return model.BarcodeType.code39;
      case 'BarcodeType.ean8':
        return model.BarcodeType.ean8;
      case 'BarcodeType.ean13':
        return model.BarcodeType.ean13;
      case 'BarcodeType.upcA':
        return model.BarcodeType.upcA;
      case 'BarcodeType.dataMatrix':
        return model.BarcodeType.dataMatrix;
      default:
        return model.BarcodeType.qrCode;
    }
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black54
          ..style = PaintingStyle.fill;

    // Draw outer rounded rectangle
    final outerPath =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw inner transparent rounded rectangle (scanning area)
    final scanningArea =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: size.width * 0.7,
              height: size.width * 0.7,
            ),
            Radius.circular(12),
          ),
        );

    final scanPath = Path.combine(
      PathOperation.difference,
      outerPath,
      scanningArea,
    );

    canvas.drawPath(scanPath, paint);

    // Draw corner lines
    final cornerPaint =
        Paint()
          ..color = Colors.green
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    final cornerSize = 20.0;
    final areaWidth = size.width * 0.7;
    final areaHeight = size.width * 0.7;
    final left = (size.width - areaWidth) / 2;
    final top = (size.height - areaHeight) / 2;
    final right = left + areaWidth;
    final bottom = top + areaHeight;

    // Top left corner
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerSize, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + cornerSize),
      cornerPaint,
    );

    // Top right corner
    canvas.drawLine(
      Offset(right, top),
      Offset(right - cornerSize, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right, top),
      Offset(right, top + cornerSize),
      cornerPaint,
    );

    // Bottom left corner
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left + cornerSize, bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left, bottom - cornerSize),
      cornerPaint,
    );

    // Bottom right corner
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right - cornerSize, bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right, bottom - cornerSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
