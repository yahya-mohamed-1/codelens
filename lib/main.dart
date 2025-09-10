import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bloc/barcode/barcode_bloc.dart';
import 'models/barcode_item.dart';
import 'repositories/barcode_repository.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BarcodeItemAdapter());
  Hive.registerAdapter(BarcodeTypeAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BarcodeRepository repository = BarcodeRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BarcodeBloc>(
          create: (context) => BarcodeBloc(repository: repository)
            ..add(LoadBarcodeHistory()),
        ),
      ],
      child: MaterialApp(
        title: 'Professional Code Scanner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}