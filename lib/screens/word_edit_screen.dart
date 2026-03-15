import 'package:flutter/material.dart';
import '/models/word.dart';
import '/services/database_service.dart';

class WordEditScreen extends StatefulWidget{
  final Word word;
  WordEditScreen({super.key, required this.word});
  @override
  State<StatefulWidget> createState() => WordEditScreenState();
}

class WordEditScreenState extends State<WordEditScreen>{
  late final Word word;
  late final TextEditingController wordControl;
  late final TextEditingController partOfSpeechControl;
  late final TextEditingController meaningControl;
  late final TextEditingController exampleControl;

  @override
  void initState(){
    super.initState();
    word = widget.word;
    wordControl = TextEditingController(text: word.word);
    partOfSpeechControl = TextEditingController(text: word.partOfSpeech ?? "");
    meaningControl = TextEditingController(text: word.meaning ?? "");
    exampleControl = TextEditingController(text: word.example ?? "");
  }

  @override
  void dispose(){
    wordControl.dispose();
    partOfSpeechControl.dispose();
    meaningControl.dispose();
    exampleControl.dispose();
    super.dispose();
  }

  Future<void> saveWord() async{
    word.word = wordControl.text.trim();
    word.partOfSpeech = partOfSpeechControl.text.trim();
    word.meaning = meaningControl.text.trim();
    word.example = exampleControl.text.trim();
    await DatabaseService.updateWord(word.id!, word);
    if(mounted) Navigator.pop(context);
  }

  Future<void> deleteWord() async{
    await DatabaseService.deleteWord(word.id!);
    if(mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('단어 수정')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('단어'),
              TextField(controller: wordControl, maxLines: 1),
              SizedBox(height: 16),
              Text('품사'),
              TextField(controller: partOfSpeechControl, maxLines: 1),
              SizedBox(height: 16),
              Text('의미'),
              TextField(controller: meaningControl),
              SizedBox(height: 16),
              Text('예문'),
              TextField(controller: exampleControl),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: saveWord,
                      child: Text('저장')
                    )
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: deleteWord,
                      child: Text('삭제'))
                    )
                ]
              )
            ]
          )
        )
      )
    );
  }
}