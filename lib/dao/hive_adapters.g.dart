// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class PromptAdapter extends TypeAdapter<Prompt> {
  @override
  final int typeId = 0;

  @override
  Prompt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prompt(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Prompt obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.prompt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 1;

  @override
  Document read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Document(
      id: fields[0] as String,
      content: fields[1] as String?,
      contentPath: fields[2] as String?,
      title: fields[3] as String,
      type: fields[4] as DocumentType,
      createdAt: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.contentPath)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DocumentTypeAdapter extends TypeAdapter<DocumentType> {
  @override
  final int typeId = 2;

  @override
  DocumentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DocumentType.documentation;
      case 1:
        return DocumentType.meetingNotes;
      case 2:
        return DocumentType.research;
      case 3:
        return DocumentType.email;
      case 4:
        return DocumentType.chat;
      case 5:
        return DocumentType.report;
      case 6:
        return DocumentType.proposal;
      case 7:
        return DocumentType.contract;
      case 8:
        return DocumentType.invoice;
      case 9:
        return DocumentType.book;
      case 10:
        return DocumentType.article;
      case 11:
        return DocumentType.other;
      default:
        return DocumentType.documentation;
    }
  }

  @override
  void write(BinaryWriter writer, DocumentType obj) {
    switch (obj) {
      case DocumentType.documentation:
        writer.writeByte(0);
      case DocumentType.meetingNotes:
        writer.writeByte(1);
      case DocumentType.research:
        writer.writeByte(2);
      case DocumentType.email:
        writer.writeByte(3);
      case DocumentType.chat:
        writer.writeByte(4);
      case DocumentType.report:
        writer.writeByte(5);
      case DocumentType.proposal:
        writer.writeByte(6);
      case DocumentType.contract:
        writer.writeByte(7);
      case DocumentType.invoice:
        writer.writeByte(8);
      case DocumentType.book:
        writer.writeByte(9);
      case DocumentType.article:
        writer.writeByte(10);
      case DocumentType.other:
        writer.writeByte(11);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
