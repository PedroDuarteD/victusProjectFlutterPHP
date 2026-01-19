import 'package:appvictus/AddLibraryPage.dart';
import 'package:appvictus/ProfilePage.dart';
import 'package:appvictus/colors/ColorPalete.dart';
import 'package:appvictus/LibraryPage.dart';
import 'package:appvictus/model/CarouselModel.dart';
import 'package:appvictus/model/EventModel.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {

  String name = "";
  int userID = -1, calorias=0;
  String dailyMessage = "";
  List<CarouselModel> carouselHome  = [];
  List<EventModel> events  = [];

  HomePage(this.name, this.userID, this.calorias, this.carouselHome, this.dailyMessage, this.events);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPosition = 0;

  PageController pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(currentPosition == 0? "Olá ${widget.name}" : currentPosition==1? "Biblioteca" : "Perfil",style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.group)),
          IconButton(onPressed: (){}, icon: Icon(Icons.add_alert)),
          IconButton(onPressed: (){}, icon: Icon(Icons.sms)),
        ],
        leading: GestureDetector(
          onTap: (){
            if(currentPosition!=0){
              setState(() {
                currentPosition = 0;
              });
            }else if(currentPosition==0){
              Navigator.pop(context);
            }
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: currentPosition == 0? Container(
          margin: EdgeInsets.only(right: 5.w,left: 5.w),
          child: Column(
            children: [



              Stack(
                children: [
                  SizedBox(
                    height: 180,
                    child: PageView.builder(
                      itemCount: widget.carouselHome.length,
                      itemBuilder: (_, position){

                        CarouselModel carousel = widget.carouselHome.elementAt(position);

                        return Container(
                          decoration: BoxDecoration(
                              color: ColorPalete.defaultColor.withOpacity(.3),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          padding: EdgeInsets.only(left: 15,top: 15,right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  SizedBox(height: 30,),
                                  Text(carousel.title,style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 8,),
                                  Text(carousel.description,style: TextStyle(fontSize: 10)),
                                  SizedBox(height: 40,),
                                  GestureDetector(
                                    onTap: (){

                                    },
                                    child: Container(
                                      color: Colors.black,
                                      width: 65,
                                      height: 15,
                                      child: Center(child: Text(carousel.actionTitle,style: TextStyle(color: Colors.white, fontSize: 9),)),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 25),
                                width: 38.w,
                                height: 150,
                                child: Image.network(carousel.url),
                              )
                            ],
                          ),
                        );
                      },
                      controller: pageController,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 17.h),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SmoothPageIndicator(
                          controller: pageController,  // PageController
                          count:  widget.carouselHome.length,
                          effect:  WormEffect(
                            dotWidth: 8,
                            dotHeight: 8,
                            dotColor: Colors.white,
                            activeDotColor: ColorPalete.defaultColor
                          ),  // your preferred effect
                          onDotClicked: (index){
                          }
                      ),
                    ),
                  ),
                ],
              ),


            widget.dailyMessage.replaceAll("|", "").contains("|") ?  Container(
                padding: EdgeInsets.only(top: 1.h,bottom: 3.h),
                margin: EdgeInsets.only(bottom: 2.h, top: 2.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        begin: AlignmentGeometry.topLeft,
                        end: AlignmentGeometry.bottomRight,
                        colors: [ColorPalete.defaultColor, ColorPalete.defaultColor2, ColorPalete.defaultColor])
                ),
                child: Container(
                  padding: EdgeInsets.only(right: 5.w,left: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Text(this.widget.dailyMessage.split("|").elementAt(0).toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(this.widget.dailyMessage.split("|").elementAt(1),style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19, ),textAlign: TextAlign.center,)
                    ],
                  ),
                ),
              ) : Container(),



              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                 widget.calorias!=0? Container(
                      width: 44.w,
                      height: 150,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: ColorPalete.defaultColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child:   CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 10.0,
                        percent: widget.calorias/10,
                        circularStrokeCap: CircularStrokeCap.butt,
                        backgroundColor: Colors.white,
                        progressColor: ColorPalete.colorOrange,
                        center: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Text(this.widget.calorias.toString()+"kg",style: TextStyle(fontWeight: FontWeight.w600),),
                            new Text("perdidos",style: TextStyle(fontWeight: FontWeight.w600),),
                          ],
                        ),
                        progressBorderColor: Colors.white ,
                      )) : Container(),
                widget.events.isEmpty? Container():  Container(
                    width: 44.w,
                    height: 150,
                    decoration: BoxDecoration(
                        color: ColorPalete.defaultColor.withOpacity(.4),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Text("Próximos eventos.",style: TextStyle(color: Colors.black),),
                        SizedBox(height: 5,),
                        SizedBox(
                            width: 43.w,
                            height: 110,
                            child: ListView.builder(
                                itemBuilder: (_, position){

                                  EventModel event = widget.events.elementAt(position);

                                  if(position<2){
                                    return Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,

                                      ),
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: "${event.inicio}",
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13)
                                          ),
                                          TextSpan(
                                              text:  " | ${event.title}",
                                              style: TextStyle(color: Colors.black, fontSize: 13)

                                          )
                                        ]),
                                      ),
                                    );
                                  }else{
                                    return Container(
                                      padding: EdgeInsets.only(right: 3,left: 10,top: 3,bottom: 3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,

                                      ),
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Text("+ ${widget.events.length-2} evento",style: TextStyle(fontSize: 15),),
                                    );
                                  }


                                },
                                itemCount: widget.events.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(left: 15, right: 15)))
                      ],
                    ),
                  )
                ],
              ),
            ],
          )
      ) : currentPosition==1? LibraryPage(widget.userID) : ProfilePage(widget.userID),
      floatingActionButton: currentPosition==1 ? FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => AddLibraryPage()));
      }, child: Icon(Icons.add),foregroundColor: Colors.white,backgroundColor: ColorPalete.defaultColor,) : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: ColorPalete.defaultColor,
        currentIndex: currentPosition,
          onTap: (position){
          setState(() {
            currentPosition = position;
          });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.my_library_music,), label: "Biblioteca"),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle,), label: "Perfil"),
      ]),
    );
  }
}
