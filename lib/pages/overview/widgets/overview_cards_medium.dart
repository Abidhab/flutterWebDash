import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/info_card.dart';

class OverviewCardsMediumScreen extends StatelessWidget {
  final int totalSurveys;
  final int receivedSurveys;

  const OverviewCardsMediumScreen({
    Key? key,
    required this.totalSurveys,
    required this.receivedSurveys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InfoCard(
          title: "Total Surveys",
          value: totalSurveys.toString(),
          onTap: () {},
          topColor: Colors.orange,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 64,
        ),
        InfoCard(
          title: "Surveys Received",
          value: receivedSurveys.toString(),
          topColor: Colors.lightGreen,
          onTap: () {},
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 64,
        ),
        InfoCard(
          title: "Surveys Pending",
          value: (totalSurveys - receivedSurveys).toString(),
          topColor: Colors.redAccent,
          onTap: () {},
        ),
      ],
    );
  }
}

class OverviewCardsMediumScreenContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        FirebaseFirestore.instance.collection('surveys').get(),
        FirebaseFirestore.instance.collection('survey_answers').get(),
      ]),
      builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        int totalSurveys = snapshot.data![1].docs.length;
        int receivedSurveys = snapshot.data![0].docs.length;

        return OverviewCardsMediumScreen(
          totalSurveys: totalSurveys,
          receivedSurveys: receivedSurveys,
        );
      },
    );
  }
}
