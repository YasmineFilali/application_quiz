import 'package:flutter/material.dart';
import 'package:application_quiz/Service/database.dart';
import 'package:application_quiz/widgets/widgets.dart';

class QuizList extends StatefulWidget {
  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {

  late Stream quizStream;

  DatabaseService _databaseService = new DatabaseService();

  bool _isLoading = true;

  Widget quizList(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot){
          return snapshot == null ?
          Container(
            child: Center(child: Text("Aucun quiz disponible", style: TextStyle(fontSize: 18, color: Colors.red),)),
          ) :
          ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
                return QuizEditTile(
                    title: snapshot.data.docs[index].data()["quizTitle"],
                    quizId: snapshot.data["quizId"]
                );
              });
        },
      ),
    );
  }

  @override
  void initState() {
    _databaseService.getQuizData().then((value){
      setState(() {
        quizStream = value;
        _isLoading = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : quizList(),
    );
  }
}
