import 'package:flutter/material.dart';
import 'dart:async';
import 'widgets/growing_plant.dart';
import 'models/focus_session.dart';
import 'screens/garden_screen.dart';
import 'widgets/duration_picker_sheet.dart';
import 'dart:ui' show FontFeature;


void main() {
  runApp(const FocusGardenApp());
}

class FocusGardenApp extends StatelessWidget {
  const FocusGardenApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusGarden',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color(0xFF557153),
          brightness: Brightness.light,
          surface: const Color(0xFFFAF7EF)
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF7EF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF7EF),
          surfaceTintColor: Colors.transparent,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFFFAF7EF),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const FocusScreen(),
    );
  }
}

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  // Use a short session while developing.
  Duration _sessionDuration = const Duration(minutes: 10);

  int get _sessionSeconds => _sessionDuration.inSeconds;

  bool get _canChangeDuration =>
    !_isRunning && _stopwatch.elapsed == Duration.zero;

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _refreshTimer;

  final List<FocusSession> _completedSessions = [];
  bool _hasAwardedFlower = false;

  int get _remainingSeconds {
    final remaining = _sessionSeconds - _stopwatch.elapsed.inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  bool get _isRunning => _stopwatch.isRunning;

  bool get _isComplete => _remainingSeconds == 0;

  double get _progress {
    final totalMilliseconds = _sessionSeconds * 1000;
    final elapsedMilliseconds = _stopwatch.elapsed.inMilliseconds;

    return (elapsedMilliseconds / totalMilliseconds).clamp(0.0, 1.0).toDouble();
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void _startSession() {
    if (_isRunning || _isComplete) return;

    setState(() {
      _stopwatch.start();
    });

    _refreshTimer = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) {
        if (_isComplete) {
          _completeSession();
        } else {
          setState(() {});
        }
      },
    );
  }

  void _pauseSession() {
    if (_isComplete) {
      _completeSession();
      return;
    }

    _refreshTimer?.cancel();

    setState(() {
      _stopwatch.stop();
    });
  }

  void _resetSession() {
    if (_isComplete) {
      _completeSession();
    }

    _refreshTimer?.cancel();

    setState(() {
      _stopwatch.stop();
      _stopwatch.reset();
      _hasAwardedFlower = false;
    });
  }

  void _completeSession() {
    _refreshTimer?.cancel();
    _stopwatch.stop();

    if (_hasAwardedFlower) return;

    setState(() {
      _completedSessions.add(
        FocusSession(
          completedAt: DateTime.now(),
          duration: Duration(seconds: _sessionSeconds),
        ),
      );

      _hasAwardedFlower = true;
    });
  }

  void _openGarden() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => GardenScreen(
          sessions: List<FocusSession>.unmodifiable(
            _completedSessions,
          ),
        ),
      ),
    );
  }

  Future<void> _chooseDuration() async {
    if (!_canChangeDuration) return;

    final selectedDuration = await showModalBottomSheet<Duration>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => DurationPickerSheet(
        initialDuration: _sessionDuration,
      ),
    );

    if (!mounted || selectedDuration == null) return;

    setState(() {
      _sessionDuration = selectedDuration;
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String heading;
    final String buttonLabel;

    if (_isComplete) {
      heading = 'Session completed!';
      buttonLabel = 'Completed';
    } else if (_isRunning) {
      heading = 'A little focus goes a long way';
      buttonLabel = 'Pause';
    } else {
      heading = 'Grow your focus';
      buttonLabel = _stopwatch.elapsed == Duration.zero
          ? 'Start focusing'
          : 'Resume';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusGarden'),
        actions: [
          IconButton(
            tooltip: _isRunning
                ? 'Pause your session to visit the garden'
                : 'My Garden',
            onPressed: _isRunning ? null : _openGarden,
            icon: const Icon(Icons.local_florist),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GrowingPlant(
                  progress: _progress,
                ),
                const SizedBox(height: 24),
                Text(
                  heading,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  _formattedTime,
                  style: const TextStyle(
                    fontFamily: 'super-mario-kart-timer-font',
                    fontSize: 56,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    fontFeatures: [
                      FontFeature.tabularFigures(),
                    ]
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _canChangeDuration ? _chooseDuration : null,
                  icon: const Icon(Icons.schedule),
                  label: const Text('Change duration'),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isComplete
                      ? null
                      : (_isRunning ? _pauseSession : _startSession),
                  child: Text(buttonLabel),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _resetSession,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}