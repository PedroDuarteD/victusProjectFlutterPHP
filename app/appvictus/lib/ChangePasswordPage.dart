import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import 'colors/ColorPalete.dart';
import 'homePage.dart';
import 'http/constants.dart';
import 'model/CarouselModel.dart';
import 'model/EventModel.dart';


class ChangePasswordPage extends StatefulWidget {

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {


  TextEditingController _editEmail = new TextEditingController();
  TextEditingController _editPassword = new TextEditingController();
  TextEditingController _editConfirmPassword = new TextEditingController();

  bool showPassword = true;
  bool showConfirmPassword = true;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Mudar password da sua conta",style: TextStyle(fontWeight: FontWeight.w600),),
        leading: GestureDetector(
          onTap: (){

            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              ColorPalete.defaultColor2.withOpacity(0.1), // Cor bem suave no canto
              Colors.white,                               // Início do branco puro
              Colors.white,                               // Fim do branco puro (dobro do tamanho)
              ColorPalete.defaultColor2.withOpacity(0.1), // Cor bem suave no outro canto
            ],
            // Ajustando os stops para o branco ocupar o centro de forma larga (de 0.3 a 0.7)
            // mas com 30% de distância para as pontas para garantir o desfoque longo
            stops: const [0.0, 0.3, 0.7, 1.0],
            // Ajuste estes valores para controlar a largura:
            // 0.2 e 0.8 deixam o branco bem largo no meio.
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(right: 5.w,left: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8,top: 10.h),
                child: Text("Email"),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: TextField(
                  controller: _editEmail,
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
                child: Text("Palavra-passe"),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: TextField(
                  obscureText: showPassword,
                  controller: _editPassword,
                  decoration: InputDecoration(
                    labelText: "Inserir palavra-passe",
                    labelStyle: TextStyle(fontWeight: FontWeight.w100, fontSize: 13, color: Colors.grey),
                    suffixIcon: GestureDetector(
                      onTap: (){

                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      child: showPassword? Icon(Icons.remove_red_eye): Icon(Icons.panorama_fish_eye),
                    ),
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
                child: Text("Confirmar Palavra-passe"),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: TextField(
                  obscureText: showConfirmPassword,
                  controller: _editConfirmPassword,
                  decoration: InputDecoration(
                    labelText: "Inserir novamente palavra-passe",
                    labelStyle: TextStyle(fontWeight: FontWeight.w100, fontSize: 13, color: Colors.grey),
                    suffixIcon: GestureDetector(
                      onTap: (){

                        setState(() {
                          showConfirmPassword = !showConfirmPassword;
                        });
                      },
                      child: showConfirmPassword? Icon(Icons.remove_red_eye): Icon(Icons.panorama_fish_eye),
                    ),
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

                      if(_editEmail.text.isNotEmpty &&_editConfirmPassword.text.isNotEmpty && _editPassword.text.isNotEmpty && _editPassword.text == _editConfirmPassword.text){

                        var request = await http.get(Uri.parse(HttpConstants.url+"resetPassword.php?email=${_editEmail.text}&pass=${_editPassword.text}&Confirmpass=${_editConfirmPassword.text}"),
                            headers: {
                              "Content-type": "application/json", "Accept": "application/json"
                            });

                        var convert = jsonDecode(request.body);

                        print("all decode: "+convert.toString());

                        if(convert["res"]=="success"){

                          List<CarouselModel> listCarousel = [];
                          for(var item in convert["buildapp"]["carousel"]){
                            listCarousel.add(CarouselModel.FromJson(item));
                          }


                          List<EventModel> listEvents = [];
                          for(var item in convert["buildapp"]["events"]){
                            listEvents.add(EventModel.FromJson(item));
                          }

                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage(
                              convert["name"],
                              convert["id"],
                              convert["peso"],
                              listCarousel,
                              convert["buildapp"]["daily"]["title"]+"|"+convert["buildapp"]["daily"]["description"],
                              listEvents
                          )));

                        }else{

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(convert["sms"])));

                        }

                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Por favor preenche tudo !")));
                      }






                    }, child: Text("Entrar",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100),),
                  )),


              Container(
                width: 90.w,
                margin: EdgeInsets.only(top: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ao utilizares a Victus, aceitas os nossos"),
                    Text("Termos e Política de Privacidade", style: TextStyle(fontWeight: FontWeight.bold),)

                  ],
                ),
              )




            ],
          ),
        ),
      ),
    );
  }
}