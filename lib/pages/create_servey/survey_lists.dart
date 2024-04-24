import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('surveys').snapshots(),
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
              return _SurveyPage(
                projectName: surveyData['projectName'] ?? '',
                clientName: surveyData['clientName'] ?? '',
                eventName: surveyData['eventName'] ?? '',
                questions: [
                  '1. How satisfied are you with the overall outcome of the project? Did we meet your expectations in terms of quality and deliverables?',
                  '2. How would you rate our communication throughout the project?',
                  '3. Were you satisfied with the level of support on & off-site and guidance provided during the project?',
                  '4. How likely are you to recommend our services to others based on your experience with this project?',
                  '5. Is there any additional feedback or suggestions you would like to provide to help us improve our services in the future?',
                ],
                answers: [
                  surveyData['q1'],
                  surveyData['q2'],
                  surveyData['q3'],
                  surveyData['q4'],
                  surveyData['q5'],
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SurveyPage extends StatelessWidget {
  final String projectName;
  final String clientName;
  final String eventName;
  final List<String> questions;
  final List<String?> answers;

  _SurveyPage({
    required this.projectName,
    required this.clientName,
    required this.eventName,
    required this.questions,
    required this.answers,
  });

  void _deleteSurvey(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('surveys')
          .where('projectName', isEqualTo: projectName)
          .where('clientName', isEqualTo: clientName)
          .where('eventName', isEqualTo: eventName)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Survey deleted successfully'),
      ));
    } catch (e) {
      print('Error deleting survey: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting survey'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Project Name: $projectName', style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteSurvey(context),
                ),
              ],
            ),
            Text('Client Name: $clientName', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Event Name: $eventName', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            for (int i = 0; i < questions.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(questions[i]),
                  Text('Answer: ${answers[i] ?? 'Not provided'}'),
                  SizedBox(height: 8),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
