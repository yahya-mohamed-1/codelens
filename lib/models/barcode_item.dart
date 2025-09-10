import 'package:hive/hive.dart';

part 'barcode_item.g.dart';

@HiveType(typeId: 0)
class BarcodeItem {
  @HiveField(0)
  final String data;
  
  @HiveField(1)
  final BarcodeType type;
  
  @HiveField(2)
  final DateTime timestamp;
  
  @HiveField(3)
  final bool isGenerated;
  
  @HiveField(4)
  final String? note;

  BarcodeItem({
    required this.data,
    required this.type,
    required this.timestamp,
    this.isGenerated = false,
    this.note,
  });
}

@HiveType(typeId: 1)
enum BarcodeType {
  @HiveField(0)
  qrCode,
  
  @HiveField(1)
  code128,
  
  @HiveField(2)
  code39,
  
  @HiveField(3)
  ean8,
  
  @HiveField(4)
  ean13,
  
  @HiveField(5)
  upcA,
  
  @HiveField(6)
  dataMatrix,
}