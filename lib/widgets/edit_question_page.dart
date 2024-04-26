import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/create_surveys_page/widgets/SurveyDetailsPage.dart';

class EditQuestionPage extends StatefulWidget {
  @override
  _EditQuestionPageState createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  String surveyName = '';
  String clientName = '';
  String projectName = '';

  List<Question> questions = [
    Question(
      question: 'Question 1',
      choices: ['Choice 1', 'Choice 2', 'Choice 3'],
    ),
    Question(
      question: 'Question 2',
      choices: ['Choice A', 'Choice B', 'Choice C'],
    ),
    Question(
      question: 'Question 3',
      choices: ['Yes', 'No', 'Maybe'],
    ),
    Question(
      question: 'Question 4',
      choices: ['Option X', 'Option Y', 'Option Z'],
    ),
    Question(
      question: 'Feedback', choices: [],

    ),
  ];

  Future<void> _saveSurvey() async {
    // Get a reference to the Firestore service
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Save survey names to 'surveys' collection
    DocumentReference surveyDocRef = await firestore.collection('surveys').add({
      'surveyName': surveyName,
      'clientName': clientName,
      'projectName': projectName,
    });

    // Prepare list of questions with choices
    List<Map<String, dynamic>> questionsData = questions.map((question) {
      return {
        'question': question.question,
        'choices': question.choices,
      };
    }).toList();

    // Save questions to 'survey_questions' collection
    await firestore.collection('survey_questions').doc(surveyDocRef.id).set({
      'questions': questionsData,
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SurveyDetailPage(surveyId: surveyDocRef.id)),
    );


    print('Survey saved with ID: ${surveyDocRef.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Questions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: surveyName,
                onChanged: (value) {
                  setState(() {
                    surveyName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Survey Name',
                ),
              ),
              TextFormField(
                initialValue: clientName,
                onChanged: (value) {
                  setState(() {
                    clientName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Client Name',
                ),
              ),
              TextFormField(
                initialValue: projectName,
                onChanged: (value) {
                  setState(() {
                    projectName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Project Name',
                ),
              ),
              SizedBox(height: 16.0),
              for (var i = 0; i < questions.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: questions[i].question,
                      onChanged: (value) {
                        setState(() {
                          questions[i].question = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Question ${i + 1}',
                      ),
                    ),
                    if (i != questions.length - 1) ...[
                      for (var j = 0; j < questions[i].choices.length; j++)
                        TextFormField(
                          initialValue: questions[i].choices[j],
                          onChanged: (value) {
                            setState(() {
                              questions[i].choices[j] = value ?? '';
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Choice ${j + 1}',
                          ),
                        ),
                    ] ,
                    SizedBox(height: 16.0),
                  ],
                ),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSurvey,

                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Question {
  String question;
  List<String> choices;

  Question({
    required this.question,
    required this.choices,
  });
}
