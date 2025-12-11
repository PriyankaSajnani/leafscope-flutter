import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final box = Hive.box('history');

    if (box.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear history?'),
        content: const Text(
          'This will remove all saved identifications from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    ); // [web:99][web:100][web:115]

    if (confirmed == true) {
      await box.clear(); // [web:108][web:114]
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('history');
    final items = box.values.toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            tooltip: 'Clear history',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () => _confirmClear(context),
          ), // [web:113][web:116]
        ],
      ),
      body: items.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.local_florist_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'No identifications yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Scan a plant and your results will appear here.',
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index] as Map;
                final path = item['path'] as String;
                final name = item['name'] as String;
                final score = (item['score'] as num).toDouble();
                final createdAt = item['createdAt'] as String?;

                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(path),
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Confidence: ${(score * 100).toStringAsFixed(1)}%',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      // optionally push a detail page later
                    },
                  ),
                );
              },
            ),
    );
  }
}
