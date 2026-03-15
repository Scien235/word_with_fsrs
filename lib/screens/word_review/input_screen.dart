import 'package:flutter/material.dart';
import '/models/word.dart';
import 'correct_screen.dart';
import 'wrong_screen.dart';
class InputScreen extends StatelessWidget{
  final List<Word> dueWordList;
  final int curIdx;

  InputScreen({
    required this.dueWordList,
    required this.curIdx
  });
  Word get cur => dueWordList[curIdx];
  void check(BuildContext context, String a, String b){
    if(a.trim().toLowerCase() == b.trim().toLowerCase()){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CorrectScreen(
            dueWordList: dueWordList,
            curIdx: curIdx
          )
        )
      );
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WrongScreen(
            dueWordList: dueWordList,
            curIdx: curIdx
          )
        )
      );
    }
  }

  void skip(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WrongScreen(
          dueWordList: dueWordList,
          curIdx: curIdx
        )
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false, child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('${curIdx + 1} / ${dueWordList.length}')
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: '단어를 입력하세요',
                      border: OutlineInputBorder()
                    ),
                    onSubmitted: (typed) =>
                      check(context, this.dueWordList[curIdx].word, typed)
                  )
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => skip(context),
                  child: Text('모름')
                )
              ]
            ),
            SizedBox(height: 20),
            Text('의미: ${cur.partOfSpeech != null ? '${cur.partOfSpeech}. ' : ''}${cur.meaning ?? ''}'),
          ]
        )
      )
    )
    );
  }
}