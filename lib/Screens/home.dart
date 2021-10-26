import 'package:application_quiz/Screens/quiz_list.dart';
import 'package:application_quiz/provider/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:application_quiz/Service/database.dart';
import 'package:application_quiz/Screens/create_quiz.dart';
import 'package:application_quiz/Screens/play_quiz.dart';
import 'package:application_quiz/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../widgets/ChangeThemeButtonWidget.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  DatabaseService _databaseService = new DatabaseService();
  Stream collectionStream = FirebaseFirestore.instance.collection('Quiz').snapshots();
  bool _isLoading = true;

  Widget quizList(){
    return Container(
      margin: const EdgeInsets.only(left: 24.0, right: 24.0, top: 34.0),

      //margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder (
          stream: collectionStream,
          builder: (context, AsyncSnapshot snapshot) {
            if(snapshot.data == null ){
              return Container(
                child: Center(child: Text("Aucun Quiz disponible",
                  style: TextStyle(fontSize: 18, color: Colors.red),)),
              ); }
            else{
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return QuizTile(
                        imageUrl: snapshot.data.docs[index].data()["quizImgUrl"],
                        title: snapshot.data.docs[index].data()["quizTitle"],
                        description: snapshot.data.docs[index].data()["quizDescription"],
                        quizId: snapshot.data.docs[index].data()["quizId"]
                    );
                  });
            };}
      ),
    );
  }

  @override
  void initState() {
    _databaseService.getQuizData().then((value){
      setState(() {
        collectionStream = value;
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? 'DarkTheme'
        : 'LightTheme';

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
        backgroundColor: Colors.blueGrey,

      ),
      body: _isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : quizList(),

      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateQuiz()));
          }
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
        margin: EdgeInsets.only(bottom: 30),
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
