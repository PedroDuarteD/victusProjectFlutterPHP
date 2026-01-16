import 'dart:convert';
import 'package:appvictus/ChangePasswordPage.dart';
import 'package:appvictus/NewUserPage.dart';
import 'package:appvictus/colors/ColorPalete.dart';
import 'package:appvictus/SelectedLibraryPage.dart';
import 'package:appvictus/homePage.dart';
import 'package:appvictus/http/constants.dart';
import 'package:appvictus/model/CarouselModel.dart';
import 'package:appvictus/model/EventModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import 'LibraryPage.dart';

void main() {
  return runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, o,l) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        );
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  TextEditingController _editEmail = new TextEditingController();
  TextEditingController _editPassword = new TextEditingController();

  bool showPassword = true;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Entra na tua conta",style: TextStyle(fontWeight: FontWeight.w600),),
        leading: GestureDetector(
          onTap: (){

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
                margin: EdgeInsets.only(bottom: 8,top: 25.h),
                child: Text("Email"),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: TextField(
                  controller: _editEmail,

                  decoration: InputDecoration(
                    labelText: "Inserir Email",
                    labelStyle: TextStyle(fontWeight: FontWeight.w100, fontSize: 13, color: Colors.grey),
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
                width: 90.w,
                height: 50,
                margin: EdgeInsets.only(bottom: 3.h),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(ColorPalete.defaultColor),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(14)))
                  ),
                  onPressed: ()async{



                    var request = await http.get(Uri.parse(HttpConstants.url+"login.php?email=${_editEmail.text}&pass=${_editPassword.text}"),
                    headers: {
                      "Content-type": "application/json", "Accept": "application/json"
                    });

                    print("all data: "+request.body);

                    var convert = jsonDecode(request.body);

                    if(convert["res"]=="success"){

                      List<CarouselModel> listCarousel = [];
                      for(var item in convert["buildapp"]["carousel"]){
                        listCarousel.add(CarouselModel.FromJson(item));
                      }


                      List<EventModel> listEvents = [];
                      for(var item in convert["buildapp"]["events"]){
                        listEvents.add(EventModel.FromJson(item));
                      }

                      Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage(
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


                }, child: Text("Entrar",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w100),),
              )),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Esqueceste-te da palavra-passe?"),
                  SizedBox(width: 5,),
                  GestureDetector(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (_) => ChangePasswordPage()));

                      },
                      child: Text("Recuperar", style: TextStyle(fontWeight: FontWeight.bold, color: ColorPalete.defaultColor),))

                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: ()async{


                    Navigator.push(context, MaterialPageRoute(builder: (_) => NewAccountPage()));


                  }, child: Text("Ainda não tenho !",style: TextStyle(color: Colors.black),)),
                ],
              ),





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
