import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../constants/style.dart';
import '../../../widgets/custom_text.dart';
import '../clients.dart';

class ClientsTable extends StatelessWidget {
  final List<Map<String, dynamic>> surveyDataList;
  final void Function(int index) onDetailPressed;

  const ClientsTable({
    Key? key,
    required this.surveyDataList,
    required this.onDetailPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
        boxShadow: [BoxShadow(offset: const Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              SizedBox(
                width: 10,
              ),
              CustomText(
                text: "Surveys Received",
                color: lightGrey,
                weight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(
            height: (56 * surveyDataList.length) + 40,
            child: DataTable2(
              columnSpacing: 12,
              dataRowHeight: 56,
              headingRowHeight: 40,
              horizontalMargin: 12,
              minWidth: 600,
              columns: const [
                DataColumn2(
                  label: Text("Project Name"),
                  size: ColumnSize.L,
                ),
                DataColumn(
                  label: Text('Client Name'),
                ),
                DataColumn(
                  label: Text('Rating'),
                ),
                DataColumn(
                  label: Text('Action'),
                ),
              ],
              rows: List<DataRow>.generate(
                surveyDataList.length,
                    (index) => DataRow(
                  cells: [
                    DataCell(CustomText(text: surveyDataList[index]['projectName'])),
                    DataCell(CustomText(text: surveyDataList[index]['clientName'])),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.deepOrange, size: 18),
                          SizedBox(width: 5),
                          CustomText(text: "4.5"), // Assuming this value comes from surveyDataList
                        ],
                      ),
                    ),
                    DataCell(
                      InkWell(
                        onTap: () {
                          onDetailPressed(index); {
                            Map<String, dynamic> selectedSurveyData = surveyDataList[index];
                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) => SearchScreen(selectedSurveyData: selectedSurveyData),
                            // ));
                          };// Pass the index to the callback function
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: light,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: active, width: .5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: CustomText(
                            text: "Detail",
                            color: active.withOpacity(.7),
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
