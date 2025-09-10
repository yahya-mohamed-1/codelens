import 'package:hive/hive.dart';
import '../models/barcode_item.dart';

class BarcodeRepository {
  static const String _boxName = 'barcodeHistory';

  Future<Box<BarcodeItem>> get _box async {
    return await Hive.openBox<BarcodeItem>(_boxName);
  }

  Future<void> saveBarcode(BarcodeItem item) async {
    final box = await _box;
    await box.add(item);
  }

  Future<List<BarcodeItem>> getHistory() async {
    final box = await _box;
    return box.values.toList().reversed.toList();
  }

  Future<void> deleteBarcode(BarcodeItem item) async {
    final box = await _box;
    final index = box.values.toList().indexOf(item);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
