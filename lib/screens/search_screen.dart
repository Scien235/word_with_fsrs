import 'package:flutter/material.dart';
import '/models/word.dart';
import '/services/database_service.dart';
import '/services/wordSearch_service.dart';

class SearchScreen extends StatelessWidget{
  final String searchWord;

  SearchScreen({required this.searchWord});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: Text(searchWord)),
        body: FutureBuilder<List<Word>?>(
            future: WordSearch.find(searchWord),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else if(!snapshot.hasData||snapshot.data == null)
                return Center(child: Text('단어를 찾을 수 없습니다!'));
              final res = snapshot.data!;
              return Column(
                  children: [
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(4),
                        3: FlexColumnWidth(3)
                      },
                      children: [
                        TableRow(decoration: BoxDecoration(color: Color(0xFFEEEEEE)),
                          children: [
                            Padding(padding: EdgeInsets.all(8), child: Text('단어', style: TextStyle(fontWeight: FontWeight.bold))),
                            Padding(padding: EdgeInsets.all(8), child: Text('품사', style: TextStyle(fontWeight: FontWeight.bold))),
                            Padding(padding: EdgeInsets.all(8), child: Text('의미', style: TextStyle(fontWeight: FontWeight.bold))),
                            Padding(padding: EdgeInsets.all(8), child: Text('예문', style: TextStyle(fontWeight: FontWeight.bold)))
                          ],
                        ),
                      ],
                    ),
                    Divider(height: 1),
                    Expanded(
                      child: ListView.separated(
                        itemCount: res.length,
                        separatorBuilder: (_, __) => Divider(height: 1),
                        itemBuilder: (_, idx) {
                          final tmp = res[idx];
                          return InkWell(
                            onTap: () async {
                              await DatabaseService.insertWord(tmp);
                              if (!context.mounted) return;
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(1),
                                2: FlexColumnWidth(4),
                                3: FlexColumnWidth(3)
                              },
                              children: [
                                TableRow(
                                    children: [
                                      Padding(padding: EdgeInsets.all(8), child: Text('${tmp.word}')),
                                      Padding(padding: EdgeInsets.all(8), child: Text('${tmp.partOfSpeech ?? ""}')),
                                      Padding(padding: EdgeInsets.all(8), child: Text('${tmp.meaning ?? ""}')),
                                      Padding(padding: EdgeInsets.all(8), child: Text('${tmp.example ?? ""}'))
                                    ]
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )

                  ]
              );
            }
        )
    );
  }
}