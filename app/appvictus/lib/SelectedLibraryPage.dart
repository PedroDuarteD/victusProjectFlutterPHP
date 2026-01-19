import 'dart:convert';
import 'package:appvictus/colors/ColorPalete.dart';
import 'package:appvictus/http/constants.dart';
import 'package:appvictus/model/LibraryDetailsModel.dart';
import 'package:appvictus/model/LibrarySectionModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class SelectedLibraryPage extends StatefulWidget {

  String title = "", description = "", url ="";
  int progress = 0, idLibrary=-1, idUser=-1;

  SelectedLibraryPage(this.title, this.description, this.progress, this.idLibrary, this.idUser);

  @override
  State<SelectedLibraryPage> createState() => _SelectedLibraryPageState();
}

class _SelectedLibraryPageState extends State<SelectedLibraryPage> {

  bool checkFavorite  = false, checkStar = false, checkDone = false;
  int idFavorite = -1, idStar = -1, idDone= -1;
  int currentIndexSection = -1,  currentIndexPlayer   = 0;

  String urlCurrentPlayer ="";

  ValueNotifier notifySectionOpen = ValueNotifier(-1);

  late Future<LibraryDetailsModel> getSelectedLibrary;



  Future<LibraryDetailsModel> getSelectedLibraryData()async{
    var request = await http.get(Uri.parse(HttpConstants.url+"getSelectedLibrary.php?idLibrary=${widget.idLibrary}&idUser=${widget.idUser}"),
    headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${HttpConstants.Token}",
    });
    print("res data: "+request.body.toString());
    var convert = jsonDecode(request.body);

    print("userid: "+widget.idUser.toString());
    print("id lib: "+widget.idLibrary.toString());



    var model = LibraryDetailsModel.FromJson(widget.idLibrary, widget.url,widget.title, widget.description, widget.progress, convert);
    idDone=model.idDone;

    //get current position in sections
    for(var itemSection in model.sections){
      for(var itemContent in itemSection.contents){
        if(itemContent.idLibrarySectionContent == model.currentIndexPlayer){
          currentIndexSection = model.sections.indexOf(itemSection);
          urlCurrentPlayer = itemContent.videoURL;
        }
      }
    }



    if(model.idDone!=-1){
      checkDone = true;
    }
    idStar = model.idStar;
    if(model.idStar!=-1){
      checkStar = true;
    }
    idFavorite = model.idLike;
    if(model.idLike!=-1){
      checkFavorite = true;
    }

    return model;

  }
  
  @override
  void initState(){
    super.initState();
    getSelectedLibrary = getSelectedLibraryData();

  }



  Future<ChewieController> loadingVideoController()async{


    final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(urlCurrentPlayer));


    late final chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
    );

   await videoPlayerController.initialize();

   return chewieController;
  }




  @override
  Widget build(BuildContext context) {



    return FutureBuilder<LibraryDetailsModel>(
      future: getSelectedLibrary,
      builder: (context, snapshot) {

        if(snapshot.connectionState==ConnectionState.done || snapshot.connectionState ==ConnectionState.active){


          return Scaffold(
            backgroundColor: ColorPalete.colorBlack,
            appBar: AppBar(
              foregroundColor: Colors.white,
              title: Column(
                children: [
                  Text(widget.title,style: TextStyle(color: Colors.white),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30.w,
                        child: LinearProgressBar(
                          maxSteps: 100,
                          progressType: ProgressType.linear,
                          currentStep: widget.progress,
                          progressColor: ColorPalete.defaultColor,
                          backgroundColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          minHeight: 8,
                        ),
                      ),
                      SizedBox(width: 1.w,),
                      Text(widget.progress.toString()+"%",style: TextStyle(color: Colors.grey, fontSize: 15),)
                    ],
                  ),

                ],
              ),
              backgroundColor: Colors.black,
              centerTitle: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 100.w,
                    height: 300,
                    child: urlCurrentPlayer.isNotEmpty?
                    FutureBuilder(
                      future: loadingVideoController(),
                      builder: (_, snapshot){
                        if(snapshot.connectionState==ConnectionState.done || snapshot.connectionState ==ConnectionState.active){
                          return Chewie(
                            controller: snapshot.requireData,
                          );
                        }else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                        :
                    Center(child: Text("Sem vídeo",style: TextStyle(color: Colors.white),),),
                ),
                Container(
                  color: ColorPalete.colorBlack,
                  padding: EdgeInsets.only(top: 15, left: 5.w, right: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.title,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                          Container(

                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(onPressed: ()async{


                                  if(idStar!=-1){
                                    var request = await http.delete(Uri.parse(HttpConstants.url+"LibraryActions/removeLibraryActions.php"),
                                        headers: {
                                          "Content-type": "application/json",
                                          "Accept": "application/json",
                                          "Authorization": "Bearer ${HttpConstants.Token}",
                                        }, body: jsonEncode({
                                          "idLibrary" : widget.idLibrary,
                                          "idUser" : widget.idUser,
                                          "parametro" : 2,
                                          "idRow" : idStar
                                        }));

                                    print("res: "+request.body.toString());

                                    var convert = jsonDecode(request.body);

                                    print("url: idLibrary=${widget.idLibrary}&idUser=${widget.idUser}&parametro=3"+ ( idDone!=-1? "&idRow=$idDone" : ""));
                                    print("res body: "+convert.toString());

                                    if(convert["res"]=="success"){
                                      setState(() {
                                        idStar = convert["idRow"] ?? -1;
                                        checkStar = !checkStar;
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                                      });
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                                    }
                                  }else{
                                    var request = await http.post(Uri.parse(HttpConstants.url+"LibraryActions/addLibraryActions.php"),
                                        headers: {
                                          "Content-type": "application/json",
                                          "Accept": "application/json",
                                          "Authorization": "Bearer ${HttpConstants.Token}",
                                        },body: jsonEncode({
                                          "idLibrary" : widget.idLibrary,
                                          "idUser"   :  widget.idUser,
                                          "parametro" : 2
                                        }));

                                    print("res: "+request.body.toString());

                                    var convert = jsonDecode(request.body);

                                    if(convert["res"]=="success"){
                                      setState(() {
                                        idStar = convert["idRow"] ?? -1;
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                                        checkStar = !checkStar;
                                      });
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                                    }
                                  }






                                }, icon: Icon(Icons.star, color: checkStar ? ColorPalete.defaultColor : null,)),
                                IconButton(onPressed: ()async{

                                  // json.addAll({
                                  //   "idRow" : idFavorite
                                  // });

                                  if(idFavorite!=-1){
                                    var request = await http.delete(Uri.parse(HttpConstants.url+"LibraryActions/removeLibraryActions.php"),
                                        headers: {
                                          "Content-type": "application/json",
                                          "Accept": "application/json",
                                          "Authorization": "Bearer ${HttpConstants.Token}",
                                        }, body: jsonEncode({
                                          "idLibrary" : widget.idLibrary,
                                          "idUser" : widget.idUser,
                                          "parametro" : 1,
                                          "idRow" : idFavorite
                                        }));

                                    print("res: "+request.body.toString());

                                    var convert = jsonDecode(request.body);

                                    print("url: idLibrary=${widget.idLibrary}&idUser=${widget.idUser}&parametro=3"+ ( idDone!=-1? "&idRow=$idDone" : ""));
                                    print("res body: "+convert.toString());

                                    if(convert["res"]=="success"){
                                      setState(() {
                                        idFavorite = convert["idRow"] ?? -1;
                                        checkFavorite = !checkFavorite;
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                                      });
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                                    }
                                  }else{
                                    var request = await http.post(Uri.parse(HttpConstants.url+"LibraryActions/addLibraryActions.php"),
                                        headers: {
                                          "Content-type": "application/json",
                                          "Accept": "application/json",
                                          "Authorization": "Bearer ${HttpConstants.Token}",
                                        }, body: jsonEncode({
                                          "idLibrary" : widget.idLibrary,
                                          "idUser" : widget.idUser,
                                          "parametro" : 1
                                        }));

                                    var convert = jsonDecode(request.body);
                                    print("id fav: idLibrary=${widget.idLibrary}&idUser=${widget.idUser}&parametro=1&valor="+(checkFavorite? "1" : "0")+"&idRow=$idFavorite");
                                    if(convert["res"]=="success"){
                                      print("men: "+convert.toString());
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                                      setState(() {
                                        idFavorite = convert["idRow"] ?? -1;
                                        checkFavorite = !checkFavorite;
                                      });
                                    }else{

                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));
                                    }
                                  }


                                }, icon: Icon(Icons.favorite, color: checkFavorite ? ColorPalete.defaultColor : null)),
                                GestureDetector(
                                    onTap: ()async{
                                      if(idDone!=-1){
                                        var request = await http.delete(Uri.parse(HttpConstants.url+"LibraryActions/removeLibraryActions.php"),
                                            headers: {
                                              "Content-type": "application/json",
                                              "Accept": "application/json",
                                              "Authorization": "Bearer ${HttpConstants.Token}",
                                            }, body: jsonEncode({
                                              "idLibrary" : widget.idLibrary,
                                              "idUser" : widget.idUser,
                                              "parametro" : 3,
                                              "idRow" : idDone
                                            }));

                                        print("res: "+request.body.toString());

                                        var convert = jsonDecode(request.body);

                                        print("url: idLibrary=${widget.idLibrary}&idUser=${widget.idUser}&parametro=3"+ ( idDone!=-1? "&idRow=$idDone" : ""));
                                        print("res body: "+convert.toString());

                                        if(convert["res"]=="success"){
                                          setState(() {
                                            idDone = convert["idRow"] ?? -1;
                                            checkDone = !checkDone;
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                                          });
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                                        }
                                      }else{
                                        var request = await http.post(Uri.parse(HttpConstants.url+"LibraryActions/addLibraryActions.php"),
                                            headers: {
                                              "Content-type": "application/json",
                                              "Accept": "application/json",
                                              "Authorization": "Bearer ${HttpConstants.Token}",
                                            }, body: jsonEncode({
                                              "idLibrary" : widget.idLibrary,
                                              "idUser" : widget.idUser,
                                              "parametro" : 3,
                                            }));

                                        var convert = jsonDecode(request.body);

                                        print("url: idLibrary=${widget.idLibrary}&idUser=${widget.idUser}&parametro=3"+ ( idDone!=-1? "&idRow=$idDone" : ""));
                                        print("res body: "+convert.toString());

                                        if(convert["res"]=="success"){
                                          setState(() {
                                            idDone = convert["idRow"] ?? -1;
                                            checkDone = !checkDone;
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                                          });
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                                        }
                                      }


                                    },
                                    child: Container(
                                        width: 25,
                                        height: 25,
                                        margin: EdgeInsets.only(top: 9, left: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: checkDone ? ColorPalete.defaultColor : null
                                        ),
                                        child: Icon(Icons.done, color: checkDone ? Colors.white : Colors.white.withOpacity(.4))))

                              ],
                            ),
                          )
                        ],
                      ),

                      Text(widget.description, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),),

                      SizedBox(height: 20,),

                snapshot.requireData.sections.isNotEmpty && snapshot.requireData.sections.elementAt(currentIndexSection).contents.isNotEmpty && (currentIndexPlayer+1) <(snapshot.requireData.sections.elementAt(currentIndexSection).contents.length)?   Container(
                        padding: EdgeInsets.only(right: 2.w, left: 7.w, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusGeometry.circular(30),
                            color: Colors.white.withOpacity(.2)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Próxima aula",style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey,fontSize: 15),),
                                Text(snapshot.requireData.sections.elementAt(currentIndexSection).contents.elementAt(currentIndexPlayer+1).title, style: TextStyle(color: Colors.white, fontSize: 15),)
                              ],
                            ),

                            IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: Colors.orange
                                ),
                                onPressed: (){

                                  updateCurrentPlayerInDB(snapshot.requireData.idLibraryUser, snapshot.requireData.sections.elementAt(currentIndexSection).contents.elementAt((currentIndexPlayer+1)).idLibrarySectionContent);
                                      setState(() {

                                        currentIndexPlayer +=1;
                                         urlCurrentPlayer = snapshot.requireData.sections.elementAt(currentIndexSection).contents.elementAt(currentIndexPlayer).videoURL;
                                        });
                                  
                                }, icon: Icon(Icons.play_arrow, color: ColorPalete.colorBlack,))
                          ],
                        ),
                      ) : snapshot.requireData.sections.length > (currentIndexSection+1) ? Container(
                  padding: EdgeInsets.only(right: 2.w, left: 7.w, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusGeometry.circular(30),
                      color: Colors.white.withOpacity(.2)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Próxima aula",style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey,fontSize: 15),),
                          Text(snapshot.requireData.sections.elementAt(currentIndexSection+1).contents.first.title, style: TextStyle(color: Colors.white, fontSize: 15),)
                        ],
                      ),

                      IconButton(
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.orange
                          ),
                          onPressed: (){
                            setState(() {

                              updateCurrentPlayerInDB(snapshot.requireData.idLibraryUser, snapshot.requireData.sections.elementAt((currentIndexSection+1)).contents.elementAt(0).idLibrarySectionContent);


                              currentIndexSection +=1;
                              currentIndexPlayer  =0;
                              urlCurrentPlayer = snapshot.requireData.sections.elementAt(currentIndexSection).contents.elementAt(currentIndexPlayer).videoURL;
                            });

                          }, icon: Icon(Icons.play_arrow, color: ColorPalete.colorBlack,))
                    ],
                  ),
                ) : Container(),
                      snapshot.requireData.sections.isNotEmpty &&  snapshot.requireData.sections.elementAt(currentIndexSection).contents.isNotEmpty? SizedBox(height: 20,) : Container(),

                      SizedBox(
                        width: 90.w,
                        height: 300,
                        child: ValueListenableBuilder(
                          valueListenable: notifySectionOpen,
                          builder: (context, value, other) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.requireData.sections.length,
                              itemBuilder: (_, position){

                                LibrarySectionModel model = snapshot.requireData.sections.elementAt(position);

                                return Container(
                                  padding: EdgeInsets.all(4),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white.withOpacity(.3),width: 0.4),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: ()async{

                                if((currentIndexSection +2) > position){
                                  if(value == position){
                                    notifySectionOpen.value = -1;
                                  }else{
                                    notifySectionOpen.value = position;
                                  }
                                }

                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  margin: EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: currentIndexSection+1 == position || currentIndexSection == position ? ColorPalete.defaultColor : ( position  <currentIndexSection ? ColorPalete.defaultColor:Colors.white),

                                                  ),
                                                  child: currentIndexSection+1 == position|| currentIndexSection == position ?  Icon(Icons.done, color: currentIndexSection==position?  Colors.white : ColorPalete.colorBlack,) : (position  <currentIndexSection ? Icon(Icons.done, color: Colors.white,) :Icon(Icons.lock, color: ColorPalete.colorBlack,)),
                                                ),
                                                Text((position+1).toString()+" | ${model.title}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                              ],
                                            ),
                                          ),

                                          IconButton(onPressed: (){

                                            if((currentIndexSection +2) > position){
                                              if(value == position){
                                                notifySectionOpen.value = -1;
                                              }else{
                                                notifySectionOpen.value = position;
                                              }
                                            }

                                          }, icon: value==position? Icon(Icons.arrow_drop_up): Icon(Icons.arrow_drop_down, color: Colors.white,))

                                        ],
                                      ),
                                     value==position ?  Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                        children: model.contents.map((row) {
                                          return Container(
                                            margin: EdgeInsets.only(left: 4.8.w),
                                            padding: EdgeInsets.only(top: 15,bottom: 15),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    style: IconButton.styleFrom(
                                                        backgroundColor: Colors.orange
                                                    ),
                                                    onPressed: (){

                                                      if(currentIndexPlayer == model.contents.indexOf(row)){
                                                        setState(() {
                                                          currentIndexPlayer = -1;
                                                          urlCurrentPlayer = "";
                                                        });

                                                      }else{
                                                        setState(() {

                                                          updateCurrentPlayerInDB(snapshot.requireData.idLibraryUser, snapshot.requireData.sections.elementAt(position).contents.elementAt(model.contents.indexOf(row)).idLibrarySectionContent);


                                                          currentIndexSection = position;
                                                          currentIndexPlayer = model.contents.indexOf(row);
                                                          urlCurrentPlayer = row.videoURL;

                                                        });
                                                      }





                                                    }, icon: position==currentIndexSection && model.contents.indexOf(row)==currentIndexPlayer? Icon(Icons.pause, color: Colors.white,): Icon(Icons.play_arrow, color: ColorPalete.colorBlack,)),
                                                SizedBox(width: 15,),
                                                Text(row.title,style: TextStyle(color: Colors.white),),
                                              ],
                                            ),
                                          );
                                        }).toList()
                                      ) : Container(),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        ),
                      )

                    ],
                  ),
                )
              ],
            ),
          );
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      }
    );
  }

  updateCurrentPlayerInDB(int idLibraryUser, int idlibContent)async{
    await http.put(Uri.parse(HttpConstants.url+"LibraryActions/updateProgressLibrary.php"),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${HttpConstants.Token}",
    }, body: jsonEncode({
          "idLibraryUser" : idLibraryUser,
          "number" : idlibContent,
        }));
  }
}
