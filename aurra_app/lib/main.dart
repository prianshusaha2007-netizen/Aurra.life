import 'package:flutter/material.dart';

void main() {
  runApp(const AurraApp());
}

class AurraApp extends StatelessWidget {
  const AurraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aurra.life',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8AB4F8),
          secondary: Color(0xFFB2F2E5),
          surface: Color(0xFF0F1115),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F1115),
        useMaterial3: true,
      ),
      home: const AurraHome(),
    );
  }
}

class AurraHome extends StatelessWidget {
  const AurraHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'aurra',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Available. Listening. Building context.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: const [
                    _ChatBubble(
                      role: 'You',
                      message: 'How are you keeping track of my day?',
                    ),
                    _ChatBubble(
                      role: 'aurra',
                      message:
                          'I gather patterns you choose to remember and keep them grounded in context.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1F26),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Share a thought...',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8AB4F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.mic, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF151821),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily overview',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Calm focus',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.role, required this.message});

  final String role;
  final String message;

  @override
  Widget build(BuildContext context) {
    final isAurra = role == 'aurra';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isAurra ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            role,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isAurra ? const Color(0xFF1B1F2A) : const Color(0xFF273044),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(message),
          ),
        ],
      ),
    );
  }
}
