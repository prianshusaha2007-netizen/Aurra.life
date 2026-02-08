import 'package:flutter/material.dart';

void main() {
  runApp(const AurraApp());
}

class AurraApp extends StatelessWidget {
  const AurraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B9DFF),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'aurra.life',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D0F14),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      home: const AurraHome(),
    );
  }
}

class AurraHome extends StatelessWidget {
  const AurraHome({super.key});

  @override
  Widget build(BuildContext context) {
    final messages = [
      const ChatMessage(
        author: 'Aurra',
        content: 'Good evening, I saved your focus notes from today. Want a recap?',
        isUser: false,
      ),
      const ChatMessage(
        author: 'You',
        content: 'Yes, plus remind me about the 4pm design sync tomorrow.',
        isUser: true,
      ),
      const ChatMessage(
        author: 'Aurra',
        content: 'Added. You were most productive between 9:30–11:15. Keep that window clear?',
        isUser: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('aurra.life'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Memory permissions',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const DailyOverviewCard(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ChatBubble(message: message);
                },
              ),
            ),
            const SizedBox(height: 8),
            const ChatComposer(),
          ],
        ),
      ),
    );
  }
}

class DailyOverviewCard extends StatelessWidget {
  const DailyOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF141824),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF20263A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.blur_on, color: colorScheme.primary),
              const SizedBox(width: 8),
              const Text(
                'Daily Overview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Mood: Focused · Energy: Calm',
            style: TextStyle(color: Color(0xFFB3B8C8)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Next: 4pm design sync • Remember to bring notes',
            style: TextStyle(color: Color(0xFFB3B8C8)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton(
                onPressed: () {},
                child: const Text('Focus window'),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Edit memory'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final alignment = message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final background = message.isUser ? const Color(0xFF2A3150) : const Color(0xFF171B28);
    final border = message.isUser ? const Color(0xFF3A4470) : const Color(0xFF22273A);

    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment:
              message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.author,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF98A0B5),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message.content,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatComposer extends StatelessWidget {
  const ChatComposer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0F14),
        border: Border(
          top: BorderSide(color: Color(0xFF1B2030)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Share what is on your mind…',
                hintStyle: const TextStyle(color: Color(0xFF76809A)),
                filled: true,
                fillColor: const Color(0xFF141824),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF22283A)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF22283A)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton.filled(
            onPressed: () {},
            icon: const Icon(Icons.mic_rounded),
            tooltip: 'Voice input',
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  const ChatMessage({
    required this.author,
    required this.content,
    required this.isUser,
  });

  final String author;
  final String content;
  final bool isUser;
}
