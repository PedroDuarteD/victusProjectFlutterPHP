import 'dart:convert';
import 'package:appvictus/SelectedLibraryPage.dart';
import 'package:appvictus/colors/ColorPalete.dart';
import 'package:appvictus/http/constants.dart';
import 'package:appvictus/model/LibraryModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:sizer/sizer.dart';


class LibraryPage extends StatelessWidget {

  int ClientID = -1;

  LibraryPage(this.ClientID);

  Future<List<LibraryModel>> getLibraryUseCase()async{
    List<LibraryModel> myLibrary = [];

    var request = await http.get(Uri.parse(HttpConstants.url+"getLibrary.php?id=${ClientID}"),
    headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${HttpConstants.Token}",
    });

    print("res: "+request.body.toString());

    var convert = jsonDecode(request.body);

    for(var item in convert["library"] ?? []){
      myLibrary.add(LibraryModel.FromJson(item));
    }
    
    
    return myLibrary;
    
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
        width: 100.w,
        height: 100.h,
        child: FutureBuilder<List<LibraryModel>>(
          future: getLibraryUseCase(),
          builder: (_, snapshot){
        if(snapshot.connectionState==ConnectionState.done || snapshot.connectionState == ConnectionState.active){

        if(snapshot.requireData.isEmpty){
          return Center(
            child: Text("Adiciona uma biblioteca", style: TextStyle(fontSize: 18),),
          );
        }else{
          return ListView.builder(
            itemBuilder: (_, position){
              return  GestureDetector(
                  onTap: (){
                    LibraryModel model =  snapshot.requireData.elementAt(position);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SelectedLibraryPage(model.title, model.desc, model.percent,model.id, this.ClientID)));
                  },
                  child: _renderCardLibrary(snapshot.requireData.elementAt(position)));
            },
            itemCount: snapshot.requireData.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(right: 5.w, left: 5.w),
          );
        }
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
          },
        ),
      );
  }

  _renderCardLibrary(LibraryModel model){
    return Container(
      width: 90.w,
      height: 90,
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: ColorPalete.defaultColor.withOpacity(.2),
        borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            height: 90,
            child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8),
                child: Image.network(model.url,fit: BoxFit.cover,)),
          ),

          SizedBox(width: 2.w,),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5,),
              Text(model.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(height: 5,),
             model.percent==0? SizedBox(
                width: 43.w,
                 height: 50,
                 child: Text(model.desc.length>75?model.desc.substring(0,75) : model.desc, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),)) :Row(
               children: [
                 SizedBox(
                   width: 30.w,
                   child: LinearProgressBar(
                     maxSteps: 100,
                     progressType: ProgressType.linear,
                     currentStep: model.percent,
                     progressColor: ColorPalete.defaultColor,
                     backgroundColor: Colors.grey,
                     borderRadius: BorderRadius.circular(10),
                     minHeight: 8,
                   ),
                 ),
                 SizedBox(width: 1.w,),
                 Text(model.percent.toString()+"%")
               ],
             )
            ],
          )
        ],
      ),
    );
  }
}
