import 'package:dio/dio.dart';
import '/models/word.dart';

//외부 인터넷 사전에서 단어 데이터를 가져오는 기능 구현
class WordSearch{
  static final Dio dio = Dio();
  static Future<List<Word>> find(String word) async{
    try{
      final tmp = await dio.get('https://api.dictionaryapi.dev/api/v2/entries/en/${word.trim()}');
      final data = tmp.data as List;
      if(data.isEmpty) return [];
      String? audioUrl = null;
      final phonetics = data[0]['phonetics'] as List?;

      //오디오 url 찾기
      if(phonetics != null){
        for(final p in phonetics){
          final audio = p['audio'] as String?;
          if(audio != null && audio.isNotEmpty){
            audioUrl = audio;
            break;
          }
        }
      }

      //품사와 의미별로 각각 word 객체 생성 후 리스트에 저장
      final List<Word> ret = [];
      for(final x in data){
        final meanings = x['meanings'] as List?;
        if(meanings == null) continue;
        for(final m in meanings){
          final partOfSpeech = m['partOfSpeech'] as String?;
          final definitions = m['definitions'] as List?;
          if(definitions == null) continue;
          for(final d in definitions){
            final definition = d['definition'] as String?;
            final example = d['example'] as String?;
            ret.add(Word(
              word: word.trim(),
              partOfSpeech: partOfSpeech,
              meaning: definition,
              example: example,
              audioUrl: audioUrl,
            ));
          }
        }
      }
      return ret;
    }
    catch (e){
      return [];
    }
  }
}