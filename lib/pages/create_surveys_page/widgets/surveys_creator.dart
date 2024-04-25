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

class SurveyCreator extends StatelessWidget {
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();

  void createSurvey() async {
    String surveyId = Uuid().v4();
    String projectName = projectNameController.text;
    String clientName = clientNameController.text;
    String eventName = eventNameController.text;

    // Generate the survey link
    String surveyLink = '${Uri.base.origin}/#/MySur?id=$surveyId';
    print(surveyLink);
    js.context.callMethod('open', [surveyLink]);
    Get.off(() => SurveyPage(
      surveyId: surveyId,
      projectName: projectName,
      clientName: clientName,
      eventName: eventName,
    ));
    // Save project, client, and event names to Firebase Firestore
    await FirebaseFirestore.instance.collection('survey_names').doc(surveyId).set({
      'projectName': projectName,
      'clientName': clientName,
      'eventName': eventName,
    });


    // Redirect to the survey page

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: projectNameController,
            decoration: InputDecoration(labelText: 'Project Name'),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: clientNameController,
            decoration: InputDecoration(labelText: 'Client Name'),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: eventNameController,
            decoration: InputDecoration(labelText: 'Event Name'),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: createSurvey,
            child: Text('Create New Survey'),
          ),
        ],
      ),
    );
  }
}
