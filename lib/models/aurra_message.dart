enum AurraSender { user, aurra }

class AurraMessage {
  AurraMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  final AurraSender sender;
  final String text;
  final DateTime timestamp;
}
