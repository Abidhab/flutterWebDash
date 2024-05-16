// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class SurveyListPage extends StatelessWidget {
//   final Map<String, dynamic>? selectedSurveyData;
//
//   SurveyListPage({this.selectedSurveyData});
//
//   Future<void> deleteSurvey(String documentId) async {
//     try {
//       await FirebaseFirestore.instance.collection('survey_answers').doc(documentId).delete();
//     } catch (error) {
//       print('Failed to delete survey: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Survey Data'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('survey_answers').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           final surveyDocs = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: surveyDocs.length,
//             itemBuilder: (context, index) {
//               final surveyData = surveyDocs[index].data() as Map<String, dynamic>;
//               final documentId = surveyDocs[index].id;
//               final questions = [
//                 '1 How satisfied are you with the overall outcome of the project? Did we meet your expectations in terms of quality and deliverables?',
//                 '2 How would you rate our communication throughout the project?',
//                 '3 Were you satisfied with the level of support on & off-site and guidance provided during the project?',
//                 '4 How likely are you to recommend our services to others based on your experience with this project?',
//                 '5 Is there any additional feedback or suggestions you would like to provide to help us improve our services in the future?',
//               ];
//
//               return Card(
//                 elevation: 3,
//                 margin: EdgeInsets.all(8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ListTile(
//                         title: Text('Survey Name: ${surveyData['surveyName']}'),
//                         subtitle: Text('Client Name: ${surveyData['clientName']}'),
//                       ),
//                       ListTile(
//                         title: Text('Project Name: ${surveyData['projectName']}'),
//                       ),
//                       for (int i = 0; i < questions.length; i++)
//                         ListTile(
//                           title: Text(questions[i]),
//                           subtitle: Text('Answer: ${surveyData['answers']['q${i + 1}'] ?? 'Not answered'}'),
//                         ),
//                       Align(
//                         alignment: Alignment.topRight,
//                         child: IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () {
//                             deleteSurvey(documentId);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SurveyListPage extends StatelessWidget {
  final Map<String, dynamic>? selectedSurveyData;

  SurveyListPage({this.selectedSurveyData});

  Future<void> deleteSurvey(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('survey_answers')
          .doc(documentId)
          .delete();
    } catch (error) {
      print('Failed to delete survey: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Data'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('survey_answers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final surveyDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: surveyDocs.length,
            itemBuilder: (context, index) {
              final surveyData =
                  surveyDocs[index].data() as Map<String, dynamic>;
              final documentId = surveyDocs[index].id;

              return Card(
                elevation: 3,
                margin: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Survey Name: ${surveyData['surveyName']}'),
                        subtitle:
                            Text('Client Name: ${surveyData['clientName']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurveyDetailPage(
                                  surveyId: surveyData['surveyId']),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title:
                            Text('Project Name: ${surveyData['projectName']}'),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteSurvey(documentId);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SurveyDetailPage extends StatefulWidget {
  final String surveyId;

  SurveyDetailPage({required this.surveyId});

  @override
  _SurveyDetailPageState createState() => _SurveyDetailPageState();
}

class _SurveyDetailPageState extends State<SurveyDetailPage> {
  late Future<Map<String, dynamic>> _surveyDataFuture;

  @override
  void initState() {
    super.initState();
    _surveyDataFuture = _fetchSurveyData();
  }

  Future<Map<String, dynamic>> _fetchSurveyData() async {
    // Fetch survey answers
    QuerySnapshot answerSnapshot = await FirebaseFirestore.instance
        .collection('survey_answers')
        .where('surveyId', isEqualTo: widget.surveyId)
        .get();

    if (answerSnapshot.docs.isEmpty) {
      throw Exception('No answers found for this survey.');
    }

    var answerData = answerSnapshot.docs.first.data() as Map<String, dynamic>;

    // Fetch survey questions
    DocumentSnapshot questionSnapshot = await FirebaseFirestore.instance
        .collection('survey_questions')
        .doc(widget.surveyId)
        .get();

    if (!questionSnapshot.exists) {
      throw Exception('No questions found for this survey.');
    }

    var questionData = questionSnapshot.data() as Map<String, dynamic>;

    return {
      'answers': answerData,
      'questions': questionData,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _surveyDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          var surveyData = snapshot.data!;
          var answers =
              surveyData['answers']['answers'] as Map<String, dynamic>;
          var questions = surveyData['questions']['questions'] as List<dynamic>;

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              var question = questions[index] as Map<String, dynamic>;
              var questionText = question['question'];
              var answer = answers['q${index + 1}'] ?? 'Not answered';

              return Card(
                elevation: 3,
                margin: EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${index + 1}: $questionText',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Answer: $answer'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
