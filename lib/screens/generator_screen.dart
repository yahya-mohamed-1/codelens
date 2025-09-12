import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../bloc/barcode/barcode_bloc.dart';
import '../models/barcode_item.dart' as model;
import '../models/barcode_type.dart';

class GeneratorScreen extends StatefulWidget {
  @override
  _GeneratorScreenState createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final TextEditingController _textController = TextEditingController();
  model.BarcodeType _selectedType = model.BarcodeType.qrCode;
  String _note = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Code'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showBarcodeInfo,
            tooltip: 'Barcode Types Info',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter text or URL',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<model.BarcodeType>(
              value: _selectedType,
              items: model.BarcodeType.values.map((type) {
                return DropdownMenuItem<model.BarcodeType>(
                  value: type,
                  child: Text(_getBarcodeTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedType = value!);
              },
              decoration: InputDecoration(
                labelText: 'Barcode Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => _note = value,
              decoration: InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            if (_textController.text.isNotEmpty)
              Builder(
                builder: (context) {
                  final data = _textController.text;
                  if (!_validateInput(data, _selectedType)) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: 200,
                      height: 200,
                      child: Center(
                        child: Text(
                          "Unable to encode \"$data\" to ${_getBarcodeTypeName(_selectedType).toUpperCase()} Barcode",
                          style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BarcodeWidget(
                      barcode: _getBarcode(
                        model.BarcodeType.values.firstWhere(
                          (type) => type == _selectedType,
                        ),
                      ),
                      data: data,
                      width: 200,
                      height: 200,
                    ),
                  );
                },
              ),
            SizedBox(height: 24),
            Builder(
              builder: (context) {
                final colorScheme = Theme.of(context).colorScheme;
                return ElevatedButton(
                  onPressed: _generateCode,
                  child: Text('Generate and Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBarcodeInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Barcode Types Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: model.BarcodeType.values.map((type) {
                final info = barcodeTypeInfoMap[_getBarcodeTypeName(type)];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info?.name ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(info?.description ?? ''),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  bool _validateInput(String data, model.BarcodeType type) {
    final info = barcodeTypeInfoMap[_getBarcodeTypeName(type)];
    if (info == null) return false;
    return info.validate(data);
  }

  void _generateCode() {
    final data = _textController.text;
    if (data.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter some text')));
      return;
    }

    if (!_validateInput(data, _selectedType)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(
          content: Text(
              "Unable to encode '$data' to '${_getBarcodeTypeName(_selectedType)}' Barcode")));
      return;
    }

    try {
      context.read<BarcodeBloc>().add(
            GenerateBarcode(
              data: data,
              type: _selectedType,
              note: _note,
            ),
          );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Barcode generated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generating barcode: $e')));
    }
  }

  Barcode _getBarcode(model.BarcodeType type) {
    switch (type) {
      case model.BarcodeType.qrCode:
        return Barcode.qrCode();
      case model.BarcodeType.code128:
        return Barcode.code128();
      case model.BarcodeType.code39:
        return Barcode.code39();
      case model.BarcodeType.ean8:
        return Barcode.ean8();
      case model.BarcodeType.ean13:
        return Barcode.ean13();
      case model.BarcodeType.upcA:
        return Barcode.upcA();
      case model.BarcodeType.dataMatrix:
        return Barcode.dataMatrix();
    }
  }

  String _getBarcodeTypeName(model.BarcodeType type) {
    return type.toString().split('.').last;
  }
}
