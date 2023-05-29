import 'dart:convert';

import 'package:flutter_piano_pro/note_names.dart';

class NoteModel {
  final String name;
  final int octave;
  final int noteIndex;
  final bool isFlat;
  const NoteModel({
    required this.name,
    required this.octave,
    required this.noteIndex,
    required this.isFlat,
  });

  factory NoteModel.fromMidiNoteNumber(int midiNoteNumber, NoteType noteType) {
    final noteNames = noteType.notes;
    final octave = (midiNoteNumber ~/ 12) - 1;
    int noteIndexWithFlats = midiNoteNumber % 12;
    final flatIndexes = [1, 3, 6, 8, 10];
    final isFlat = flatIndexes.contains(noteIndexWithFlats);
    if (isFlat) ++noteIndexWithFlats;
    int noteIndex = 0;
    String name = '';
    switch (noteIndexWithFlats) {
      case 0:
        noteIndex = 0;
        break;
      case 2:
        noteIndex = 1;
        break;
      case 4:
        noteIndex = 2;
        break;
      case 5:
        noteIndex = 3;
        break;
      case 7:
        noteIndex = 4;
        break;
      case 9:
        noteIndex = 5;
        break;
      case 11:
        noteIndex = 6;
        break;
      default:
        noteIndex = 0;
        break;
    }
    if (isFlat) {
      name = "${noteNames[noteIndex - 1]}♯\n${noteNames[noteIndex]}♭";
    } else {
      name = noteNames[noteIndex];
    }
    return NoteModel(
      name: name,
      octave: octave,
      noteIndex: noteIndex,
      isFlat: isFlat,
    );
  }

  int get midiNoteNumber {
    int baseNoteNumber = 12 + octave * 12;
    if (isFlat) {
      switch (noteIndex) {
        case 1: // Db/C#
          return baseNoteNumber + 1;
        case 2: // Eb/D#
          return baseNoteNumber + 3;
        case 4: // Gb/F#
          return baseNoteNumber + 6;
        case 5: // Ab/G#
          return baseNoteNumber + 8;
        case 6: // Bb/A#
          return baseNoteNumber + 10;
      }
    } else {
      switch (noteIndex) {
        case 0: // C
          return baseNoteNumber;
        case 1: // D
          return baseNoteNumber + 2;
        case 2: // E
          return baseNoteNumber + 4;
        case 3: // F
          return baseNoteNumber + 5;
        case 4: // G
          return baseNoteNumber + 7;
        case 5: // A
          return baseNoteNumber + 9;
        case 6: // B
          return baseNoteNumber + 11;
      }
    }
    throw Exception("Invalid noteIndex or flat parameter!");
  }

  NoteModel copyWith({
    String? name,
    int? octave,
    int? noteIndex,
    bool? isFlat,
  }) {
    return NoteModel(
      name: name ?? this.name,
      octave: octave ?? this.octave,
      noteIndex: noteIndex ?? this.noteIndex,
      isFlat: isFlat ?? this.isFlat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'octave': octave,
      'noteIndex': noteIndex,
      'isFlat': isFlat,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      name: map['name'] as String,
      octave: map['octave'] as int,
      noteIndex: map['noteIndex'] as int,
      isFlat: map['isFlat'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NoteModel(name: $name, octave: $octave, noteIndex: $noteIndex, isFlat: $isFlat)';
  }

  @override
  bool operator ==(covariant NoteModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.octave == octave &&
        other.noteIndex == noteIndex &&
        other.isFlat == isFlat;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        octave.hashCode ^
        noteIndex.hashCode ^
        isFlat.hashCode;
  }
}
