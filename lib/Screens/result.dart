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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Réponses correctes / Total : ${widget.correct}/${widget.total}", style: TextStyle(fontSize: 25),),
              SizedBox(height: 8,),
              Text("Bonne réponse : ${widget.correct}", style: TextStyle(fontSize: 16, color: Colors.green), textAlign: TextAlign.center,),
              SizedBox(height: 8,),
              Text("Mauvaise réponse : ${widget.incorrect}", style: TextStyle(fontSize: 16, color: Colors.red), textAlign: TextAlign.center,),

              SizedBox(height: 20,),
              GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: orangeButton(context, "Retour a l’accueil ", MediaQuery.of(context).size.width/2, Colors.blueAccent)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
