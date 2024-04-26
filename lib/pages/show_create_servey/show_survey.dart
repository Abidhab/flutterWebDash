import 'package:flutter/cupertino.dart';

import 'survey_lists.dart';

class ShowSurveysPage extends StatefulWidget {
  const ShowSurveysPage({super.key});

  @override
  State<ShowSurveysPage> createState() => _ShowSurveysPageState();
}

class _ShowSurveysPageState extends State<ShowSurveysPage> {
  @override
  Widget build(BuildContext context) {
    return  SurveyListPage();
  }
}
