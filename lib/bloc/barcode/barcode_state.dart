part of 'barcode_bloc.dart';

abstract class BarcodeState extends Equatable {
  const BarcodeState();
  @override
  List<Object?> get props => [];
}

class BarcodeInitial extends BarcodeState {}

class BarcodeLoading extends BarcodeState {}

class BarcodeHistoryLoaded extends BarcodeState {
  final List<BarcodeItem> history;
  const BarcodeHistoryLoaded(this.history);
  @override
  List<Object?> get props => [history];
}

class BarcodeError extends BarcodeState {
  final String message;
  const BarcodeError(this.message);
  @override
  List<Object?> get props => [message];
}
