import 'package:flutter/material.dart';

class CompletionScreen extends StatelessWidget{
  CompletionScreen();

  @override
  Widget build(BuildContext context){
    return PopScope(canPop: false, child: Scaffold(
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: Center(
              child: Text('복습이 끝났습니다!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)
            )
          )
        )
      )
    );
  }
}