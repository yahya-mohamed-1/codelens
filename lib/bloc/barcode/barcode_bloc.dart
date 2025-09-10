import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:codelens/models/barcode_item.dart';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../../models/barcode_item.dart' as model;
import '../../repositories/barcode_repository.dart';

part 'barcode_event.dart';
part 'barcode_state.dart';

class BarcodeBloc extends Bloc<BarcodeEvent, BarcodeState> {
  final BarcodeRepository repository;

  BarcodeBloc({required this.repository}) : super(BarcodeInitial()) {
    on<LoadBarcodeHistory>((event, emit) async {
      emit(BarcodeLoading());
      try {
        final history = await repository.getHistory();
        emit(BarcodeHistoryLoaded(history));
      } catch (e) {
        emit(BarcodeError(e.toString()));
      }
    });

    on<ScanBarcode>((event, emit) async {
      try {
        final newItem = model.BarcodeItem(
          data: event.data,
          type: event.type,
          timestamp: DateTime.now(),
        );
        await repository.saveBarcode(newItem);
        add(LoadBarcodeHistory());
      } catch (e) {
        emit(BarcodeError(e.toString()));
      }
    });

    on<GenerateBarcode>((event, emit) async {
      try {
        final newItem = model.BarcodeItem(
          data: event.data,
          type: event.type,
          timestamp: DateTime.now(),
          isGenerated: true,
          note: event.note,
        );
        await repository.saveBarcode(newItem);
        add(LoadBarcodeHistory());
      } catch (e) {
        emit(BarcodeError(e.toString()));
      }
    });

    on<ImportBarcodeFromGallery>((event, emit) async {
      emit(BarcodeLoading());
      try {
        final XFile? imageFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );

        if (imageFile != null) {
          final File file = File(imageFile.path);
          final image = img.decodeImage(await file.readAsBytes());

          // Here you would add your barcode detection logic
          // This is a simplified example - you might want to use a proper library
          final detectedData = _scanBarcodeFromImage(image);

          if (detectedData != null) {
            final newItem = model.BarcodeItem(
              data: detectedData,
              type: model.BarcodeType.qrCode, // You'd detect the actual type
              timestamp: DateTime.now(),
            );
            await repository.saveBarcode(newItem);
            add(LoadBarcodeHistory());
          } else {
            emit(BarcodeError('No barcode detected in the image'));
          }
        }
      } catch (e) {
        emit(BarcodeError('Failed to import image: [${e.toString()}'));
      }
    });

    on<DeleteBarcode>((event, emit) async {
      try {
        await repository.deleteBarcode(event.item);
        add(LoadBarcodeHistory());
      } catch (e) {
        emit(BarcodeError(e.toString()));
      }
    });

    on<ClearAllHistory>((event, emit) async {
      try {
        await repository.clearAll();
        add(LoadBarcodeHistory());
      } catch (e) {
        emit(BarcodeError(e.toString()));
      }
    });
  }

  String? _scanBarcodeFromImage(img.Image? image) {
    // Implement actual barcode scanning from image
    // This is a placeholder - you'd use a proper library in production
    return null;
  }
}
