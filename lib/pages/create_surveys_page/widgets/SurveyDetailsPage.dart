import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SurveyDetailPage extends StatefulWidget {
  final String? surveyId;

  SurveyDetailPage({this.surveyId});

  @override
  _SurveyDetailPageState createState() => _SurveyDetailPageState();
}

class _SurveyDetailPageState extends State<SurveyDetailPage> {
  String? surveyName;
  String? clientName;
  String? projectName;
  Map<String, String?> answers = {
    'q1': null,
    'q2': null,
    'q3': null,
    'q4': null,
    'q5': null,
  };
  void submitSurvey() async {
    // Validate if all questions are answered
    if (!validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please answer all questions before submitting.'),
            actions: [
              TextButton(
                onPressed: () {
                  html.window.location.href =
                      'about:blank'; // This will make the page blank
                  // Alternatively, you can use:
                  // html.window.close(); // This will close the entire web page
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Convert answers map to a format compatible with Firestore
    Map<String, dynamic> firestoreAnswers = {};
    answers.forEach((key, value) {
      firestoreAnswers[key] = value;
    });

    // Create a map to store survey answers
    Map<String, dynamic> surveyData = {
      'surveyId': widget.surveyId,
      'surveyName': surveyName,
      'clientName': clientName,
      'projectName': projectName,
      'answers': firestoreAnswers,
    };

    try {
      // Add the survey data to Firestore
      await FirebaseFirestore.instance
          .collection('survey_answers')
          .add(surveyData);

      // Show success message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Survey submitted successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the success dialog
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Failed to submit survey: $error');
      // Show error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit survey. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  bool validate() {
    return answers.values.every((value) => value != null);
  }

  late Future<List<Map<String, dynamic>>> _surveyQuestionsFuture;

  @override
  void initState() {
    super.initState();

    _surveyQuestionsFuture =
        SurveyService().getSurveyQuestions(widget.surveyId!);

    if (widget.surveyId != null) {
      FirebaseFirestore.instance
          .collection('surveys')
          .doc(widget.surveyId)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            surveyName = snapshot['surveyName'];
            clientName = snapshot['clientName'];
            projectName = snapshot['projectName'];
          });
        } else {
          print('Document does not exist');
        }
      }).catchError((error) {
        print('Failed to fetch survey details: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Survey Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Survey Name: ${surveyName ?? "Loading..."}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                'Client Name: ${clientName ?? "Loading..."}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                'Project Name: ${projectName ?? "Loading..."}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              // Add more survey details if needed
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _surveyQuestionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No questions found.'));
                  } else {
                    List<Map<String, dynamic>> questions = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> questionData = questions[index];
                        String question = questionData['question'];
                        List<String> choices =
                            List<String>.from(questionData['choices']);
                        String questionId = 'q${index + 1}';

                        // Initialize answers map with null values if not already initialized
                        answers.putIfAbsent(questionId, () => null);

                        return SurveyQuestion(
                          question: question,
                          choices: choices,
                          questionId: questionId,
                          onChanged: (value) {
                            setState(() {
                              answers[questionId] = value;
                            });
                          },
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                  'Is there any additional feedback or suggestions you would like to provide to help us improve our services in the future?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    answers['q5'] = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Additional feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    submitSurvey();
                  },
                  child: Text('Submit'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
        Text(widget.question,
            style: const TextStyle(fontSize: 18, color: Colors.black)),
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
                Text(
                  choice,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SurveyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getSurveyQuestions(String surveyId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('survey_questions').doc(surveyId).get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('questions')) {
          return List<Map<String, dynamic>>.from(data['questions']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching survey questions: $e');
      return [];
    }
  }
}
