import 'package:flutter/material.dart';
import '/models/word.dart';
import 'difficulty_screen.dart';
import 'completion_screen.dart';
import 'input_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class ReviewScreen extends StatelessWidget{
  final List<Word> dueWordList;
  final int curIdx;
  final bool isCorrect;

  ReviewScreen({
    required this.dueWordList,
    required this.curIdx,
    required this.isCorrect
  });
  Word get cur => dueWordList[curIdx];

  void next(BuildContext context){
    if(isCorrect){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DifficultyScreen(
            dueWordList: dueWordList,
            curIdx: curIdx
          )
        )
      );
    }
    else{
      final nxtIdx = curIdx + 1;
      if(nxtIdx < dueWordList.length)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => InputScreen(
                dueWordList: dueWordList,
                curIdx: nxtIdx
              ))
        );
      else
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CompletionScreen())
        );
    }
  }

  @override
  Widget build(BuildContext context){
    return PopScope(canPop: false, child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('복습')
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => next(context),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cur.word,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                  ),
                  if(cur.audioUrl != null)
                    IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () async {
                        final player = AudioPlayer();
                        await player.play(UrlSource(cur.audioUrl!));
                      }
                    )
                ]
              ),
              SizedBox(height: 16),
              if(cur.meaning != null && cur.meaning!.trim().isNotEmpty)...[
                Text('의미: ${cur.partOfSpeech != null && cur.partOfSpeech!.trim().isNotEmpty ? '${cur.partOfSpeech}. ' : ''}${cur.meaning ?? ''}'),
                SizedBox(height: 16)
              ],
              if(cur.example != null && cur.example!.trim().isNotEmpty)...[
                Text('예문: ${cur.example}'),
                SizedBox(height: 16)
              ]
            ]
          )
        )
      )
    ));
  }
}