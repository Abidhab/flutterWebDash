import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/style.dart';
import 'package:flutter_web_dashboard/controllers/menu_controller.dart' as menu_controller;
import 'package:flutter_web_dashboard/controllers/navigation_controller.dart';
import 'package:flutter_web_dashboard/layout.dart';
import 'package:flutter_web_dashboard/pages/404/error.dart';
import 'package:flutter_web_dashboard/pages/authentication/authentication.dart';
import 'package:flutter_web_dashboard/pages/clients/clients.dart';
import 'package:flutter_web_dashboard/pages/create_surveys_page/create_surveys_page.dart';
import 'package:flutter_web_dashboard/pages/create_surveys_page/survey_page.dart';
import 'package:flutter_web_dashboard/pages/create_surveys_page/widgets/surveys_creator.dart';
import 'package:flutter_web_dashboard/pages/overview/overview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'routing/routes.dart';






void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCBAPA_OzRTZ0SuI5yl-4gLPfnZT5nXb-g",
      appId: "1:677880256454:web:aed71903507168e7f944c7",
      messagingSenderId: "677880256454",
      projectId: "admin-web-96428",
    ),
  );
  Get.put(menu_controller.MenuController());
  Get.put(NavigationController());
  String initialRoute = '/';
  String? surveyId;
  Uri? initialUri = Uri.base;
  if (initialUri != null && initialUri.path == '/survey' && initialUri.queryParameters.containsKey('id')) {
    initialRoute = '/survey';
    surveyId = initialUri.queryParameters['id'];
  }

  runApp(MyApp(initialRoute: initialRoute, surveyId: surveyId));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final String? surveyId;

  const MyApp({required this.initialRoute, this.surveyId});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: initialRoute,
      unknownRoute: GetPage(name: '/not-found', page: () => const PageNotFound(), transition: Transition.fadeIn),
      getPages: [

        GetPage(
          name: rootRoute,
          page: () => SiteLayout(),
        ),
        ///remove it
        GetPage(
          name: initialRoute,
          page: () => SurveyPage(
            surveyId: surveyId,
          ),
        ),
        GetPage(name: authenticationPageRoute, page: () => const AuthenticationPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
        primarySwatch: Colors.blue,
      ),

      // Survey page route
      routes: {
        '/survey': (context) => SurveyPage(
          surveyId: surveyId,
        ),
      },
        // home: const  AuthenticationPage(),
    );
  }
}



// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return
//       GetMaterialApp(
//       initialRoute: rootRoute,
//       unknownRoute: GetPage(name: '/not-found', page: () => const PageNotFound(), transition: Transition.fadeIn),
//       getPages: [
//         GetPage(
//             name: rootRoute,
//             page: () {
//               return SiteLayout();
//             }),
//         GetPage(name: authenticationPageRoute, page: () => const AuthenticationPage()),
//         GetPage(name: mySurveyPageRoute, page: () =>  SurveyPage(projectName: '', clientName: '', eventName: '', surveyId: '',)),
//
//       ],
//       debugShowCheckedModeBanner: false,
//       title: 'Dashboard',
//       theme: ThemeData(
//         scaffoldBackgroundColor: light,
//         textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
//         pageTransitionsTheme: const PageTransitionsTheme(builders: {
//           TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
//           TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
//         }),
//         primarySwatch: Colors.blue,
//       ),
//        // home: AuthenticationPage(),
//     );
//   }
// }

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_web_dashboard/constants/style.dart';
// import 'package:flutter_web_dashboard/controllers/menu_controller.dart' as menu_controller;
// import 'package:flutter_web_dashboard/controllers/navigation_controller.dart';
// import 'package:flutter_web_dashboard/layout.dart';
// import 'package:flutter_web_dashboard/pages/404/error.dart';
// import 'package:flutter_web_dashboard/pages/authentication/authentication.dart';
// import 'package:flutter_web_dashboard/pages/create_surveys_page/survey_page.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'routing/routes.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: "Your-API-Key",
//       appId: "Your-App-ID",
//       messagingSenderId: "Your-Messaging-Sender-ID",
//       projectId:"Your-Project-ID",
//     ),
//   );
//   // Initialize GetX controllers
//   Get.put(menu_controller.MenuController());
//   Get.put(NavigationController());
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       initialRoute: rootRoute,
//       unknownRoute: GetPage(
//         name: '/not-found',
//         page: () => const PageNotFound(),
//         transition: Transition.fadeIn,
//       ),
//       getPages: [
//         GetPage(
//           name: rootRoute,
//           page: () => SiteLayout(),
//         ),
//         GetPage(
//           name: authenticationPageRoute,
//           page: () => const AuthenticationPage(),
//         ),
//         GetPage(
//           name: mySurveyPageRoute, // Use mySurveyPageRoute here
//           page: () => const SurveyPage(), // Keep the page as const
//           transition: Transition.fadeIn,
//         ),
//         // Add other routes as needed
//       ],
//       debugShowCheckedModeBanner: false,
//       title: 'Dashboard',
//       theme: ThemeData(
//         scaffoldBackgroundColor: light,
//         textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
//         pageTransitionsTheme: const PageTransitionsTheme(builders: {
//           TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
//           TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
//         }),
//         primarySwatch: Colors.blue,
//       ),
//       // Use onGenerateRoute as the default handler for unknown routes
//       onGenerateRoute: (settings) {
//         if (settings.name == null) {
//           // Redirect to the not-found page if the route is null
//           return MaterialPageRoute(builder: (_) => PageNotFound());
//         }
//         if (settings.name == mySurveyPageRoute) {
//           // Extract parameters from the URL
//           final args = settings.arguments as Map<String, dynamic>? ?? {};
//           // Pass the parameters to the SurveyPage
//           return MaterialPageRoute(
//             builder: (context) => SurveyPage(
//               surveyId: args['id'],
//             ),
//           );
//         }
//         // Redirect to the not-found page if the route is not recognized
//         return MaterialPageRoute(builder: (_) => PageNotFound());
//       },
//     )
//     ;
//
//   }
// }
// //
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'dart:js' as js;
// // void main() async{
// //
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(
// //       options: const FirebaseOptions(
// //           apiKey: "AIzaSyCBAPA_OzRTZ0SuI5yl-4gLPfnZT5nXb-g",
// //           appId: "1:677880256454:web:aed71903507168e7f944c7",
// //           messagingSenderId: "677880256454",
// //           projectId:"admin-web-96428"));
// //   String initialRoute = '/';
// //   String? surveyId;
// //   Uri? initialUri = Uri.base;
// //   if (initialUri != null && initialUri.path == '/survey' && initialUri.queryParameters.containsKey('id')) {
// //     initialRoute = '/survey';
// //     surveyId = initialUri.queryParameters['id'];
// //   }
// //
// //   runApp(MyApp(initialRoute: initialRoute, surveyId: surveyId));
// // }
// //
// // class MyApp extends StatelessWidget {
// //   final String initialRoute;
// //   final String? surveyId;
// //
// //   MyApp({required this.initialRoute, this.surveyId});
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Survey App',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       initialRoute: initialRoute,
// //       routes: {
// //         '/': (context) => SurveyForm(),
// //         '/survey': (context) => SurveyPage(surveyId: surveyId),
// //       },
// //
// //
// //
// //     );
// //   }
// // }
// //
// // class SurveyForm extends StatefulWidget {
// //   @override
// //   _SurveyFormState createState() => _SurveyFormState();
// // }
// //
// // class _SurveyFormState extends State<SurveyForm> {
// //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// //   final TextEditingController _surveyNameController = TextEditingController();
// //   final TextEditingController _clientNameController = TextEditingController();
// //   final TextEditingController _projectNameController = TextEditingController();
// //
// //   void _createSurvey() {
// //     if (_formKey.currentState!.validate()) {
// //       FirebaseFirestore.instance.collection('surveys').add({
// //         'surveyName': _surveyNameController.text,
// //         'clientName': _clientNameController.text,
// //         'projectName': _projectNameController.text,
// //       }).then((value) {
// //         print('Survey created and stored successfully!');
// //         FirebaseFirestore.instance.collection('surveys').doc(value.id).update({
// //           'surveyId': value.id,
// //         });
// //
// //         String surveyLink = '${Uri.base.origin}/survey?id=${value.id}';
// //         print('Survey link: $surveyLink');
// //         js.context.callMethod('open', [surveyLink]);
// //         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
// //           builder: (context) => SurveyPage(surveyId: value.id),
// //         ), (route) => false);
// //
// //       }).catchError((error) {
// //         print('Failed to create survey: $error');
// //       });
// //     }
// //   }
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Create Survey'),
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               TextFormField(
// //                 controller: _surveyNameController,
// //                 decoration: InputDecoration(labelText: 'Survey Name'),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter survey name';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               TextFormField(
// //                 controller: _clientNameController,
// //                 decoration: InputDecoration(labelText: 'Client Name'),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter client name';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               TextFormField(
// //                 controller: _projectNameController,
// //                 decoration: InputDecoration(labelText: 'Project Name'),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter project name';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _createSurvey,
// //                 child: Text('Create Survey'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// // class SurveyPage extends StatefulWidget {
// //   final String? surveyId;
// //
// //   SurveyPage({this.surveyId});
// //
// //   @override
// //   _SurveyPageState createState() => _SurveyPageState();
// // }
// //
// // class _SurveyPageState extends State<SurveyPage> {
// //   String? surveyName;
// //   String? clientName;
// //   String? projectName;
// //   Map<String, String?> answers = {
// //     'q1': null,
// //     'q2': null,
// //     'q3': null,
// //     'q4': null,
// //     'q5': null,
// //   };
// //   void submitSurvey() async {
// //     // Validate if all questions are answered
// //     if (!validate()) {
// //       showDialog(
// //         context: context,
// //         builder: (context) {
// //           return AlertDialog(
// //             title: Text('Error'),
// //             content: Text('Please answer all questions before submitting.'),
// //             actions: [
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context);
// //                 },
// //                 child: Text('OK'),
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //       return;
// //     }
// //
// //     // Convert answers map to a format compatible with Firestore
// //     Map<String, dynamic> firestoreAnswers = {};
// //     answers.forEach((key, value) {
// //       firestoreAnswers[key] = value;
// //     });
// //
// //     // Create a map to store survey answers
// //     Map<String, dynamic> surveyData = {
// //       'surveyId': widget.surveyId,
// //       'surveyName': surveyName,
// //       'clientName': clientName,
// //       'projectName': projectName,
// //       'answers': firestoreAnswers,
// //     };
// //
// //     try {
// //       // Add the survey data to Firestore
// //       await FirebaseFirestore.instance.collection('survey_answers').add(surveyData);
// //
// //       // Show success message
// //       showDialog(
// //         context: context,
// //         builder: (context) {
// //           return AlertDialog(
// //             title: Text('Success'),
// //             content: Text('Survey submitted successfully.'),
// //             actions: [
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context);
// //                 },
// //                 child: Text('OK'),
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     } catch (error) {
// //       print('Failed to submit survey: $error');
// //       // Show error message
// //       showDialog(
// //         context: context,
// //         builder: (context) {
// //           return AlertDialog(
// //             title: Text('Error'),
// //             content: Text('Failed to submit survey. Please try again later.'),
// //             actions: [
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context);
// //                 },
// //                 child: Text('OK'),
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     }
// //   }
// //
// //   bool validate() {
// //     return answers.values.every((value) => value != null);
// //   }
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Fetch survey details if surveyId is provided
// //     if (widget.surveyId != null) {
// //       FirebaseFirestore.instance.collection('surveys').doc(widget.surveyId).get().then((snapshot) {
// //         if (snapshot.exists) {
// //           setState(() {
// //             surveyName = snapshot['surveyName'];
// //             clientName = snapshot['clientName'];
// //             projectName = snapshot['projectName'];
// //           });
// //         } else {
// //           print('Document does not exist');
// //         }
// //       }).catchError((error) {
// //         print('Failed to fetch survey details: $error');
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //
// //       appBar: AppBar(
// //         automaticallyImplyLeading: false,
// //
// //         title: Text('Survey Details'),
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 'Survey Name: ${surveyName ?? "Loading..."}',
// //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //               ),
// //               Text(
// //                 'Client Name: ${clientName ?? "Loading..."}',
// //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //               ), Text(
// //                 'Project Name: ${projectName ?? "Loading..."}',
// //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //               ),
// //               // Add more survey details if needed
// //               SurveyQuestion(
// //                 question: 'How satisfied are you with the overall outcome of the project? Did we meet your expectations in terms of quality and deliverables?',
// //                 choices: ['Very satisfied', 'Satisfied', 'Neutral', 'Dissatisfied', 'Very dissatisfied'],
// //                 questionId: 'q1',
// //                 onChanged: (value) {
// //                   setState(() {
// //                     answers['q1'] = value;
// //                   });
// //                 },
// //               ),
// //               SurveyQuestion(
// //                 question: 'How would you rate our communication throughout the project?',
// //                 choices: ['Excellent', 'Good', 'Average', 'Poor', 'Very poor'],
// //                 questionId: 'q2',
// //                 onChanged: (value) {
// //                   setState(() {
// //                     answers['q2'] = value;
// //                   });
// //                 },
// //               ),
// //               SurveyQuestion(
// //                 question: 'Were you satisfied with the level of support on & off-site and guidance provided during the project?',
// //                 choices: ['Very effectively', 'Effectively', 'Moderately effectively', 'Ineffectively', 'Very ineffectively'],
// //                 questionId: 'q3',
// //                 onChanged: (value) {
// //                   setState(() {
// //                     answers['q3'] = value;
// //                   });
// //                 },
// //               ),
// //               SurveyQuestion(
// //                 question: 'How likely are you to recommend our services to others based on your experience with this project?',
// //                 choices: ['Very likely', 'Likely', 'Neutral', 'Unlikely', 'Very unlikely'],
// //                 questionId: 'q4',
// //                 onChanged: (value) {
// //                   setState(() {
// //                     answers['q4'] = value;
// //                   });
// //                 },
// //               ),
// //               const SizedBox(height: 20),
// //               const Text('Is there any additional feedback or suggestions you would like to provide to help us improve our services in the future?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
// //               const SizedBox(height: 10),
// //               TextField(
// //                 onChanged: (value) {
// //                   setState(() {
// //                     answers['q5'] = value;
// //                   });
// //                 },
// //                 decoration: const InputDecoration(
// //                   hintText: 'Additional feedback',
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 maxLines: 3,
// //               ),
// //               const SizedBox(height: 20),
// //               Center(
// //                 child: ElevatedButton(
// //
// //                   onPressed: ()async{
// //
// //                     submitSurvey();
// //                   },
// //                   child:   Text('Submit'),
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //
// // }
// //
// // class SurveyQuestion extends StatefulWidget {
// //   final String question;
// //   final List<String> choices;
// //   final String questionId;
// //   final Function(String?) onChanged;
// //
// //   const SurveyQuestion({
// //     Key? key,
// //     required this.question,
// //     required this.choices,
// //     required this.questionId,
// //     required this.onChanged,
// //   }) : super(key: key);
// //
// //   @override
// //   _SurveyQuestionState createState() => _SurveyQuestionState();
// // }
// //
// // class _SurveyQuestionState extends State<SurveyQuestion> {
// //   String? selectedChoice;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(widget.question, style: const TextStyle(fontSize: 18)),
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: widget.choices.map((choice) {
// //             return Row(
// //               children: [
// //                 Radio<String>(
// //                   value: choice,
// //                   groupValue: selectedChoice,
// //                   onChanged: (value) {
// //                     setState(() {
// //                       selectedChoice = value;
// //                     });
// //                     widget.onChanged(value);
// //                   },
// //                 ),
// //                 Text(choice),
// //               ],
// //             );
// //           }).toList(),
// //         ),
// //       ],
// //     );
// //   }
// // }
