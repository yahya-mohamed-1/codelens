import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'bloc/barcode/barcode_bloc.dart';
import 'models/barcode_item.dart';
import 'repositories/barcode_repository.dart';
import 'screens/home_screen.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BarcodeItemAdapter());
  Hive.registerAdapter(BarcodeTypeAdapter());
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  final BarcodeRepository repository = BarcodeRepository();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (!themeProvider.isLoaded) {
      // Show splash/loading until theme is loaded
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    Color _getContrastingColor(Color color) {
      return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<BarcodeBloc>(
          create:
              (context) =>
                  BarcodeBloc(repository: repository)
                    ..add(LoadBarcodeHistory()),
        ),
      ],
      child: MaterialApp(
        title: 'Professional Code Scanner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: themeProvider.accentColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            backgroundColor: themeProvider.accentColor,
            foregroundColor: _getContrastingColor(themeProvider.accentColor),
            iconTheme: IconThemeData(
              color: _getContrastingColor(themeProvider.accentColor),
            ),
            elevation: 1,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: themeProvider.accentColor,
          appBarTheme: AppBarTheme(
            backgroundColor: themeProvider.accentColor,
            foregroundColor: _getContrastingColor(themeProvider.accentColor),
            iconTheme: IconThemeData(
              color: _getContrastingColor(themeProvider.accentColor),
            ),
            elevation: 1,
          ),
        ),
        themeMode: themeProvider.themeMode,
        home: HomeScreen(),
      ),
    );
  }
}
