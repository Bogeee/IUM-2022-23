import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// constants
import 'package:proj/constants.dart';
import 'package:proj/models/user.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/models/ripetizioni.dart';

// views
import 'package:proj/views/main/home/components/lesson_info_row.dart';
import 'package:proj/views/main/home/components/titles.dart';

class LessonDetails extends StatefulWidget{
  const LessonDetails({
    super.key,
    required this.lesson,
    required this.refreshUICallback
  });
  
  final Ripetizione lesson;
  final VoidCallback refreshUICallback;

  @override
  State<LessonDetails> createState() => _LessonDetailsState();
}

class _LessonDetailsState extends State<LessonDetails> {
  @override
  Widget build(BuildContext context) {
    int studentID = Provider.of<LoggedInNotifier>(context).userId;
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;
    Color appBarForegroundColor = isDark ? Colors.black : Colors.white;
    TextEditingController txtArgomento = TextEditingController();
    User? userInfo = Provider.of<LoggedInNotifier>(context).userDetails;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: accent,
        foregroundColor: appBarForegroundColor,
        title: widget.lesson.stato == 0 && !userInfo.isAdmin
            ? const Text('Modifica ripetizione') 
            : widget.lesson.stato == 0 && userInfo.isAdmin
                ? const Text('Disdici ripetizione')
                : widget.lesson.stato == 4 && !userInfo.isAdmin
                    ? const Text('Prenota ripetizione')
                    : const Text('Ripetizione')
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding / 2),
          child: Column(
            children: [
              const GenericTitle(title: 'Informazioni ripetizione'),
              const SizedBox(
                height: defaultPadding,
              ),
              LessonInfoRow(
                  icon_path: 'assets/icons/graduation-cap-solid.svg',
                  item_title: 'Materia', 
                  item: widget.lesson.corso.materia.nome),
              const LessonInfoRowSeparator(),
              widget.lesson.giorno == 'Mercoledì'
                  ? const LessonInfoRow(
                      icon_path: 'assets/icons/calendar-day-solid.svg',
                      item_title: 'Giorno', 
                      item: 'Oggi'
                    )
                  : LessonInfoRow(
                      icon_path: 'assets/icons/calendar-day-solid.svg',
                      item_title: 'Giorno', 
                      item: widget.lesson.giorno
                    ),
              const LessonInfoRowSeparator(),
              LessonInfoRow(
                icon_path: 'assets/icons/clock-regular.svg',
                item_title: 'Ora inizio',
                item: "${widget.lesson.oraI.toString()}.00"
              ),
              const LessonInfoRowSeparator(),
              LessonInfoRow(
                icon_path: 'assets/icons/clock-solid.svg',
                item_title: 'Ora fine', 
                item: "${widget.lesson.oraF.toString()}.00"
              ),
              const LessonInfoRowSeparator(),
              if (widget.lesson.stato == 0)
                const LessonInfoRow(
                  icon_path: 'assets/icons/wand-magic-sparkles-solid.svg',
                  item_title: 'Stato', 
                  item: "Attiva"
                ),
              if (widget.lesson.stato == 1)
                const LessonInfoRow(
                  icon_path: 'assets/icons/circle-check-regular.svg',
                  item_title: 'Stato', 
                  item: "Completata"
                ),
              if (widget.lesson.stato == 2)
                const LessonInfoRow(
                  icon_path: 'assets/icons/circle-xmark-regular.svg',
                  item_title: 'Stato', 
                  item: "Annullata"
                ),
              if(widget.lesson.stato == 4)
                const LessonInfoRow(
                    icon_path: 'assets/icons/wand-magic-sparkles-solid.svg',
                    item_title: 'Stato',
                    item: "Disponibile"
                ),
              const LessonInfoRowSeparator(),
              if (widget.lesson.argomento != "")
                LessonInfoRow(
                  icon_path: 'assets/icons/hand-point-up-regular.svg',
                  item_title: 'Argomento', 
                  item: widget.lesson.argomento
                ),
              if (widget.lesson.argomento != "") const LessonInfoRowSeparator(),
              const SizedBox(height: defaultPadding),
              const GenericTitle(title: 'Informazioni docente'),
              const SizedBox(
                height: defaultPadding,
              ),
              LessonInfoRow(
                icon_path: 'assets/icons/user-tie-solid.svg',
                item_title: 'Nome e cognome',
                item: "${widget.lesson.corso.docente.nome} ${widget.lesson.corso.docente.cognome}"
              ),
              const LessonInfoRowSeparator(),
              LessonInfoRow(
                icon_path: 'assets/icons/at-solid.svg',
                item_title: 'Email', 
                item: widget.lesson.corso.docente.email
              ),
              const LessonInfoRowSeparator(),
              
              widget.lesson.stato != 4
                ? const SizedBox(height: 2*defaultPadding,)
                : const SizedBox(height: defaultPadding),
              
              if(widget.lesson.stato == 4 && !userInfo.isAdmin)
                Row(
                  children: const [
                    Text(
                      "Inserisci l'argomento (opzionale)",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                    )
                  ],
                ),
              if(widget.lesson.stato == 4 && !userInfo.isAdmin)
                const SizedBox(height: 0.5 * defaultPadding,),
              if (widget.lesson.stato == 4 && !userInfo.isAdmin)
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey, width: 0.0
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: accent, width: 2.0
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  maxLength: 512,
                  maxLines: 4,
                  controller: txtArgomento,
                  buildCounter: (
                    BuildContext context, {
                    required int currentLength,
                    required int? maxLength,
                    required bool isFocused,
                  }) {
                    return Text(
                      '$currentLength di $maxLength caratteri',
                      semanticsLabel: 'conteggio caratteri',
                    );
                  },
                ),

              if(widget.lesson.stato == 0)
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: (){
                          cancelLesson(context, studentID);
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                          overlayColor: MaterialStateProperty.all<Color>(Colors.red.withOpacity(0.20)),
                          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                            fontWeight: FontWeight.bold
                          )),
                          side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.red, width: 2))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/triangle-exclamation-solid.svg',
                              width: 14,
                              color: Colors.red
                            ),
                            const SizedBox(width: 5,),
                            const Text('Disdici')
                          ],
                        ),
                      )
                    ),
                    if((widget.lesson.giorno == 'Mercoledì'
                       || widget.lesson.giorno == 'Martedì'
                       || widget.lesson.giorno == 'Lunedì')
                       && !userInfo.isAdmin)
                      const Expanded(
                        flex: 1,
                        child: SizedBox()
                      ),
                    if((widget.lesson.giorno == 'Mercoledì'
                       || widget.lesson.giorno == 'Martedì'
                       || widget.lesson.giorno == 'Lunedì')
                       && !userInfo.isAdmin)
                      Expanded(
                        flex: 2,
                        child: OutlinedButton(
                          onPressed: (){
                            finishedLesson(context, studentID);
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                            overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.20)),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(fontWeight: FontWeight.bold)
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(color: Colors.green, width: 2)
                            )
                          ),
                          child: const Text('Completata'),
                        )
                      )
                  ],
                ),

                if(widget.lesson.stato == 4 && !userInfo.isAdmin)
                  Row(children: [
                  Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: () async {
                          String result = await insertLesson(widget.lesson, txtArgomento.text);
                          if(result == "OK") {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prenotazione inserita con successo')));
                            widget.refreshUICallback();
                            Navigator.of(context).pop(); // close lesson_details
                          } else if (result == "KO") {
                            showError(context, "Hai già un'altra lezione in questo giorno e a questo orario");
                          } else if (result == "ALR"){
                            showError(context, "Hai già disdetto questa lezione. Devi cambiare orario o professore.");
                          }
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.blue.withOpacity(0.20)),
                            textStyle: MaterialStateProperty.all<TextStyle>(
                                const TextStyle(fontWeight: FontWeight.bold)),
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(color: Colors.blue, width: 2)
                            )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Prenota')
                          ],
                        ),
                      )
                    ),
                ]
              )
            ],
          ),
        ),
      ),
    );
  }

  void cancelLesson(BuildContext context, int studentID){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma'),
          content: const Text('Sei sicuro di voler ANNULLARE la ripetizione?\n\nQuesta operazione è irreversibile!'),
          actions: <Widget>[
            Row(
              children: [
                const SizedBox(width: defaultPadding,),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: (){
                      // Non confermato
                      Navigator.of(context).pop(); // close dialog
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      overlayColor: MaterialStateProperty.all<Color>(Colors.red.withOpacity(0.20)),
                      textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                        fontWeight: FontWeight.bold
                      )),
                      side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.red, width: 2))
                    ),
                    child: const Text('No')
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(width: 4*defaultPadding,),
                ),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: () {
                      // confermato, annullo la lezione
                      deleteLesson(widget.lesson, widget.lesson.studente);
                      widget.refreshUICallback();
                      Navigator.of(context).pop(); // close dialog
                      Navigator.of(context).pop(); // close lesson_details
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.white.withOpacity(0.20)),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(fontWeight: FontWeight.bold)),
                        side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(color: Colors.blue, width: 2))),
                    child: const Text('Si')
                  ),
                ),
                const SizedBox(width: defaultPadding,),
              ],
            ),
          ],
        );
      },
    );
  }

  void finishedLesson(BuildContext context, int studentID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma'),
          content: const Text(
              'Sei sicuro di voler contrassegnare come COMPLETATA la ripetizione?\n\nNon potrai più modificarlo in seguito.'),
          actions: <Widget>[
            Row(
              children: [
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                      onPressed: () {
                        // Non confermato
                        Navigator.of(context).pop(); // close dialog
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.red.withOpacity(0.20)),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(fontWeight: FontWeight.bold)),
                          side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(color: Colors.red, width: 2))),
                      child: const Text('No')),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 4 * defaultPadding,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                      onPressed: () {
                        // confermato, annullo la lezione
                        completeLesson(widget.lesson, widget.lesson.studente);
                        widget.refreshUICallback();
                        Navigator.of(context).pop(); // close dialog
                        Navigator.of(context).pop(); // close lesson_details
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
                              const BorderSide(color: Colors.blue, width: 2))),
                      child: const Text('Si')),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // FIXME: mettere stile all'alert dialog che sembri di più segnalazione di errore
  void showError(BuildContext context, String message) {
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