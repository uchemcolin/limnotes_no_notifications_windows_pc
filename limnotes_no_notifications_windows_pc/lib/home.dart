import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

//My own files
import './addNote.dart';
import './editNote.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences _prefs; //for accessing shared preferences

  late List<dynamic> notes; //to store the notes

  late List<String> notesCreatedAtTimes; //list of the times the notes were created in ascending order (i.e. the variable to hold the dates sorted in ascending order)

  late List<String> bodys; //variable to store the body of the notes

  late List<String> titles; //variable to store the tilte of the notes

  late List<String> createdAtTimes; //list of the times the notes were created

  bool notesDoneLoading = false; //if the notes are done loading

  int selectedIndex = 0; //the selected index of the navigation body

  _getNotesList() async {
    bodys = [];

    titles = [];

    createdAtTimes = [];
    
    notes = [];

    notesCreatedAtTimes = [];

    _prefs = await SharedPreferences.getInstance(); //get the instance of shared preferences

    //get the bodys of the notes
    if (_prefs.getStringList("bodys") != null) {
      bodys = _prefs.getStringList("bodys")!.toList();
      setState(() {});
    }

    //get the titles of the notes
    if (_prefs.getStringList("titles") != null) {
      titles = _prefs.getStringList("titles")!.toList();
      setState(() {});
    }

    //get the createdAtTimes of the notes
    if (_prefs.getStringList("createdAtTimes") != null) {
      createdAtTimes = _prefs.getStringList("createdAtTimes")!.toList();
      setState(() {});
    }

    if(bodys.isNotEmpty == true || titles.isNotEmpty == true || createdAtTimes.isNotEmpty == true) {

      List<dynamic> testNotes = []; //hold the notes before they are sorted in descending order according to the dates they were created
      for(int i = 0; i < bodys.length; i++) {
        var n = {
          "title": titles[i],
          "body": bodys[i],
          "createdAtTimes": createdAtTimes[i]
        };

        testNotes.add(n);
        
      }

      for(int k = 0; k < testNotes.length; k++) {

        notesCreatedAtTimes.add(testNotes[k]["createdAtTimes"]); //store the createdAtTimes of the notes
        
      }

      //sort the createdAtTimes strings in descending order
      notesCreatedAtTimes.sort((a,b) {
        return b.compareTo(a); //swap a for b and vise versa to make it to be in ascending order
      });

      print("notesCreatedAtTimes: ");

      print(notesCreatedAtTimes);
      setState(() {
        for(int m = 0; m < notesCreatedAtTimes.length; m++) {

          for(int l = 0; l < testNotes.length; l++) {
            if(notesCreatedAtTimes[m] == testNotes[l]["createdAtTimes"]) {
              notes.add(testNotes[l]); //sort the notes in descending order according to the createdAtTimes
            }
          }
        }
      });

      setState(() {
        notesDoneLoading = true; //set the notes done loading to true
      });

    } else {

      bodys = [];

      titles = [];

      createdAtTimes = [];

      notes = [];

      setState(() {
        notesDoneLoading = true;
      });
      
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getNotesList(); //get the notes value
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return NavigationView(
    //return ScaffoldPage(
      appBar: NavigationAppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(
          "LimNotes",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: Row(
          children: [
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(
                top: 12, 
                right: 5
              ),
              child: OutlinedButton(
                child: Row(
                  children: [
                    Text("Create Note"),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(
                        FluentIcons.add,
                        size: 15.0,
                      ),
                    )
                  ]
                ),
                onPressed: () {
                  // go to the page to create a new note
                  Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (context) => const AddNotePage()),
                    FluentPageRoute(builder: (context) => const AddNotePage()),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 12, 
                right: 20
              ),
              child: OutlinedButton(
                child: Row(
                  children: [
                    Text("Info"),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(
                        FluentIcons.info,
                        size: 15.0,
                      ),
                    )
                  ]
                ),
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => ContentDialog(
                      title: const Text(
                        'Info',
                        textAlign: TextAlign.center,
                      ),
                      content: Container(
                        height: 50.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Developed by Colin Uchem ",
                                    style: TextStyle(
                                      color: Colors.black
                                    )
                                  ),
                                  TextSpan(
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline
                                    ),
                                    text: "(www.uchemcolin.xyz)",
                                      recognizer: TapGestureRecognizer()..onTap =  () async{
                                        var url = Uri.parse("http://www.uchemcolin.xyz");
                                        
                                        if (await canLaunchUrl(url)) {
                                        //try {
                                          await launchUrl(url);
                                        } else {
                                        //} catch(e) {
                                          //throw 'Could not launch $url';
                                          //uncomment for debugging purposes

                                          showSnackbar(
                                            context,
                                            Snackbar(
                                              content: Text(
                                                "Could not open the website",
                                                style: TextStyle(
                                                  fontSize: 18
                                                ),
                                                textAlign: TextAlign.center
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                  ),
                                ]
                            )),
                            Divider(
                              //color: Colors.black,
                            ),
                            Container(
                              width: double.infinity,
                              child: const Text(
                                'LimNotes version: 1.0.0',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13
                                ),
                              ),
                            ),
                          ]
                        )
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    )
                  );
                
                },
              ),
            ),
          ],
        )
      
      ),
      content: NavigationBody(
        index: selectedIndex,
        children: [
          FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

              if(notesDoneLoading == true) {

                if(notes.isNotEmpty == true) {
                  //
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, i) {

                      int noteIndex = i;

                      String listBuilderTitle = notes[i]["title"].toString();
                      String listBuilderBody = notes[i]["body"].toString();
                      String listBuilderCreatedAt = notes[i]["createdAtTimes"].toString();

                      DateTime dt = DateTime.parse(listBuilderCreatedAt); //convert the createdAtTime string to dateTime of the note

                      String dtDay = DateFormat('dd').format(dt); //get the day in 'dd' format

                      String dtYear = DateFormat('yyyy').format(dt); //get the year in 'yyyy' format

                      DateTime now = DateTime.now(); //get the current date

                      String nowDay = DateFormat('dd').format(now); //get the day of today's day (current time now)

                      String nowYear = DateFormat('yyyy').format(now); //get the 'year' of the current date

                      String formattedDate = ""; //the formatted date string to show

                      //if(dt)
                      if(dtDay == nowDay) {
                        formattedDate = DateFormat.jm().format(dt); //5:08 PM
                      } else {
                        if(dtYear == nowYear) {
                          formattedDate = DateFormat('MMMM d').format(dt); //October 2
                          
                        } else {
                          formattedDate = DateFormat('MMMM d, yyyy').format(dt); //October 2, 2022
                        }
                      }

                      if(listBuilderTitle == "" || listBuilderTitle.isEmpty) {
                        
                        return GestureDetector(
                          child: ListTile(
                            title: Text(
                              listBuilderBody,
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              formattedDate
                            ),
                          ),
                          onTap: () {

                            //go to the edit note page
                            Navigator.push(
                              context,

                              //MaterialPageRoute(builder: (context) => EditNotePage(notes[noteIndex]))
                              FluentPageRoute(builder: (context) => EditNotePage(notes[noteIndex]))
                            );
                          },
                        );
                      
                      } else {

                        return GestureDetector(
                          child: ListTile(
                            title: Text(
                              listBuilderTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  formattedDate
                                ),
                              ]
                            )
                          ),
                          onTap: () {

                            //go to the edit note page

                            Navigator.push(
                              context,

                              //MaterialPageRoute(builder: (context) => EditNotePage(notes[noteIndex])),
                              FluentPageRoute(builder: (context) => EditNotePage(notes[noteIndex])),
                            );
                          }
                        );

                      }
                    },
                  );

                } else {

                  return const Center(
                    child: Text(
                      "There are currently no notes.",
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  );
                }
              } else {
                return const Center(
                  child: ProgressRing()
                );
              }
            },
          ),
        ]
      ),
    );
  }
}