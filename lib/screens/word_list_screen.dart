import 'package:flutter/material.dart';
import '/models/word.dart';
import '/services/database_service.dart';
import '/screens/word_edit_screen.dart';

class WordListScreen extends StatefulWidget{
  WordListScreen();

  @override
  State<StatefulWidget> createState() => WordListScreenState();
}

class WordListScreenState extends State<WordListScreen>{
  Future<List<Word>>? wordList;

  @override
  void initState(){
    super.initState();
    wordList = DatabaseService.getWordList();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('단어 목록')),
      body: FutureBuilder<List<Word>>(
        future: wordList,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if(!snapshot.hasData||snapshot.data == null||snapshot.data!.isEmpty)
            return Center(child: Text('단어가 없습니다'));
          final gottenWordList = snapshot.data!;
          return Column(
            children: [
              Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(4),
                  4: FlexColumnWidth(2)
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Color(0xFFEEEEEE)),
                    children:[
                      Padding(padding: EdgeInsets.all(8), child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.all(8), child: Text('단어', style: TextStyle(fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.all(8), child: Text('품사', style: TextStyle(fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.all(8), child: Text('의미', style: TextStyle(fontWeight: FontWeight.bold))),
                      Padding(padding: EdgeInsets.all(8), child: Text('예문', style: TextStyle(fontWeight: FontWeight.bold)))
                    ]
                  )
                ]
              ),
              Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: gottenWordList.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  itemBuilder: (_, idx){
                    final tmp = gottenWordList[idx];
                    return InkWell(
                      onTap: () async{
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => WordEditScreen(word: tmp))
                        );
                        print('돌아왔어요');
                        setState(() {
                          print('setState 실행');
                          wordList = DatabaseService.getWordList();
                          });
                      },
                      child: Table(
                        columnWidths:{
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(4),
                          4: FlexColumnWidth(2)
                        },
                        children: [
                          TableRow(
                            children:[
                              Padding(padding: EdgeInsets.all(8),
                              child: Text('${tmp.id}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                              Padding(padding: EdgeInsets.all(8), child: Text('${tmp.word}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                              Padding(padding: EdgeInsets.all(8), child: Text('${tmp.partOfSpeech ?? ""}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                              Padding(padding: EdgeInsets.all(8), child: Text('${tmp.meaning ?? ""}', maxLines: 1, overflow: TextOverflow.ellipsis)),
                              Padding(padding: EdgeInsets.all(8), child: Text('${tmp.example ?? ""}', maxLines: 1, overflow: TextOverflow.ellipsis))
                            ]
                          )
                        ]
                      )
                    );
                  },

                )
              )
            ]
          );
        }
      )
    );
  }

}
