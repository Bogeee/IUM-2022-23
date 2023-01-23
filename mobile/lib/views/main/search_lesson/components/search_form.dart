import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// modals
import 'package:proj/models/materie.dart';
import 'package:proj/models/ripetizioni.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/models/docenti.dart';

// constants
import 'package:proj/constants.dart';


class SearchForm extends StatefulWidget {
  const SearchForm({
    Key? key,
    required this.accent,
    required this.isDark,
    required this.showSearchResultsCallback,
  }) : super(key: key);

  final Color accent;
  final bool isDark;
  final void Function(List<Ripetizione>) showSearchResultsCallback;

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  String _selectedSubject = "";
  String _selectedDay = "Mercoledì";
  String _selectedTimeFrom = "09:00";
  String _selectedTimeTo = "10:00";
  Docente? _selectedProfessor;
  final List<String> days = <String>["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì"];
  List<String> materie = <String>[];
  List<Docente> docenti = [];

  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<LoggedInNotifier>(context).userId;

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(defaultPadding / 10),
        child: InkWell(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: widget.accent.withOpacity(0.13),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(defaultPadding),
                bottom: Radius.circular(defaultPadding / 4)
              )
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                defaultPadding,
                defaultPadding / 1.5,
                defaultPadding,
                defaultPadding / 1.5
              ),
              child: Row(
                children: [
                  const Expanded(child: Text("Materia")),
                  Text(
                    _selectedSubject,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                    ),
                  ),
                  const SizedBox(width: 0.5 * defaultPadding,),
                  SvgPicture.asset('assets/icons/chevron-right-solid.svg', width: 10,)
                ],
              )
            )
          ),
          onTap: () async {
            materie = await getSubjectsFromDB();

            String? result = await showDialog(
              context: context,
              builder: (builder) {
                return AlertDialog(
                  // FIXME: bisogna cambiare il colore dell'alert in base al tema???
                  // backgroundColor: ,
                  title: const Text("Inserisci la materia da cercare"),
                  content: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return materie.where((String materia) {
                        return materia
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          child: Container(
                            width: 200,
                            height: options.length * 100,
                            // FIXME: devo cambiargli il color in base al tema????
                            color: Colors.white,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10.0),
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String option = options.elementAt(index);

                                return GestureDetector(
                                  onTap: () {
                                    onSelected(option);
                                  },
                                  child: ListTile(
                                    // FIXME: devo cambiargli il background color in base al tema????
                                    title: Text(option,
                                      style: const TextStyle(color: Colors.black)
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    onSelected: (String selection) {
                      // qui devo inserire la funzione che seleziona la materia
                      Navigator.of(context).pop(selection);
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        decoration: const InputDecoration(
                          fillColor: Color(0xFFEDEDED),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          constraints: BoxConstraints(
                            minWidth: 270,
                            maxWidth: 350,
                            minHeight: 60,
                            maxHeight: 85
                          )
                        ),
                        style: const TextStyle(color: Colors.black),
                      );
                    },
                  ),
                );
            });

            setState(() {
              _selectedSubject = result ?? "";
            });
        }),
      ),
      Padding(
        padding: const EdgeInsets.all(defaultPadding / 10),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: widget.accent.withOpacity(0.13),
            borderRadius: BorderRadius.circular(defaultPadding / 4)
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 0),
            child: Row(
              children: [
                const Expanded(child: Text("Docente")),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: widget.accent.withOpacity(0.30),
                  ),
                  child: Text(
                    _selectedProfessor != null
                        ? "${_selectedProfessor!.nome} ${_selectedProfessor!.cognome}"
                        : "Qualsiasi ",
                    style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold
                    ),
                  ),
                  onPressed: () async {
                    if(materie.isEmpty) {
                      showError("Prima devi selezionare una materia");
                    } else {
                      docenti = await getProfessorBySubject(_selectedSubject);
                      docenti.insert(0, Docente.fromData(-1, "Qualsiasi", "", "", true));

                      Docente ?professor = await showModalBottomSheet(
                        backgroundColor: Colors.white,
                        barrierColor: Colors.black.withOpacity(0.75),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(defaultPadding), 
                            topRight: Radius.circular(defaultPadding)
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.4,
                            minChildSize: 0.2,
                            maxChildSize: 0.8,
                            builder: (context, scrollController) {
                            return Container(
                              color: Colors.transparent,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(10.0),
                                itemCount: docenti.length,
                                controller: scrollController,
                                itemBuilder: (BuildContext context,
                                    int index) {
                                  final Docente docente = docenti.elementAt(index);

                                  return GestureDetector(
                                    onTap: () => Navigator.of(context) .pop(docente),
                                    child: ListTile(
                                      // FIXME: devo cambiargli il background color in base al tema????
                                      title: Text(
                                        "${docente.nome} ${docente.cognome}",
                                        style: const TextStyle(color: Colors.black)
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 5, right: 5),
                                    child: Container(
                                      height: 0.5,
                                      color: Colors.grey,
                                    )
                                  );
                                },
                              )
                            );
                            }
                          );
                        },
                      );

                      setState(() {
                        _selectedProfessor = professor ?? _selectedProfessor;
                      });
                    }
                  },
                )
              ],
            )
          )
        )
      ),
      Padding(
        padding: const EdgeInsets.all(defaultPadding / 10),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: widget.accent.withOpacity(0.13),
            borderRadius: BorderRadius.circular(defaultPadding / 4)
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 0),
            child: Row(
              children: [
                const Expanded(child: Text("Giorno")),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: widget.accent.withOpacity(0.30),
                  ),
                  child: Text(
                    _selectedDay,
                    style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold
                    ),
                  ),
                  onPressed: () async {
                    String ?day = await showModalBottomSheet(
                      backgroundColor: Colors.white,
                      barrierColor: Colors.black.withOpacity(0.75),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(defaultPadding), 
                          topRight: Radius.circular(defaultPadding)
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.4,
                          minChildSize: 0.2,
                          maxChildSize: 0.8,
                          builder: (context, scrollController) {
                            return Container(
                              color: Colors.transparent,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(10.0),
                                itemCount: days.length,
                                controller: scrollController,
                                itemBuilder: (BuildContext context, int index) {
                                  final String option = days.elementAt(index);

                                  return GestureDetector(
                                    onTap: () => Navigator.of(context) .pop(option),
                                    child: ListTile(
                                      // FIXME: devo cambiargli il background color in base al tema????
                                      title: Text(option,
                                        style: const TextStyle(
                                            color: Colors.black
                                        )
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5, right: 5
                                    ) ,
                                    child: Container(
                                      height: 0.5,
                                      color: Colors.grey,
                                    )
                                  );
                                },
                              )
                            );
                          }
                        );
                      },
                    );

                    setState(() {
                      _selectedDay = day ?? _selectedDay;
                    });
                  },
                )
              ],
            )
          )
        )
      ),
      Padding(
        padding: const EdgeInsets.all(defaultPadding / 10),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: widget.accent.withOpacity(0.13),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(defaultPadding / 4),
              bottom: Radius.circular(defaultPadding)
            )
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(defaultPadding, 0, defaultPadding, 0),
            child: Row(
              children: [
                const Expanded(child: Text("Ora")),
                Row(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: widget.accent.withOpacity(0.30),
                      ),
                      onPressed: () async {
                        TimeOfDay? time = await showTimePicker(
                          cancelText: 'Indietro',
                          helpText: 'Orario inizio ripetizione\n\nMattino: [9.00 - 12.00]\nPomeriggio: [15.00 - 18.00]',
                          hourLabelText: 'Ora di inizio',
                          minuteLabelText: 'Minuti',
                          context: context,
                          initialTime: TimeOfDay(hour: int.parse(_selectedTimeFrom.split(":")[0]), minute: int.parse(_selectedTimeFrom.split(":")[1])),
                          initialEntryMode: TimePickerEntryMode.dialOnly,
                        );

                        setState(() {
                          _selectedTimeFrom = time != null
                              ? time.format(context)
                              : _selectedTimeFrom;
                        });
                      },
                      child: Text(
                        _selectedTimeFrom,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(defaultPadding / 4, 0, defaultPadding / 4, 0),
                      child: SvgPicture.asset(
                        'assets/icons/arrow-right-solid.svg',
                        width: 14,
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: widget.accent.withOpacity(0.30),
                      ),
                      onPressed: () async {
                        TimeOfDay? time = await showTimePicker(
                          cancelText: 'Indietro', 
                          helpText: 'Orario fine ripetizione\n\nMattino: [10.00 - 13.00]\nPomeriggio: [16.00 - 19.00]',
                          hourLabelText: 'Ora di fine',
                          minuteLabelText: 'Minuti',
                          context: context,
                          initialTime: TimeOfDay(hour: int.parse(_selectedTimeTo.split(":")[0]), minute: int.parse(_selectedTimeTo.split(":")[1])),
                          initialEntryMode: TimePickerEntryMode.dialOnly,
                        );

                        setState(() {
                          _selectedTimeTo = time != null
                              ? time.format(context)
                              : _selectedTimeTo;
                        });
                      },
                      child: Text(
                        _selectedTimeTo,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )
                   ),
                  ],
                ),
              ],
            )
          )
        )
      ),
      const SizedBox(height: 0.5 * defaultPadding),
      SizedBox(
        width: MediaQuery.of(context).size.width - defaultPadding,
        height: 40,
        child: OutlinedButton(
            onPressed: () async {
              TimeOfDay start = TimeOfDay(
                hour: int.parse(_selectedTimeFrom.split(":")[0]), 
                minute: 0
              );
              TimeOfDay end = TimeOfDay(
                hour: int.parse(_selectedTimeTo.split(":")[0]), 
                minute: 0
              );

              if (_selectedSubject == "") {
                showError("Devi selezionare una materia");
              } else if (start.compareTo(end) >= 0) {
                showError("Inserisci un intervallo di ore valido");
              } else if (start .compareTo(const TimeOfDay(hour: 09, minute: 00)) < 0) {
                showError(
                    "Inserisci un'ora di inizio maggiore o uguale a 9:00");
              } else if (start .compareTo(const TimeOfDay(hour: 12, minute: 00)) > 0 &&
                  start.compareTo(const TimeOfDay(hour: 15, minute: 00)) < 0) {
                showError( "Inserisci un'ora di inizio minore o uguale a 12:00 oppure maggiore o uguale a 15:00");
              } else if (start .compareTo(const TimeOfDay(hour: 18, minute: 00)) > 0) {
                showError("Inserisci un'ora di inizio minore o uguale a 18:00");
              } else if (end.compareTo(const TimeOfDay(hour: 10, minute: 00)) < 0) {
                showError("Inserisci un'ora di fine maggiore o uguale a 10:00");
              } else if (end.compareTo(const TimeOfDay(hour: 13, minute: 00)) > 0 &&
                  end.compareTo(const TimeOfDay(hour: 16, minute: 00)) < 0) {
                showError( "Inserisci un'ora di fine minore o uguale a 13:00 oppure maggiore o uguale a 16:00");
              } else if (end.compareTo(const TimeOfDay(hour: 19, minute: 00)) > 0) {
                showError("Inserisci un'ora di fine minore o uguale a 19:00");
              } else {
                List<Ripetizione> freeLessons = await searchFreeLessons(
                  userId,
                  _selectedSubject,
                  _selectedProfessor,
                  _selectedDay,
                  start.hour,
                  end.hour,
                  false
                );

                widget.showSearchResultsCallback(freeLessons);
              }
            },
            style: ButtonStyle(
              foregroundColor: widget.isDark
                ? MaterialStateProperty.all<Color>(Colors.black)
                : MaterialStateProperty.all<Color>(Colors.white),
              textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                fontWeight: FontWeight.w800,
              )),
              minimumSize: MaterialStateProperty.all<Size>(const Size(300, 50)),
              maximumSize: MaterialStateProperty.all<Size>(const Size(500, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(widget.accent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultPadding * 10),
                  side: BorderSide(color: widget.accent)
                )
              ),
              overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.20) ),
            ),
            child: const Text(
              'Cerca',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )),

      ),
    ]);
  }

  // FIXME: mettere stile all'alert dialog che sembri di più segnalazione di errore
  void showError(String message) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            // FIXME: bisogna cambiare il colore dell'alert in base al tema???
            // backgroundColor: ,
            title: const Text("Attenzione!"),
            content: Text("$message"),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.white.withOpacity(0.20)),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                                const TextStyle(fontWeight: FontWeight.bold)),
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                    color: Colors.blue, width: 2))),
                        child: const Text('Ok')),
                  ),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                ],
              ),
            ],
          );
        });
  }
}

// extension of class TimeOfDay that adds compareTo methods to compare two TimeOfDay objects
extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}