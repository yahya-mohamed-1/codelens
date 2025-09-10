part of 'barcode_bloc.dart';

abstract class BarcodeEvent extends Equatable {
  const BarcodeEvent();
  @override
  List<Object?> get props => [];
}

class LoadBarcodeHistory extends BarcodeEvent {}

class ScanBarcode extends BarcodeEvent {
  final String data;
  final model.BarcodeType type;
  const ScanBarcode({required this.data, required this.type});
  @override
  List<Object?> get props => [data, type];
}

class GenerateBarcode extends BarcodeEvent {
  final String data;
  final model.BarcodeType type;
  final String? note;
  const GenerateBarcode({required this.data, required this.type, this.note});
  @override
  List<Object?> get props => [data, type, note];
}

class ImportBarcodeFromGallery extends BarcodeEvent {}

class DeleteBarcode extends BarcodeEvent {
  final BarcodeItem item;
  const DeleteBarcode({required this.item});
  @override
  List<Object?> get props => [item];
}

class ClearAllHistory extends BarcodeEvent {}
