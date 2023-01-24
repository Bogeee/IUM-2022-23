import 'package:flutter/material.dart';

// constants
import 'package:proj/constants.dart';
import 'package:proj/models/ripetizioni.dart';
import 'package:proj/views/main/history/components/cancelled_list.dart';
import 'package:proj/views/main/history/components/history_list.dart';
import 'package:proj/views/main/home/components/titles.dart';
import 'package:proj/views/main/search_lesson/components/lesson.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';

// views
import 'package:proj/views/main/history/components/no_history.dart';

class UserHistoryPage extends StatefulWidget {
  const UserHistoryPage({
    super.key,
    required this.changePageCallback
  });

  final VoidCallback changePageCallback;

  @override
  State<UserHistoryPage> createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> {

  List<Ripetizione> oldLessons = [];
  List<Ripetizione> cancelledLessons = [];

  bool _checked = false;

  // che bell'ossimoro
  Future<void> _historyFuture(int studentID) async {
    if (!_checked) {
      oldLessons = await getOldLessons(studentID);
      cancelledLessons = await getCancelledLessons(studentID);
      setState(() {
        _checked = true;
      });
    }
  }

  void _refreshUI() {
    setState(() {
      _checked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int studentID = Provider.of<LoggedInNotifier>(context).userId;
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;
    Color mainContainerColor = Provider.of<ThemeNotifier>(context).mainContainerColor;
    Color lessContrastTextColor = Provider.of<ThemeNotifier>(context).lessContrastTextColor;

    return FutureBuilder(
      future: _historyFuture(studentID),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(_checked){
          return oldLessons.isNotEmpty || cancelledLessons.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  color: mainContainerColor,
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding / 2),
                    child: Column(
                      children: [
                        if(oldLessons.isNotEmpty)
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Ripetizioni passate',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                              Text(
                                '25 Gennaio 2023',
                                style: TextStyle(
                                  color: lessContrastTextColor,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              )
                            ],
                          ),
                        if (oldLessons.isNotEmpty)
                          const SizedBox(height: 0.5 * defaultPadding,),
                        if (oldLessons.isNotEmpty)
                          HistoryList(oldLessons: oldLessons, refreshUI: _refreshUI),
                        if (cancelledLessons.isNotEmpty && oldLessons.isNotEmpty)
                          const SizedBox(height: defaultPadding,),
                        if (cancelledLessons.isNotEmpty)
                          const GenericTitle(title: 'Ripetizioni annullate'),
                        if (cancelledLessons.isNotEmpty)
                          const SizedBox(height: 0.5 * defaultPadding,),
                        if (cancelledLessons.isNotEmpty)
                          CancelledList(cancelledLessons: cancelledLessons, refreshUI: _refreshUI),
                      ],
                    ),
                  ),
                ),
              )
            : NoHistory(changePageCallback: widget.changePageCallback);
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: accent,
            ),
          );
        }
      }
    );
  }
}

