enum NoteType {
  english(['C', 'D', 'E', 'F', 'G', 'A', 'B']),
  german(['C', 'D', 'E', 'F', 'G', 'A', 'H']),
  romance(['Do', 'Re', 'Mi', 'Fa', 'Sol', 'La', 'Si']),
  romance2(['Do', 'Re', 'Mi', 'Fa', 'Sol', 'La', 'Ti']);

  const NoteType(this.notes);
  final List<String> notes;
}
