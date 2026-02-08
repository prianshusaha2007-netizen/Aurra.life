import 'package:flutter/material.dart';

import 'models/aurra_message.dart';
import 'widgets/aurra_message_bubble.dart';
import 'widgets/overview_card.dart';
import 'widgets/settings_tile.dart';

void main() {
  runApp(const AurraApp());
}

class AurraApp extends StatelessWidget {
  const AurraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7E8BFF),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'aurra.life',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F1117),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 15),
          bodySmall: TextStyle(fontSize: 12, color: Color(0xFFB5B8C9)),
        ),
      ),
      home: const AurraHome(),
    );
  }
}

class AurraHome extends StatefulWidget {
  const AurraHome({super.key});

  @override
  State<AurraHome> createState() => _AurraHomeState();
}

class _AurraHomeState extends State<AurraHome> {
  int _selectedIndex = 0;
  final _messageController = TextEditingController();
  final List<AurraMessage> _messages = [
    AurraMessage(
      sender: AurraSender.aurra,
      text: 'Good evening. I saved today’s wins and your mood trend. Want a recap?',
      timestamp: DateTime.now(),
    ),
    AurraMessage(
      sender: AurraSender.user,
      text: 'Yes, and help me plan a softer morning routine.',
      timestamp: DateTime.now(),
    ),
    AurraMessage(
      sender: AurraSender.aurra,
      text:
          'Based on your past Mondays, a 7:10am wake-up with gentle music helps. I can stage a 10-minute stretch + tea reminder.',
      timestamp: DateTime.now(),
    ),
  ];

  bool _storeMood = true;
  bool _storeRoutine = true;
  bool _storeAudio = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        AurraMessage(
          sender: AurraSender.user,
          text: text,
          timestamp: DateTime.now(),
        ),
      );
      _messages.add(
        AurraMessage(
          sender: AurraSender.aurra,
          text:
              'I hear you. I’ll remember this preference and weave it into your next plan.',
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _ChatPage(
        messages: _messages,
        messageController: _messageController,
        onSend: _sendMessage,
      ),
      const _OverviewPage(),
      _SettingsPage(
        storeMood: _storeMood,
        storeRoutine: _storeRoutine,
        storeAudio: _storeAudio,
        onMoodChanged: (value) => setState(() => _storeMood = value),
        onRoutineChanged: (value) => setState(() => _storeRoutine = value),
        onAudioChanged: (value) => setState(() => _storeAudio = value),
      ),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.auto_graph_outlined), label: 'Overview'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Memory'),
        ],
      ),
    );
  }
}

class _ChatPage extends StatelessWidget {
  const _ChatPage({
    required this.messages,
    required this.messageController,
    required this.onSend,
  });

  final List<AurraMessage> messages;
  final TextEditingController messageController;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Aurra', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(
                    'Your persistent life companion',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, size: 18, color: theme.colorScheme.onSurface),
                    const SizedBox(width: 6),
                    Text('Private', style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.surface.withOpacity(0.3),
                  theme.colorScheme.surface.withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) => AurraMessageBubble(message: messages[index]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.mic_none),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceContainerHigh,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'Share what is on your mind',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.send_rounded),
                onPressed: onSend,
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Aurra highlights the patterns that matter, without overwhelming you.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          const OverviewCard(
            title: 'Emotional cadence',
            subtitle: 'Calm focus at 68%. Gentle dips around 3pm.',
            icon: Icons.favorite_outline,
          ),
          const SizedBox(height: 16),
          const OverviewCard(
            title: 'Intentional wins',
            subtitle: '3 mindful breaks. 1 deep work sprint finished early.',
            icon: Icons.auto_awesome_outlined,
          ),
          const SizedBox(height: 16),
          const OverviewCard(
            title: 'Next best step',
            subtitle: 'Start a 12-minute wind-down ritual at 9:40pm.',
            icon: Icons.nights_stay_outlined,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Device sync', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Your phone and desktop are linked. Glasses-ready mode is available when you are.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.link_rounded),
                  label: const Text('Link a new device'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsPage extends StatelessWidget {
  const _SettingsPage({
    required this.storeMood,
    required this.storeRoutine,
    required this.storeAudio,
    required this.onMoodChanged,
    required this.onRoutineChanged,
    required this.onAudioChanged,
  });

  final bool storeMood;
  final bool storeRoutine;
  final bool storeAudio;
  final ValueChanged<bool> onMoodChanged;
  final ValueChanged<bool> onRoutineChanged;
  final ValueChanged<bool> onAudioChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Memory Permissions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'You are in control of what Aurra retains. Update anytime.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          SettingsTile(
            title: 'Mood patterns',
            subtitle: 'Track sentiment trends for calmer planning.',
            value: storeMood,
            onChanged: onMoodChanged,
          ),
          const SizedBox(height: 12),
          SettingsTile(
            title: 'Routine preferences',
            subtitle: 'Remember morning and evening rituals.',
            value: storeRoutine,
            onChanged: onRoutineChanged,
          ),
          const SizedBox(height: 12),
          SettingsTile(
            title: 'Voice snippets',
            subtitle: 'Optional voice capture for tone insights.',
            value: storeAudio,
            onChanged: onAudioChanged,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account & device linking',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Single sign-on keeps every device synced to one life context.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.manage_accounts_outlined),
                  label: const Text('Manage account'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
