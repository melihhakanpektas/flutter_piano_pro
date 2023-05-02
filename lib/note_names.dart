enum NoteType {
  english,
  german,
  romance,
  romance2,
}

class NoteNames {
  static List<String> generate(NoteType noteType) {
    switch (noteType) {
      case NoteType.english:
        return ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
      case NoteType.german:
        return ['C', 'D', 'E', 'F', 'G', 'A', 'H'];
      case NoteType.romance:
        return ['Do', 'Re', 'Mi', 'Fa', 'Sol', 'La', 'Si'];
      case NoteType.romance2:
        return ['Do', 'Re', 'Mi', 'Fa', 'Sol', 'La', 'Ti'];
      default:
        return ['Do', 'Re' ',Mi', 'Fa', 'Sol', 'La', 'Si'];
    }
  }
}
