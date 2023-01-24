import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proj/views/main/search_lesson/components/admin_search_form.dart';
import 'package:proj/views/main/search_lesson/components/lesson.dart';
import 'package:proj/views/main/search_lesson/components/search_form.dart';
import 'package:proj/views/main/search_lesson/components/search_result.dart';
import 'package:simple_shadow/simple_shadow.dart';

// constants
import 'package:proj/constants.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/models/ripetizioni.dart';
import 'package:proj/models/corsi.dart';
import 'package:proj/models/materie.dart';


class AdminUnbookPage extends StatefulWidget {
  const AdminUnbookPage({super.key});

  @override
  State<AdminUnbookPage> createState() => _AdminUnbookPageState();
}

class _AdminUnbookPageState extends State<AdminUnbookPage> {
  List<Ripetizione> resultsOfSearch = [];
  List<Materia> subjectForStudent = [];
  bool _showResults = false;
  bool _checked = false;

  void _showSearchResults(List<Ripetizione> results) {
    setState(() {
      _showResults = true;
      resultsOfSearch = results;
    });
  }

  void _refreshUI() {
    setState(() {
      _checked = false;
      _showResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;
    int userId = Provider.of<LoggedInNotifier>(context).userId;

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(defaultPadding / 2),
                child: Column(
                  children: [
                    AdminSearchForm(
                      accent: accent,
                      isDark: isDark,
                      showSearchResultsCallback: _showSearchResults,
                    ),
                    const Divider(
                        thickness: 2,
                        indent: defaultPadding / 4,
                        endIndent: defaultPadding / 4),
                    if (subjectForStudent.isNotEmpty || _showResults)
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            _showResults ? 'Risultati ricerca' : '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                            textAlign: TextAlign.left,
                          ))
                        ],
                      ),
                    const SizedBox(
                      height: 0.4 * defaultPadding,
                    ),
                    _showResults
                        ? SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SearchResult(
                              accent: accent,
                              isDark: isDark,
                              lessons: resultsOfSearch,
                              refreshUICallback: _refreshUI,
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height > 600
                                ? MediaQuery.of(context).size.height - 500
                                : 400,
                            child: const Center(
                              child: Text(
                                'E’ necessario filtrare perchè il numero'
                                ' di ripetizioni è troppo elevato.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                  ],
                ))));
  }
}
