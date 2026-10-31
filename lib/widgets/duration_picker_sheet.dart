import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DurationPickerSheet extends StatefulWidget {
  const DurationPickerSheet({
    super.key,
    required this.initialDuration,
  });

  final Duration initialDuration;

  @override
  State<DurationPickerSheet> createState() =>
      _DurationPickerSheetState();
}

class _DurationPickerSheetState extends State<DurationPickerSheet> {
  late Duration _selectedDuration;

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _selectedDuration >= const Duration(minutes: 1);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose your focus time',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hm,
              initialTimerDuration: widget.initialDuration,
              backgroundColor: Theme.of(context).colorScheme.surface,
              onTimerDurationChanged: (duration) {
                setState(() {
                  _selectedDuration = duration;
                });
              },
            ),
            const SizedBox(height: 8),
            Text(
              isValid
                  ? 'A little time for something meaningful.'
                  : 'Choose at least 1 minute.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isValid
                    ? () {
                        Navigator.of(context).pop(_selectedDuration);
                      }
                    : null,
                child: const Text('Set duration'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}