// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      id: fields[0] as String,
      title: fields[1] as String,
      author: fields[2] as String,
      filePath: fields[3] as String,
      fileType: fields[4] as String,
      coverPath: fields[5] as String?,
      description: fields[12] as String?,
      addedAt: fields[6] as DateTime?,
    )
      ..currentPage = fields[7] as int
      ..totalPages = fields[8] as int
      ..readingTimeSeconds = fields[9] as int
      ..isFinished = fields[10] as bool
      ..lastReadAt = fields[11] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.filePath)
      ..writeByte(4)
      ..write(obj.fileType)
      ..writeByte(5)
      ..write(obj.coverPath)
      ..writeByte(6)
      ..write(obj.addedAt)
      ..writeByte(7)
      ..write(obj.currentPage)
      ..writeByte(8)
      ..write(obj.totalPages)
      ..writeByte(9)
      ..write(obj.readingTimeSeconds)
      ..writeByte(10)
      ..write(obj.isFinished)
      ..writeByte(11)
      ..write(obj.lastReadAt)
      ..writeByte(12)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookmarkAdapter extends TypeAdapter<Bookmark> {
  @override
  final int typeId = 1;

  @override
  Bookmark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bookmark(
      id: fields[0] as String,
      bookId: fields[1] as String,
      page: fields[2] as int,
      note: fields[3] as String,
      createdAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Bookmark obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookId)
      ..writeByte(2)
      ..write(obj.page)
      ..writeByte(3)
      ..write(obj.note)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HighlightAdapter extends TypeAdapter<Highlight> {
  @override
  final int typeId = 2;

  @override
  Highlight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Highlight(
      id: fields[0] as String,
      bookId: fields[1] as String,
      text: fields[2] as String,
      page: fields[3] as int,
      note: fields[4] as String?,
      colorIndex: fields[5] as int,
      createdAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Highlight obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookId)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.page)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.colorIndex)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighlightAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
