import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore ref = FirebaseFirestore.instance;
class DatabaseService{
Future<void> addQuizData(Map quizData, String quizId) async{
  await ref.collection("Quiz").doc(quizId).set(quizData).catchError((e){print(e.toString());});
}

Future<void> addQuestionData(Map questionData, String quizId, String questionId) async{
  await ref.collection("Quiz").doc(quizId).collection("QNA").doc(questionId).set(questionData).catchError((e){
    print(e.toString());
  });
}

getQuizData() async{
  return await ref.collection("Quiz").snapshots();
}

getQuestionData(String quizId) async{
  return await ref.collection("Quiz").doc(quizId).collection("QNA").get();
}
}