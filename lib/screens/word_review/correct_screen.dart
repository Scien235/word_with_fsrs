import 'package:flutter/material.dart';
import '/models/word.dart';
import 'review_screen.dart';

class CorrectScreen extends StatelessWidget{
  final List<Word> dueWordList;
  final int curIdx;

  CorrectScreen({
    required this.dueWordList,
    required this.curIdx
  });

  @override
  Widget build(BuildContext context){
    return PopScope(
        canPop: false,
        child: Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ReviewScreen(
                dueWordList: dueWordList,
                curIdx: curIdx,
                isCorrect: true
                )
              )
            ),
            child: Center(
              child: Text('맞았습니다!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))
          )
        )
      )
    );
  }
}
