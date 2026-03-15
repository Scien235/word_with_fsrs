import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/screens/home_screen.dart';

void main() {
  runApp(const WordWithFsrs());
}

class WordWithFsrs extends StatelessWidget{
  const WordWithFsrs({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: '영단어 암기장',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0x1B749C),
          brightness: Brightness.light),
        textTheme: GoogleFonts.notoSansTextTheme()
      ),
      home: HomeScreen()
    );
  }
}
