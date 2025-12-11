import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About LeafScope')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LeafScope – Plant Identifier',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'LeafScope lets anyone quickly identify plants by snapping a photo '
                  'or choosing an existing picture. It is designed as a fast, '
                  'lightweight tool for gardeners, students, and hobbyists.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  'Data & API',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Plant identification is powered by the Pl@ntNet API. '
                  'Predictions and confidence scores come directly from their model.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  'Privacy',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Photos are sent only to the identification API for analysis and '
                  'recent queries are stored locally on your device for history.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
