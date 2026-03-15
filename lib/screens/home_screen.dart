import 'package:flutter/material.dart';
import '/models/word.dart';
import '/services/database_service.dart';
import '/screens/search_screen.dart';
import '/screens/word_list_screen.dart';
import '/screens/word_review/input_screen.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen();

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{
  List<Word> dueWordList = [];
  String searchWord = "";

  @override
  void initState(){
    super.initState();
    getDueWordList();
  }

  Future<void> getDueWordList() async{
    final wordList = await DatabaseService.getDueWords();
    if(mounted) setState(() => dueWordList = wordList);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('영단어 암기장'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () async{
              await Navigator.push(context, MaterialPageRoute(builder: (_) => WordListScreen()));
              getDueWordList();
            }
          )
        ]
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: '단어를 검색하세요', border: OutlineInputBorder()),
              onChanged: (tmp) => searchWord = tmp,
              onSubmitted: (word) async{
                if(word.trim().isEmpty) return;
                await Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen(searchWord: word)));
                getDueWordList();
              }
            ),
            SizedBox(height: 24),
            Text('오늘 암기할 단어: ${dueWordList.length}개', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            IconButton(
              iconSize: 64,
              icon: Icon(
                Icons.play_circle_filled,
                color: dueWordList.isEmpty ? Colors.grey : Colors.red
              ),
              onPressed: dueWordList.isEmpty ? null : () async{
                await Navigator.push(context, MaterialPageRoute(builder: (_) => InputScreen(dueWordList: dueWordList, curIdx: 0)));
                getDueWordList();
              },
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () => showLicensePage(context: context,
                applicationName: '영단어 암기장',
                applicationVersion: '1.0.0',
              ),
              child: Text('License'),
            ),
          ]
        )
      )
    );
  }
}