class BarcodeTypeInfo {
  final String name;
  final String description;
  final bool Function(String) validate;

  BarcodeTypeInfo({
    required this.name,
    required this.description,
    required this.validate,
  });
}

final Map<String, BarcodeTypeInfo> barcodeTypeInfoMap = {
  'qrCode': BarcodeTypeInfo(
    name: 'QR Code',
    description: 'A two-dimensional barcode that can encode text, URLs, and other data. Commonly used for quick scanning with smartphones.',
    validate: (data) => data.isNotEmpty, // Accept any non-empty string
  ),
  'code128': BarcodeTypeInfo(
    name: 'Code 128',
    description: 'A high-density linear barcode that supports alphanumeric characters. Used in shipping and packaging.',
    validate: (data) => RegExp(r'^[\x00-\x7F]+$').hasMatch(data), // ASCII characters
  ),
  'code39': BarcodeTypeInfo(
    name: 'Code 39',
    description: 'A linear barcode that supports uppercase letters, digits, and some special characters.',
    validate: (data) => RegExp(r'^[0-9A-Z \-\.\$\+\/%]+$').hasMatch(data),
  ),
  'ean8': BarcodeTypeInfo(
    name: 'EAN-8',
    description: 'A short European Article Number barcode used on small packages.',
    validate: (data) => RegExp(r'^\d{7,8}$').hasMatch(data),
  ),
  'ean13': BarcodeTypeInfo(
    name: 'EAN-13',
    description: 'A 13-digit European Article Number barcode used worldwide for retail products.',
    validate: (data) => RegExp(r'^\d{12,13}$').hasMatch(data),
  ),
  'upcA': BarcodeTypeInfo(
    name: 'UPC-A',
    description: 'A 12-digit barcode widely used in North America for retail products.',
    validate: (data) => RegExp(r'^\d{11,12}$').hasMatch(data),
  ),
  'dataMatrix': BarcodeTypeInfo(
    name: 'Data Matrix',
    description: 'A two-dimensional barcode used for small items and labeling.',
    validate: (data) => data.isNotEmpty, // Accept any non-empty string
  ),
};
