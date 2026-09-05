import 'package:flutter/material.dart';
import 'features/live_scan/live_scan_screen.dart';

void main() {
  runApp(const ErgoVisionApp());
}

class ErgoVisionApp extends StatelessWidget {
  const ErgoVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERGO VISION',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF071018),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF19D3AE),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openScan(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LiveScanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text('ERGO', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, letterSpacing: 2)),
              const Text('VISION', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300, letterSpacing: 5)),
              const SizedBox(height: 18),
              Text('See the movement.\nUnderstand the risk.', style: TextStyle(color: Colors.white.withValues(alpha: .65), fontSize: 18, height: 1.45)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 62,
                child: FilledButton.icon(
                  onPressed: () => _openScan(context),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('SCAN NOW', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                ),
              ),
              const SizedBox(height: 16),
              Row(children: const [
                Expanded(child: _SecondaryAction(icon: Icons.videocam_outlined, label: 'VIDEO ANALYSIS')),
                SizedBox(width: 12),
                Expanded(child: _SecondaryAction(icon: Icons.analytics_outlined, label: 'ASSESSMENTS')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SecondaryAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 19),
        label: Text(label, style: const TextStyle(fontSize: 11)),
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
      );
}
