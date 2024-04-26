import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/reponsiveness.dart';
import 'package:flutter_web_dashboard/constants/controllers.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/survey_recieved_table.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/overview_cards_large.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/overview_cards_medium.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/overview_cards_small.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/revenue_section_large.dart';
import 'package:flutter_web_dashboard/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../show_create_servey/survey_lists.dart';
import 'widgets/revenue_section_small.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
              () => Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                child: CustomText(
                  text: menuController.activeItem.value,
                  size: 24,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('surveys').get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              int totalSurveys = snapshot.data!.docs.length;

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('survey_answers').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  int receivedSurveys = snapshot.data!.docs.length;

                  List<Map<String, dynamic>> surveyDataList = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                  return ListView(
                    children: [
                      if (ResponsiveWidget.isLargeScreen(context) || ResponsiveWidget.isMediumScreen(context))
                        if (ResponsiveWidget.isCustomSize(context))
                          OverviewCardsMediumScreen(totalSurveys: totalSurveys, receivedSurveys: receivedSurveys,)
                        else
                          OverviewCardsLargeScreen(totalSurveys: totalSurveys, receivedSurveys: receivedSurveys,)
                      else
                        OverviewCardsSmallScreen(totalSurveys: totalSurveys, receivedSurveys: receivedSurveys,),
                      SizedBox(height: 40,),
                      SurveysRecievedTable(surveyDataList: surveyDataList, onDetailPressed: (index) {
                        // Navigate to SurveyListPage with the selected survey data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyListPage(selectedSurveyData: surveyDataList[index]),
                          ),
                        );
                      }),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
