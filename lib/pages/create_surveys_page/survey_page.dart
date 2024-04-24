import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:uuid/uuid.dart';

import '../../routing/routes.dart';

class SurveyPage extends StatefulWidget {
  final String projectName;
  final String clientName;
  final String eventName;
  final String surveyId;

  const SurveyPage({
    Key? key,
    required this.projectName,
    required this.clientName,
    required this.eventName,
    required this.surveyId,
  }) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  late Map<String, dynamic> surveyData= {};

  Map<String, String?> answers = {
    'q1': null,
    'q2': null,
    'q3': null,
    'q4': null,
    'q5': null,
  };

  @override
  void initState() {
    super.initState();
    fetchSurveyData();
  }

  void fetchSurveyData() async {
    try {
      DocumentSnapshot surveyNamesSnapshot =
      await FirebaseFirestore.instance.collection('survey_names').doc(widget.surveyId).get();
      if (surveyNamesSnapshot.exists) {
        setState(() {
          this.surveyData = surveyNamesSnapshot.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error fetching survey data: $e');
    }
  }



  bool validate() {
    return answers.values.every((value) => value != null);
  }

  void submitSurvey() async {
    try {
      if (!validate()) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please answer all questions before submitting the survey.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      final surveyData = {
        'surveyId': widget.surveyId,
        'projectName': widget.projectName,
        'clientName': widget.clientName,
        'eventName': widget.eventName,
        ...answers,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('surveys').doc(widget.surveyId).set(surveyData);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Survey Submitted'),
            content: Text('Thank you for completing the survey.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      setState(() {
        answers = {
          'q1': null,
          'q2': null,
          'q3': null,
          'q4': null,
          'q5': null,
        };
      });
    } catch (e) {
      print('Error submitting survey: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while submitting the survey.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (surveyData != null) ...[
              Text('Project Name: ${surveyData['projectName']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 10),
              Text('Client Name: ${surveyData['clientName']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 10),
              Text('Event Name: ${surveyData['eventName']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 20),
            ],
            SurveyQuestion(
              question: 'How satisfied are you with the overall outcome of the project? Did we meet your expectations in terms of quality and deliverables?',
              choices: ['Very satisfied', 'Satisfied', 'Neutral', 'Dissatisfied', 'Very dissatisfied'],
              questionId: 'q1',
              onChanged: (value) {
                setState(() {
                  answers['q1'] = value;
                });
              },
            ),
            SurveyQuestion(
              question: 'How would you rate our communication throughout the project?',
              choices: ['Excellent', 'Good', 'Average', 'Poor', 'Very poor'],
              questionId: 'q2',
              onChanged: (value) {
                setState(() {
                  answers['q2'] = value;
                });
              },
            ),
            SurveyQuestion(
              question: 'Were you satisfied with the level of support on & off-site and guidance provided during the project?',
              choices: ['Very effectively', 'Effectively', 'Moderately effectively', 'Ineffectively', 'Very ineffectively'],
              questionId: 'q3',
              onChanged: (value) {
                setState(() {
                  answers['q3'] = value;
                });
              },
            ),
            SurveyQuestion(
              question: 'How likely are you to recommend our services to others based on your experience with this project?',
              choices: ['Very likely', 'Likely', 'Neutral', 'Unlikely', 'Very unlikely'],
              questionId: 'q4',
              onChanged: (value) {
                setState(() {
                  answers['q4'] = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Is there any additional feedback or suggestions you would like to provide to help us improve our services in the future?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  answers['q5'] = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Additional feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: submitSurvey,
                child: Text('Submit'),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SurveyQuestion extends StatefulWidget {
  final String question;
  final List<String> choices;
  final String questionId;
  final Function(String?) onChanged;

  const SurveyQuestion({
    Key? key,
    required this.question,
    required this.choices,
    required this.questionId,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SurveyQuestionState createState() => _SurveyQuestionState();
}

class _SurveyQuestionState extends State<SurveyQuestion> {
  String? selectedChoice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.question, style: TextStyle(fontSize: 18)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.choices.map((choice) {
            return Row(
              children: [
                Radio<String>(
                  value: choice,
                  groupValue: selectedChoice,
                  onChanged: (value) {
                    setState(() {
                      selectedChoice = value;
                    });
                    widget.onChanged(value);
                  },
                ),
                Text(choice),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
