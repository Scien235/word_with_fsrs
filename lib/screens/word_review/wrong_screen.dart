import 'package:flutter/material.dart';
import '/models/word.dart';
import 'review_screen.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'dart:convert';
import '/services/database_service.dart';
class WrongScreen extends StatelessWidget{
  final List<Word> dueWordList;
  final int curIdx;

  WrongScreen({
    required this.dueWordList,
    required this.curIdx
  });

  Word get cur => dueWordList[curIdx];
  Future<void> applyAgain() async{
    final scheduler = fsrs.Scheduler();
    fsrs.Card card;
    if(cur.dataFsrs == null) card = fsrs.Card(cardId: cur.id ?? 0);
    else card = fsrs.Card.fromMap(jsonDecode(cur.dataFsrs!));
    final res = scheduler.reviewCard(card, fsrs.Rating.again);
    cur.dataFsrs = jsonEncode(res.card.toMap());
    await DatabaseService.updateWord(cur.id!, cur);
    dueWordList.add(cur);
  }
  @override
  Widget build(BuildContext context){
    return PopScope(canPop: false, child: Scaffold(
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              await applyAgain();
              if(!context.mounted) return;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ReviewScreen(
                          dueWordList: dueWordList,
                          curIdx: curIdx,
                          isCorrect: false
                      )
                  )
              );
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('틀렸습니다!',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('정답: ${cur.word}',
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
        )
      )
    ));
  }
}