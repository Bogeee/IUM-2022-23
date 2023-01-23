import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proj/views/main/search_lesson/components/lesson.dart';
import 'package:proj/views/main/search_lesson/components/search_form.dart';
import 'package:simple_shadow/simple_shadow.dart';

// constants
import 'package:proj/constants.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/models/ripetizioni.dart';
import 'package:proj/models/corsi.dart';
import 'package:proj/models/materie.dart';

import 'components/no_suggestions_result.dart';
import 'components/search_result.dart';
import 'components/suggested_lessons.dart';

class SearchLessonPage extends StatefulWidget {
  const SearchLessonPage({super.key});

  @override
  State<SearchLessonPage> createState() => _SearchLessonPageState();
}

class _SearchLessonPageState extends State<SearchLessonPage> {
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

  Future<void> _searchFuture(int studentID) async{
    if(!_checked) {
      subjectForStudent = await getSubjectForStudent(studentID);
      setState(() {
        _checked = true;
      });
    }
  }

  void _refreshUI(){
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

    return FutureBuilder(
        future: _searchFuture(userId),
        builder: (BuildContext builder, AsyncSnapshot snapshot) {
          if (_checked) {
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(defaultPadding / 2),
                        child: Column(
                          children: [
                            SearchForm(
                              accent: accent,
                              isDark: isDark,
                              showSearchResultsCallback: _showSearchResults,
                            ),
                            const Divider(
                                thickness: 2,
                                indent: defaultPadding / 4,
                                endIndent: defaultPadding / 4),
                            if(subjectForStudent.isNotEmpty || _showResults)
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _showResults
                                          ? 'Risultati ricerca'
                                          : 'Potrebbero interessarti',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  )
                                ],
                              ),
                            const SizedBox(height: 0.4*defaultPadding,),
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
                              : (subjectForStudent.isEmpty
                                  ? Container(
                                    height: MediaQuery.of(context).size.height > 600
                                      ? MediaQuery.of(context).size.height - 420
                                      : 400,
                                    child: NoSuggestionsResult(
                                            accent: accent, isDark: isDark),
                                  )
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: SuggestedLessons(
                                        accent: accent,
                                        isDark: isDark,
                                        previousSubjects: subjectForStudent,
                                        refreshUICallback: _refreshUI,
                                      ),
                                    )
                                )

                            
                          ],
                        )
                      )
                    )
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Provider.of<ThemeNotifier>(context).accentColor,
              ),
            );
          }
        });
  }
}
