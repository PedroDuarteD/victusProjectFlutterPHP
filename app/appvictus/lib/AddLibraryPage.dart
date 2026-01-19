import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'colors/ColorPalete.dart';
import 'http/constants.dart';

class AddLibraryPage extends StatelessWidget {

  TextEditingController _editTitle = new TextEditingController();
  TextEditingController _editDesc = new TextEditingController();
  TextEditingController _editUrl = new TextEditingController();


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Adicionar Biblioteca"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.only(right: 5.w, left: 5.w, top: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Text("Title"),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: TextField(
                controller: _editTitle,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(.2),width: 2),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(.2),width: 2),
                      borderRadius: BorderRadius.circular(10)

                  ),

                ),
              ),
            ),


            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Text("Descrição"),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: TextField(
                controller: _editDesc,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(.2),width: 2),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(.2),width: 2),
                      borderRadius: BorderRadius.circular(10)

                  ),

                ),
              ),
            ),




            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Text("Url"),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: TextField(
                controller: _editUrl,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(.2),width: 2),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(.2),width: 2),
                      borderRadius: BorderRadius.circular(10)

                  ),

                ),
              ),
            ),


            Container(
                width: 90.w,
                height: 8.h,
                margin: EdgeInsets.only(bottom: 3.h),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(ColorPalete.defaultColor),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(14)))
                  ),
                  onPressed: ()async{


                    if(_editTitle.text.isNotEmpty && _editDesc.text.isNotEmpty && _editUrl.text.isNotEmpty){

                      var request = await http.post(Uri.parse(HttpConstants.url+"addLibrary.php"),
                          headers: {
                            'Content-type': 'application/json',
                            'Accept': 'application/json',
                            "Authorization": "Bearer ${HttpConstants.Token}",
                          },
                          body: jsonEncode({
                            "title" : _editTitle.text,
                            "desc" : _editDesc.text,
                            "url" : _editUrl.text,
                          }));
                      print("all decode: "+request.body.toString());

                      var convert = jsonDecode(request.body);


                      if(convert["res"]=="success"){

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));
                      }else{

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                      }

                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor preenche tudo !")));
                    }






                  }, child: Text("Entrar",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
                )),

          ],
        ),
      ),
    );
  }
}
