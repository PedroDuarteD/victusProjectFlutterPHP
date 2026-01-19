import 'dart:convert';
import 'package:appvictus/colors/ColorPalete.dart';
import 'package:appvictus/http/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class ProfilePage extends StatelessWidget {

  ProfilePage(this.idUser);

  int idUser = -1;
  String name = "", email = "";

  TextEditingController _editPeso = new TextEditingController();

  Future getUserData()async{
    var request = await http.get(Uri.parse(HttpConstants.url+"getProfileUserData.php?idUser=${this.idUser}"),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer ${HttpConstants.Token}",
    });

    print("all data: "+request.body.toString());

    var convert = jsonDecode(request.body);

    name = convert["name"];
    email = convert["email"];
    _editPeso.text =  convert["peso"].toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(),
      builder: (context, asyncSnapshot) {
        if(asyncSnapshot.connectionState==ConnectionState.done || asyncSnapshot.connectionState==ConnectionState.active){
          return Container(
            margin: EdgeInsets.only(right: 5.w, left: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle,size: 80,)
                  ],
                ),

                SizedBox(
                  height: 25,
                ),
                Text("Nome: "+name, style: TextStyle(fontSize: 16),),
                SizedBox(
                  height: 15,
                ),
                Text("Email: "+email, style: TextStyle(fontSize: 16),),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Atualizar peso?"),
                      Container(

                        child: TextField(
                          controller: _editPeso,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                              )
                          ),
                        ),
                      ),

                      Container(
                        width: 90.w,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalete.defaultColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(10)
                              )
                            ),
                            onPressed: ()async{
                          if(_editPeso.text.isNotEmpty){


                            var request = await http.put(Uri.parse(HttpConstants.url+"updatePesoAccount.php"),
                                headers: {
                                  'Content-type': 'application/json',
                                  'Accept': 'application/json',
                                  "Authorization": "Bearer ${HttpConstants.Token}",
                                }, body: jsonEncode({
                                  "number" : _editPeso.text,
                                  "idUser" : this.idUser
                                }));

                            print("from server: "+request.body.toString());

                            var convert = jsonDecode(request.body);

                            if(convert["res"]=="success"){

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));
                            }


                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sem peso para atualizar !")));
                          }
                        }, child: Text("Atualizar", style: TextStyle(color: Colors.white),)),
                      )

                    ],
                  ),
                )
              ],
            ),
          );
        }else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}
