// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarcodeItemAdapter extends TypeAdapter<BarcodeItem> {
  @override
  final int typeId = 0;

  @override
  BarcodeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarcodeItem(
      data: fields[0] as String,
      type: fields[1] as BarcodeType,
      timestamp: fields[2] as DateTime,
      isGenerated: fields[3] as bool,
      note: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BarcodeItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.isGenerated)
      ..writeByte(4)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BarcodeTypeAdapter extends TypeAdapter<BarcodeType> {
  @override
  final int typeId = 1;

  @override
  BarcodeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BarcodeType.qrCode;
      case 1:
        return BarcodeType.code128;
      case 2:
        return BarcodeType.code39;
      case 3:
        return BarcodeType.ean8;
      case 4:
        return BarcodeType.ean13;
      case 5:
        return BarcodeType.upcA;
      case 6:
        return BarcodeType.dataMatrix;
      default:
        return BarcodeType.qrCode;
    }
  }

  @override
  void write(BinaryWriter writer, BarcodeType obj) {
    switch (obj) {
      case BarcodeType.qrCode:
        writer.writeByte(0);
        break;
      case BarcodeType.code128:
        writer.writeByte(1);
        break;
      case BarcodeType.code39:
        writer.writeByte(2);
        break;
      case BarcodeType.ean8:
        writer.writeByte(3);
        break;
      case BarcodeType.ean13:
        writer.writeByte(4);
        break;
      case BarcodeType.upcA:
        writer.writeByte(5);
        break;
      case BarcodeType.dataMatrix:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
