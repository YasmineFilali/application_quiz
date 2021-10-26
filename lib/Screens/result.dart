import 'package:application_quiz/Screens/quiz_list.dart';
import 'package:application_quiz/widgets/ChangeThemeButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:application_quiz/Screens/home.dart';
import 'package:application_quiz/widgets/widgets.dart';

class Results extends StatefulWidget {

  final int correct, incorrect, total;
  Results({required this.correct, required this.incorrect, required this.total});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        actions: <Widget>[
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => QuizList()));
              },
              icon: Icon(Icons.list_alt_sharp, color: Colors.white,)
          ),
          ChangeThemeButtonWidget(),
        ],

      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Score : ${widget.correct}/${widget.total}", style: TextStyle(fontSize: 25),),
              SizedBox(height: 8,),
              Text("Bonne réponse : ${widget.correct}", style: TextStyle(fontSize: 16, color: Colors.green), textAlign: TextAlign.center,),
              SizedBox(height: 8,),
              Text("Mauvaise réponse : ${widget.incorrect}", style: TextStyle(fontSize: 16, color: Colors.red), textAlign: TextAlign.center,),

              SizedBox(height: 20,),
              GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Button2(context, "Retourner a la page d'accueil", MediaQuery.of(context).size.width/1.5, Colors.blueAccent)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
