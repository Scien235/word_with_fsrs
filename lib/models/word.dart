class Word{
  //단어의 기본 정보
  int? id;
  String word;
  String? partOfSpeech;
  String? meaning;
  String? example;
  String? audioUrl;
  //fsrs 알고리즘 실행을 위해 필요한 데이터
  String? dataFsrs;

  Word({
    this.id,
    required this.word,
    required this.partOfSpeech,
    this.meaning,
    this.example,
    this.audioUrl,
    this.dataFsrs
  });

  //map 형식의 데이터를 받아서 Word 클래스로 변환
  factory Word.mkWord(Map<String, dynamic> map) => Word(
    id: map['id'] as int?,
    word: map['word'] as String,
    partOfSpeech: map['partOfSpeech'] as String,
    meaning: map['meaning'] as String?,
    example: map['example'] as String?,
    audioUrl: map['audioUrl'] as String?,
    dataFsrs: map['dataFsrs'] as String?,
  );

  //Word 클래스의 객체를 map 형식으로 변환
  Map<String, dynamic> toMap() => {
    'id': id,
    'word': word,
    'partOfSpeech': partOfSpeech,
    'meaning': meaning,
    'example': example,
    'audioUrl': audioUrl,
    'dataFsrs': dataFsrs,
  };

}