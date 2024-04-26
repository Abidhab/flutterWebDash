// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:uuid/uuid.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
// import '../../../routing/routes.dart';
// import '../survey_page.dart';
// import 'dart:html';
// import 'dart:js' as js;
//
//
// class SurveyCreator extends StatelessWidget {
//   final TextEditingController projectNameController = TextEditingController();
//   final TextEditingController clientNameController = TextEditingController();
//   final TextEditingController eventNameController = TextEditingController();
//
//   void createSurvey() async {
//     String surveyId = Uuid().v4();
//     String projectName = projectNameController.text;
//     String clientName = clientNameController.text;
//     String eventName = eventNameController.text;
//
//
//
//
//     // Generate the survey link
//     String surveyLink = '${Uri.base.origin}/#/test?id=$surveyId';
//
//  print("surveyLink");
// print(surveyLink);
//     // Copy the survey link to the clipboard
//     Clipboard.setData(ClipboardData(text: surveyLink));
//
//     // Show a snackbar indicating the survey ID and link are copied
//     Get.snackbar(
//       'Survey Created',
//       'Survey ID: $surveyId\nSurvey Link copied to clipboard',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//
//     // Save project, client, and event names to Firebase Firestore
//     await FirebaseFirestore.instance.collection('survey_names').doc(surveyId).set({
//       'projectName': projectName,
//       'clientName': clientName,
//       'eventName': eventName,
//     });
//     js.context.callMethod('open', [surveyLink]);
//
//     // Get.to(() => SurveyPage(
//     //   surveyId: surveyId,
//     //   projectName: projectName,
//     //   clientName: clientName,
//     //   eventName: eventName,
//     // ));
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Padding(
//       padding: EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           TextField(
//             controller: projectNameController,
//             decoration: InputDecoration(labelText: 'Project Name'),
//           ),
//           SizedBox(height: 20.0),
//           TextField(
//             controller: clientNameController,
//             decoration: InputDecoration(labelText: 'Client Name'),
//           ),
//           SizedBox(height: 20.0),
//           TextField(
//             controller: eventNameController,
//             decoration: InputDecoration(labelText: 'Event Name'),
//           ),
//           SizedBox(height: 20.0),
//           ElevatedButton(
//             onPressed: createSurvey,
//             child: Text('Create New Survey'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_dashboard/routing/routes.dart';
import 'package:flutter_web_dashboard/pages/create_surveys_page/survey_page.dart';
import 'dart:js' as js;


class SurveyCreator extends StatefulWidget {
  @override
  _SurveyCreatorState createState() => _SurveyCreatorState();
}

class _SurveyCreatorState extends State<SurveyCreator> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _surveyNameController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();

  void _createSurvey() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('surveys').add({
        'surveyName': _surveyNameController.text,
        'clientName': _clientNameController.text,
        'projectName': _projectNameController.text,
      }).then((value) {
        print('Survey created and stored successfully!');
        FirebaseFirestore.instance.collection('surveys').doc(value.id).update({
          'surveyId': value.id,
        });

        String surveyLink = '${Uri.base.origin}/survey?id=${value.id}';
        print('Survey link: $surveyLink');
        js.context.callMethod('open', [surveyLink]);
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        //   builder: (context) => SurveyPage(surveyId: value.id),
        // ), (route) => false);

      }).catchError((error) {
        print('Failed to create survey: $error');
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _surveyNameController,
              decoration: InputDecoration(labelText: 'Survey Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter survey name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _clientNameController,
              decoration: InputDecoration(labelText: 'Client Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter client name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _projectNameController,
              decoration: InputDecoration(labelText: 'Project Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter project name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createSurvey,
              child: Text('Create Survey'),
            ),
          ],
        ),
      ),
    );
  }
}
