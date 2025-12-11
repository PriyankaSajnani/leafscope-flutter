import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'result_screen.dart';
import 'history_screen.dart';
import 'about_screen.dart';

const kPrimaryGreen = Color(0xFF2E7D32); // main green [web:59]
const kLightGreen = Color(0xFFA5D6A7);   // accent
const kBackground = Color(0xFFF5F7F5);   // soft bg

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('history');
  runApp(const LeafScopeApp());
}

class LeafScopeApp extends StatelessWidget {
  const LeafScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: kPrimaryGreen,
      brightness: Brightness.light,
    ); // [web:52][web:60]

    return MaterialApp(
      title: 'LeafScope – Plant Identifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: kBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: kPrimaryGreen,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: kPrimaryGreen,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryGreen,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: kPrimaryGreen,
            side: BorderSide(color: kPrimaryGreen.withOpacity(0.5)),
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            height: 1.4,
            color: Colors.black87,
          ),
          labelMedium: TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ), // [web:51][web:63][web:66]
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file =
        await _picker.pickImage(source: source, imageQuality: 85);
    if (file == null) return;

    final imageFile = File(file.path);
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(imageFile: imageFile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LeafScope'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // CHANGED: gradient header + hero card layout
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [kPrimaryGreen, kLightGreen.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.eco_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Identify any plant\nin seconds',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Snap a clear photo of a leaf or plant to see what it is.',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 56,
                          color: kPrimaryGreen,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start a new scan',
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Use your camera or an existing photo for best results.',
                          style: theme.textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.photo_camera_outlined),
                          label: const Text('Use camera'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text('Choose from gallery'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HistoryScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('View scan history'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
