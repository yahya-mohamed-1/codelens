import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:share_plus/share_plus.dart';
import '../bloc/barcode/barcode_bloc.dart';
import '../models/barcode_item.dart' as model;

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showClearHistoryDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<BarcodeBloc, BarcodeState>(
        builder: (context, state) {
          if (state is BarcodeHistoryLoaded) {
            final history = state.history;

            if (history.isEmpty) {
              return Center(child: Text('No history yet'));
            }

            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return _buildHistoryItem(context, item);
              },
            );
          } else if (state is BarcodeError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, model.BarcodeItem item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          child: BarcodeWidget(
            barcode: _getBarcode(item.type),
            data: item.data,
          ),
        ),
        title: Text(
          item.data.length > 30
              ? '${item.data.substring(0, 30)}...'
              : item.data,
          style: TextStyle(fontFamily: 'Monospace'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_formatDate(item.timestamp)} - ${_getTypeName(item.type)}',
              style: TextStyle(fontSize: 12),
            ),
            if (item.note != null && item.note!.isNotEmpty)
              Text(
                'Note: ${item.note}',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.share, size: 20),
              onPressed: () => _shareBarcode(context, item),
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 20),
              onPressed: () => _deleteItem(context, item),
            ),
          ],
        ),
        onTap: () => _showDetailsDialog(context, item),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, model.BarcodeItem item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Barcode Details'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: BarcodeWidget(
                        barcode: _getBarcode(item.type),
                        data: item.data,
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Type: ${_getTypeName(item.type)}'),
                  SizedBox(height: 8),
                  Text('Date: ${_formatDate(item.timestamp)}'),
                  if (item.note != null && item.note!.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text('Note: ${item.note}'),
                  ],
                  SizedBox(height: 16),
                  Text('Data:'),
                  SelectableText(
                    item.data,
                    style: TextStyle(fontFamily: 'Monospace'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  void _shareBarcode(BuildContext context, model.BarcodeItem item) {
    Share.share(
      'Barcode: ${item.data}\nType: ${_getTypeName(item.type)}\nDate: ${_formatDate(item.timestamp)}',
    );
  }

  void _deleteItem(BuildContext context, model.BarcodeItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<BarcodeBloc>().add(DeleteBarcode(item: item));
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Clear History'),
            content: Text('Are you sure you want to delete all history?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<BarcodeBloc>().add(ClearAllHistory());
                  Navigator.pop(context);
                },
                child: Text('Clear'),
              ),
            ],
          ),
    );
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
      // default removed as all cases are covered
    }
  }

  String _getTypeName(model.BarcodeType type) {
    return type.toString().split('.').last;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
