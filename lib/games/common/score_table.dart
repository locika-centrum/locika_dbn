import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

import '../../settings/model/settings_data.dart';
import '../../utils/app_theme.dart';
import 'models/game_score_base.dart';

Logger _log = Logger('score_table.dart');

Future<void> showHighScore({
  required BuildContext context,
  required String title,
  required String hiveBoxName,
  required String dataKey,
  required int complexity,
  Color backgroundColor = Colors.white,
}) async {
  List<Map<String, String>> scoreData = [];
  int totalGames = 0;
  String totalScore = '-';

  _log.finest('Display high scores');

  for (int size = 0; size < SettingsData.gameSizes.length; size++) {
    Box box = await Hive.openBox(hiveBoxName);
    GameScoreBase? result = box.get('${dataKey}_${size}_$complexity');

    _log.finest(
        'complexity: $complexity, size: $size, scoreTable: ${result?.scoreTable}');

    String highScore = result?.scoreTable[1].toString() ?? '-';
    if (highScore.split(':').isNotEmpty) {
      highScore = highScore.replaceFirst(':', ' : ');
    }
    scoreData.add(Map.from({
      'title': 'entry',
      'size': SettingsData.gameSizes[size],
      'games': result?.scoreTable[0].toString() ?? '-',
      'highScore': highScore,
    }));

    totalGames += int.parse(result?.scoreTable[0] ?? '0');
    if (scoreData.last['highScore'] != '-') {
      List<String> score = scoreData.last['highScore']!.split(':');

      totalScore = totalScore != '-'
          ? totalScore
          : (score.length == 2 ? '0 : 0' : totalScore);

      if (score.length == 2) {
        List<String> totalScoreValue = totalScore.split(':');
        totalScoreValue[0] =
            (int.parse(totalScoreValue[0]) + int.parse(score[0])).toString();
        totalScoreValue[1] =
            (int.parse(totalScoreValue[1]) + int.parse(score[1])).toString();

        totalScore = '${totalScoreValue[0]} : ${totalScoreValue[1]}';
      }
    }
  }
  scoreData.add(Map.from({
    'title': 'sum',
    'size': '',
    'games': totalGames.toString(),
    'highScore': totalScore,
  }));

  _log.finest('score: $scoreData');

  if (!context.mounted) return;
  showModalBottomSheet(
    context: context,
    backgroundColor: backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(
          16.0,
        ),
      ),
    ),
    builder: (BuildContext context) {
      return Theme(
        data: AppTheme.gameTheme,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.white70,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 32.0),
                child: Text(
                  'Hra ${SettingsData.gameComplexities[complexity]}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              DataTable(
                columns: <DataColumn>[
                  const DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                    label: Text(
                      _upperText('her'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      _upperText('score'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: <DataRow>[
                  for (Map score in scoreData)
                    DataRow(cells: <DataCell>[
                      DataCell(
                        Text(
                          _upperText(score['size']),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataCell(Text(
                        score['games'],
                        textAlign: TextAlign.center,
                      )),
                      DataCell(Text(
                        score['highScore'],
                        textAlign: TextAlign.center,
                      )),
                    ]),
                ],
              ),
              SafeArea(
                child: Container(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

String _upperText(String text) {
  String result = '';

  for (int index = 0; index < text.length; index++) {
    result += '${text[index].toUpperCase()} ';
  }

  return result;
}
