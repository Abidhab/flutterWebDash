import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SurveyListPage extends StatelessWidget {
  final Map<String, dynamic>? selectedSurveyData;

  SurveyListPage({this.selectedSurveyData});

  Future<void> deleteSurvey(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('survey_answers').doc(documentId).delete();
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('survey_answers').snapshots(),
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
              final surveyData = surveyDocs[index].data() as Map<String, dynamic>;
              final documentId = surveyDocs[index].id;
              final questions = [
                '1 How satisfied are you with the overall outcome of the project? Did we meet your expectations in terms of quality and deliverables?',
                '2 How would you rate our communication throughout the project?',
                '3 Were you satisfied with the level of support on & off-site and guidance provided during the project?',
                '4 How likely are you to recommend our services to others based on your experience with this project?',
                '5 Is there any additional feedback or suggestions you would like to provide to help us improve our services in the future?',
              ];

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
                        subtitle: Text('Client Name: ${surveyData['clientName']}'),
                      ),
                      ListTile(
                        title: Text('Project Name: ${surveyData['projectName']}'),
                      ),
                      for (int i = 0; i < questions.length; i++)
                        ListTile(
                          title: Text(questions[i]),
                          subtitle: Text('Answer: ${surveyData['answers']['q${i + 1}'] ?? 'Not answered'}'),
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
