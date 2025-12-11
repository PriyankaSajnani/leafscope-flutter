import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'plantnet_api.dart';
import 'main.dart'; // for kPrimaryGreen if needed

class ResultScreen extends StatefulWidget {
  final File imageFile;
  const ResultScreen({super.key, required this.imageFile});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final PlantNetApi _api;
  PlantIdentification? _result;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _api = PlantNetApi('2b109l45yBUG8U0R0datarvu7u');
    _identify();
  }

  Future<void> _identify() async {
    try {
      final res = await _api.identifyPlant(widget.imageFile);
      setState(() {
        _result = res;
        _loading = false;
      });
      final box = Hive.box('history');
      await box.add({
        'name': res.name,
        'score': res.score,
        'path': widget.imageFile.path,
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.wifi_off_rounded,
                            size: 48,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Could not identify this plant.',
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a closer photo of the leaves in good lighting. '
                            'If it keeps failing, check your internet connection.',
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Details: $_error',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              widget.imageFile,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _result!.name,
                                    style:
                                        theme.textTheme.titleLarge?.copyWith(
                                      color: kPrimaryGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // NEW: "Top match" chip
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              kLightGreen.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          'Top match',
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                            color: kPrimaryGreen,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Confidence: '
                                    '${(_result!.score * 100).toStringAsFixed(1)}%',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Tip: For better results, make sure the leaf is in focus and fills most of the frame.',
                                    style: theme.textTheme.labelMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
