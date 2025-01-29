import 'package:academy/welcome_to_academy/export.dart';

class FinishedChallenge extends StatefulWidget {
  FinishedChallenge({
    super.key,
    required this.employee,
    required this.Authorization,
  });
  final Employee employee;
  final String Authorization;

  @override
  _FinishedChallengeState createState() => _FinishedChallengeState();
}

class _FinishedChallengeState extends State<FinishedChallenge> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              // alignment: Alignment.topCenter,
              color: Colors.white,
              child: _tableWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _challengeWidget0(){
    return Column(
      children: [
        _challengeWidget('Name','Orientation Test - New 1'),
        _challengeWidget('Correct answer','45/50'),
        _challengeWidget('Score','45'),
        _challengeWidget('Start Time','2024-04-26 10:24:35'),
        _challengeWidget('End Time','2024-04-26 10:44:40'),
        _challengeWidget('Time used','00:20:15'),
      ],
    );
  }

  Widget _challengeWidget(String title,String subject){
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 16,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          subject,
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 16,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _tableWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: Row(
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.unfold_more,
                        color: Color(0xFF555555),
                        size: 16,
                      )
                    ],
                  ),
                  onSort: (columnIndex, ascending) {
                    // _sortNameColumn(ascending);
                  },
                ),
                DataColumn(
                  label: Text(
                    'Correct answer',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Score',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Start',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'End',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Time used',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        'Orientation Test - New 1',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        '45/50',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        '45',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        '2024-04-26 10:24:35',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        '2024-04-26 10:44:40',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        '00:20:15',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        'Orientation Test',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        '42/50',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        '42',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        '2024-04-26 10:16:53',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        '2024-04-26 10:20:09',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                    DataCell(ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text(
                        '00:24:46',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
