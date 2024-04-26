import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_dashboard/pages/clients/widgets/clients_table.dart';

class SearchScreen extends StatefulWidget {
  final Map<String, dynamic>? selectedSurveyData;

  SearchScreen({this.selectedSurveyData});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _searchResults = [];
  Map<String, dynamic>? _selectedSurvey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter Project Or Client Name...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  setState(() {
                    _searchResults = [];
                  });
                  _search(query);
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _searchResults = [];
                });
                _search(_searchController.text);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_selectedSurvey != null)
            Card(
              elevation: 3,
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('Survey Name: ${_selectedSurvey!['surveyName']}'),
                      subtitle: Text('Client Name: ${_selectedSurvey!['clientName']}'),
                    ),
                    ListTile(
                      title: Text('Project Name: ${_selectedSurvey!['projectName']}'),
                    ),
                    ListTile(
                      title: Text('1. How satisfied are you with the overall outcome of the project? Did we meet your expectations in terms of quality and deliverables?'),
                      subtitle: Text('Answer: ${_selectedSurvey!['answers']['q1'] ?? 'Not answered'}'),
                    ),
                    ListTile(
                      title: Text('2. How would you rate our communication throughout the project?'),
                      subtitle: Text('Answer: ${_selectedSurvey!['answers']['q2'] ?? 'Not answered'}'),
                    ),
                    ListTile(
                      title: Text('3. Were you satisfied with the level of support on & off-site and guidance provided during the project?'),
                      subtitle: Text('Answer: ${_selectedSurvey!['answers']['q3'] ?? 'Not answered'}'),
                    ),
                    ListTile(
                      title: Text('4. How likely are you to recommend our services to others based on your experience with this project?'),
                      subtitle: Text('Answer: ${_selectedSurvey!['answers']['q4'] ?? 'Not answered'}'),
                    ),
                    ListTile(
                      title: Text('5. Is there any additional feedback or suggestions you would like to provide to help us improve our services in the future?'),
                      subtitle: Text('Answer: ${_selectedSurvey!['answers']['q5'] ?? 'Not answered'}'),
                    ),
                  ],
                ),
              ),
            ),

          Expanded(
            child: _searchResults.isEmpty
                ? Center(
              child: Text('Search for surveys'),
            )
                : SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: ClientsTable(
                surveyDataList: _searchResults.map((snapshot) => snapshot.data() as Map<String, dynamic>).toList(),
                onDetailPressed: (index) {
                  setState(() {
                    _selectedSurvey = _searchResults[index].data() as Map<String, dynamic>;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _search(String query) async {
    QuerySnapshot snapshot = await _firestore
        .collection('survey_answers')
        .where('projectName', isGreaterThanOrEqualTo: query)
        .where('projectName', isLessThan: query + 'z')
        .get();

    QuerySnapshot snapshot2 = await _firestore
        .collection('survey_answers')
        .where('clientName', isGreaterThanOrEqualTo: query)
        .where('clientName', isLessThan: query + 'z')
        .get();

    QuerySnapshot snapshot3 = await _firestore
        .collection('survey_answers')
        .where('eventName', isGreaterThanOrEqualTo: query)
        .where('eventName', isLessThan: query + 'z')
        .get();

    List<DocumentSnapshot> results = [];
    results.addAll(snapshot.docs);
    results.addAll(snapshot2.docs);
    results.addAll(snapshot3.docs);

    setState(() {
      _searchResults = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
