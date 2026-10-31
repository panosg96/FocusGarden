import 'package:flutter/material.dart';

import '../models/focus_session.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({
    super.key,
    required this.sessions,
  });

  final List<FocusSession> sessions;

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    if (minutes == 0) return '${seconds}s';
    if (seconds == 0) return '${minutes}m';

    return '${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Garden (${sessions.length})'),
      ),
      body: SafeArea(
        child: sessions.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '🪴',
                        style: TextStyle(fontSize: 80),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your garden is waiting',
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Complete a focus session to grow your first flower.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisExtent: 170,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];

                  return Card(
                    color: colors.primaryContainer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '🌻',
                          style: TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Flower ${index + 1}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatDuration(session.duration)} of focus',
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}