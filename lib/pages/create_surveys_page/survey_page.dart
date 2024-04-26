// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class SurveyPage extends StatefulWidget {
//     String? projectName;
//     String? clientName;
//     String? eventName;
//     String? surveyId;
//
//     SurveyPage({
//     Key? key,
//       this.projectName,
//       this.clientName,
//       this.eventName,
//       this.surveyId,
//   }) : super(key: key);
//
//   @override
//   _SurveyPageState createState() => _SurveyPageState();
// }
//
// class _SurveyPageState extends State<SurveyPage>with WidgetsBindingObserver {
//   late Map<String, dynamic> surveyData= {};
//
//   Map<String, String?> answers = {
//     'q1': null,
//     'q2': null,
//     'q3': null,
//     'q4': null,
//     'q5': null,
//   };
//
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     print("ibadkhan");
//     WidgetsBinding.instance.addObserver(this);
//
//     fetchSurveyData();
//   }
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     fetchSurveyData();
//
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//   void fetchSurveyData() async {
//     try {
// print("fetchSurveyData ibad");
//       DocumentSnapshot surveyNamesSnapshot =
//       await FirebaseFirestore.instance.collection('survey_names').doc(widget.surveyId).get();
//       if (surveyNamesSnapshot.exists) {
//         setState(() {
//            surveyData = surveyNamesSnapshot.data() as Map<String, dynamic>;
//         });
//         print("surveyData from firebase");
//         print(surveyData);
//       }
//     } catch (e) {
//       print('Error fetching survey data: $e');
//     }
//   }
//
//
//
//   bool validate() {
//     return answers.values.every((value) => value != null);
//   }
//
//   void submitSurvey() async {
//     try {
//       if (!validate()) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Error'),
//               content: const Text('Please answer all questions before submitting the survey.'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//
//       final surveyData = {
//         'surveyId': widget.surveyId,
//         'projectName': widget.projectName,
//         'clientName': widget.clientName,
//         'eventName': widget.eventName,
//         ...answers,
//         'timestamp': FieldValue.serverTimestamp(),
//       };
//
//       await FirebaseFirestore.instance.collection('surveys').doc(widget.surveyId).set(surveyData);
//
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Survey Submitted'),
//             content: const Text('Thank you for completing the survey.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//
//       setState(() {
//         answers = {
//           'q1': null,
//           'q2': null,
//           'q3': null,
//           'q4': null,
//           'q5': null,
//         };
//       });
//     } catch (e) {
//       print('Error submitting survey: $e');
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Error'),
//             content: const Text('An error occurred while submitting the survey.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint(" form survey ibad");
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Surveysadas'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (surveyData != null) ...[
//               Text('Project Name: ${surveyData['projectName']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//               const SizedBox(height: 10),
//               Text('Client Name: ${surveyData['clientName']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//               const SizedBox(height: 10),
//               Text('Event Name: ${surveyData['eventName']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//               const SizedBox(height: 20),
//             ],
//             SurveyQuestion(
//               question: 'How satisfied are you with the overall outcome of the project? Did we meet your expectations in terms of quality and deliverables?',
//               choices: ['Very satisfied', 'Satisfied', 'Neutral', 'Dissatisfied', 'Very dissatisfied'],
//               questionId: 'q1',
//               onChanged: (value) {
//                 setState(() {
//                   answers['q1'] = value;
//                 });
//               },
//             ),
//             SurveyQuestion(
//               question: 'How would you rate our communication throughout the project?',
//               choices: ['Excellent', 'Good', 'Average', 'Poor', 'Very poor'],
//               questionId: 'q2',
//               onChanged: (value) {
//                 setState(() {
//                   answers['q2'] = value;
//                 });
//               },
//             ),
//             SurveyQuestion(
//               question: 'Were you satisfied with the level of support on & off-site and guidance provided during the project?',
//               choices: ['Very effectively', 'Effectively', 'Moderately effectively', 'Ineffectively', 'Very ineffectively'],
//               questionId: 'q3',
//               onChanged: (value) {
//                 setState(() {
//                   answers['q3'] = value;
//                 });
//               },
//             ),
//             SurveyQuestion(
//               question: 'How likely are you to recommend our services to others based on your experience with this project?',
//               choices: ['Very likely', 'Likely', 'Neutral', 'Unlikely', 'Very unlikely'],
//               questionId: 'q4',
//               onChanged: (value) {
//                 setState(() {
//                   answers['q4'] = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             const Text('Is there any additional feedback or suggestions you would like to provide to help us improve our services in the future?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//             const SizedBox(height: 10),
//             TextField(
//               onChanged: (value) {
//                 setState(() {
//                   answers['q5'] = value;
//                 });
//               },
//               decoration: const InputDecoration(
//                 hintText: 'Additional feedback',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: submitSurvey,
//                 child: const Text('Submit'),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class SurveyQuestion extends StatefulWidget {
//   final String question;
//   final List<String> choices;
//   final String questionId;
//   final Function(String?) onChanged;
//
//   const SurveyQuestion({
//     Key? key,
//     required this.question,
//     required this.choices,
//     required this.questionId,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   _SurveyQuestionState createState() => _SurveyQuestionState();
// }
//
// class _SurveyQuestionState extends State<SurveyQuestion> {
//   String? selectedChoice;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.question, style: const TextStyle(fontSize: 18)),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: widget.choices.map((choice) {
//             return Row(
//               children: [
//                 Radio<String>(
//                   value: choice,
//                   groupValue: selectedChoice,
//                   onChanged: (value) {
//                     setState(() {
//                       selectedChoice = value;
//                     });
//                     widget.onChanged(value);
//                   },
//                 ),
//                 Text(choice),
//               ],
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  final String? surveyId;

  SurveyPage({this.surveyId});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
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
                  Navigator.pop(context);
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
      await FirebaseFirestore.instance.collection('survey_answers').add(surveyData);

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
                  Navigator.pop(context);
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
  @override
  void initState() {
    super.initState();
    // Fetch survey details if surveyId is provided
    if (widget.surveyId != null) {
      FirebaseFirestore.instance.collection('surveys').doc(widget.surveyId).get().then((snapshot) {
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Client Name: ${clientName ?? "Loading..."}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ), Text(
                'Project Name: ${projectName ?? "Loading..."}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Add more survey details if needed
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
              const SizedBox(height: 20),
              const Text('Is there any additional feedback or suggestions you would like to provide to help us improve our services in the future?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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

                  onPressed: ()async{

                    submitSurvey();
                  },
                  child:   Text('Submit'),
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
        Text(widget.question, style: const TextStyle(fontSize: 18)),
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
