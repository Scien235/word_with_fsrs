import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import '/models/word.dart';
import '/services/database_service.dart';
import 'input_screen.dart';
import 'completion_screen.dart';

class DifficultyScreen extends StatelessWidget{
  final List<Word> dueWordList;
  final int curIdx;

  DifficultyScreen({
    required this.dueWordList,
    required this.curIdx
  });

  Word get cur => dueWordList[curIdx];

  Future<void> applyRating(fsrs.Rating rating) async{
    final scheduler = fsrs.Scheduler();
    fsrs.Card card;
    if(cur.dataFsrs == null) card = fsrs.Card(cardId: cur.id ?? 0);
    else card = fsrs.Card.fromMap(jsonDecode(cur.dataFsrs!));
    final res = scheduler.reviewCard(card, rating);
    cur.dataFsrs = jsonEncode(res.card.toMap());
    await DatabaseService.updateWord(cur.id!, cur);

    if(rating == fsrs.Rating.hard) dueWordList.add(cur);
  }
  void next(BuildContext context){
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
    else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CompletionScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return PopScope(
      canPop: false,
        child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('난이도를 골라주세요', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
              Row(
                children:[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async{
                        await applyRating(fsrs.Rating.hard);
                        if(context.mounted) next(context);
                      },
                      child: Text('어려움')
                    )
                  ),
                  SizedBox(width: 8),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () async{
                            await applyRating(fsrs.Rating.good);
                            if(context.mounted) next(context);
                          },
                          child: Text('보통')
                      )
                  ),
                  SizedBox(width: 8),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () async{
                            await applyRating(fsrs.Rating.easy);
                            if(context.mounted) next(context);
                          },
                          child: Text('쉬움')
                      )
                  ),
                ]
              )
            ]
          )
        )
        )
    );
  }

}