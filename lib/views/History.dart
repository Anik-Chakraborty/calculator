import 'package:calculator/config/colors.dart';
import 'package:calculator/config/strings.dart';
import 'package:calculator/models/HistoryModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class History extends StatelessWidget{
  const History({super.key});

  Future getHistory() async{

    final directory = await getApplicationDocumentsDirectory();

    final collection = await BoxCollection.open(
      AppConstants.calculatorDB, // Name of your database
      {AppConstants.historyBox}, // Names of your boxes
      path: directory.path, // Path where to store your boxes (Only used in Flutter / Dart IO)
    );

    final historyBox = await collection.openBox<Map>(AppConstants.historyBox);

    final history = await historyBox.getAllValues();

    List<HistoryModel> data = [];
    history.entries.map((entry) {
      data.add(HistoryModel.fromMap(entry.value));
    }).toList();

    return data;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: getHistory(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            List<HistoryModel?> history = snapshot.data;

            if(history.isEmpty){
              return Center(child: Text('History is empty', style: GoogleFonts.montserrat(color: Colors.white),),);
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(history[index]?.value ?? '0', textAlign: TextAlign.end, style: GoogleFonts.montserrat(fontSize: 25, color: AppColors.primaryColor),),
                                const SizedBox(height: 10,),
                                Text(history[index]?.expression ?? '0', textAlign: TextAlign.end, style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white),),
                              ],
                            ),
                          ),
                          Positioned(
                              top: 0,
                              left: 30,
                              child: Text(history[index]?.dateTime ?? '', style: GoogleFonts.montserrat(color: Colors.white, fontSize: 13, backgroundColor: Colors.black))),
                        ],
                      );
                    },),
                  ),
                ],
              ),
            );
          }
          else if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          else {
            return Center(child: Text('History is empty', style: GoogleFonts.montserrat(color: Colors.white),),);
          }
        },
      ),
    );
  }

}