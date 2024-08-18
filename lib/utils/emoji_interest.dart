String getEmojiInterest(String interest) {
  String interestLower = interest.toLowerCase();
  Map<RegExp, String> emojiMap = {
    RegExp(r'programación|programacion|computadora|gaming') : '💻',
    RegExp(r'fútbol|futbol|balón pie|deportes') : '⚽',
    RegExp(r'comida') : '🍔',
    RegExp(r'cocina|cocinar'): '🍳',
    RegExp(r'música|musica|cantar') : '🎶',
    RegExp(r'películas|peliculas|series') : '🎬',
    RegExp(r'viajar|vacaciones') : '🏝️',
    RegExp(r'literatura|leer|escribir') : '✍️',
    RegExp(r'conocer gente|hablar') : '🙂',
    RegExp(r'teatro|actuar') : '🎭',
    RegExp(r'museos|historia') : '🏛️',
    RegExp(r'arte|pintar') : '🎨',
    RegExp(r'naturaleza|aire libre|gardinería|gardineria') : '🍃',
    RegExp(r'bordado|costura|coser') : '🪡',
    RegExp(r'crochet|tejer|macrame') : '🧶',
    RegExp(r'tenis|padel') : '🎾',
  };
   for (var entry in emojiMap.entries) {
    if (entry.key.hasMatch(interestLower)) {
      return entry.value;
    }
  }
  return '📌';
}