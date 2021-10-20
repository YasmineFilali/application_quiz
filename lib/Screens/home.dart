import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:application_quiz/helper/functions.dart';
import 'package:application_quiz/Service/database.dart';
import 'package:application_quiz/Screens/create_quiz.dart';
import 'package:application_quiz/Screens/play_quiz.dart';
import 'package:application_quiz/widgets/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Stream quizStream;

  DatabaseService _databaseService = new DatabaseService();

  bool _isLoading = true;

  Widget quizList(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder (
        stream: quizStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
          ? Container(
            child: Center(child: Text("Aucun quiz disponible", style: TextStyle(fontSize: 18, color: Colors.red),)),
          ) :
          ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
                return QuizTile(
                    imageUrl: snapshot.data.docs[index].data()["quizImgUrl"],
                    title: snapshot.data.docs[index].data()["quizTitle"],
                    description: snapshot.data.docs[index].data()["quizDescription"],
                    quizId: snapshot.data.docs[index].data()["quizId"]
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
        actions: [
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ),
    );
  }
}

class QuizTile extends StatelessWidget {

  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  QuizTile({required this.imageUrl, required this.title, required this.description, required this.quizId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return PlayQuiz(quizId);
        }));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl, width: MediaQuery.of(context).size.width - 48, fit: BoxFit.cover,)
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black26
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),),
                  SizedBox(height: 6,),
                  Text(description, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
