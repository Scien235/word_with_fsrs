import 'dart:convert';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/models/word.dart';

class DatabaseService{
  //싱글톤 패턴으로 데이터베이스 구현
  static Database? _db;
  static Future<Database> get database async{
    _db ??= await _init();
    return _db!;
  }

  //database 생성 또는 기존에 있는 database 가져오기
  static Future<Database> _init() async{
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'wordList.db'),
      version: 1,
      onCreate: (db, version) async{
        await db.execute('''
          CREATE TABLE wordList (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word STRING NOT NULL,
            partOfSpeech STRING,
            meaning STRING,
            example STRING,
            audioUrl STRING,
            dataFsrs STRING)
          ''');
      }
    );
  }

  //새로운 단어 입력
  static Future<void> insertWord(Word word) async{
    final db = await database;
    final tmp = word.toMap()..remove('id');
    final id = await db.insert('wordList', tmp);
    word.id = id;
    return;
  }

  //전체 단어 리스트 가져오기
  static Future<List<Word>> getWordList() async{
    final db = await database;
    final tmp = await db.query('wordList', orderBy: 'id ASC');
    List<Word> ret = [];
    for(final t in tmp) ret.add(Word.mkWord(t));
    return ret;
  }

  //복습해야하는 단어 리스트 가져오기
  static Future<List<Word>> getDueWords() async{
    final now = DateTime.now().toUtc();
    final wordList = await getWordList();
    final List<Word> ret = [];

    for(final word in wordList){
      if(word.dataFsrs == null){
        ret.add(word);
        continue;
      }
      final card = fsrs.Card.fromMap(jsonDecode(word.dataFsrs!));
      if(card.due.isBefore(now)) ret.add(word);
    }
    return ret;
  }

  //단어 내용 업데이트
  static Future<void> updateWord(int id, Word word) async{
    final db = await database;
    final tmp = word.toMap()..remove('id');
    await db.update('wordList', tmp, where: 'id = ?', whereArgs: [id]);
  }

  //단어 삭제
  static Future<void> deleteWord(int id) async {
    final db = await database;
    await db.delete('wordList', where: 'id = ?', whereArgs: [id]);
  }
}
