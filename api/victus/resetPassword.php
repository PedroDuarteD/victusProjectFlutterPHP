<?php

try{

if(
    isset($_GET["email"])  && !empty($_GET["email"])&&
    isset($_GET["pass"])  && !empty($_GET["pass"]) &&
    isset($_GET["pass"])  && !empty($_GET["Confirmpass"]) 
    ){



$email = filter_input(INPUT_GET, "email");
$editPass = filter_input(INPUT_GET, "pass");
$editConfirmPass = filter_input(INPUT_GET, "Confirmpass");


    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root","");

   $query = $connect->query("select name, id, peso, pass from users where email = '$email';");


   $userData = $query->fetch();


   if($editConfirmPass == $editPass){

    if($userData["pass"] != $editPass){

    $sql = "UPDATE users SET pass=:PASS WHERE id = :ID ";

  // Prepare statement
  $stmt = $connect->prepare($sql);
  $stmt->bindParam(":PASS",$editPass);
  $stmt->bindParam(":ID", $userData["id"]);

  // execute the query
  $stmt->execute();








//get carousel
   $carouselArray  = array();

   $carouselData = $connect->query("select * from carousel_home;");

   while ( $row = $carouselData->fetch()){
    array_push($carouselArray, array(
      "title" => $row["title"],
      "description" => $row["description"],
      "actionTitle" => $row["actionTitle"],
      "image" => $row["urlImage"],
      ));
   }

    //Daily

   $dailyTitle = "";

   $dailyData = $connect->query("select * from dailymessage where myuser = ".$userData["id"].";");

   while ( $row = $dailyData->fetch()){
     $dailyTitle = $row["title"];
     $dailyMessage = $row["description"];
   }


   //show Events

   $allEventsArray = array();
   $getEventsData = $connect->query("select * from myevents where myuser = ".$userData["id"].";");

   while ( $row = $getEventsData->fetch()){

   array_push($allEventsArray, array(
    "title" =>  $row["title"],
    "inicio" => $row["inicio"]
   ));
   }




    echo json_encode(array(
        "res" => "success",
        "id" =>  (int)$userData["id"],
        "name" => $userData["name"],
        "peso" => $userData["peso"],
        "buildapp" => array(
          "carousel" => $carouselArray,
          "daily" => array(
            "title" => $dailyTitle,
            "description" => $dailyMessage
          ),
          "events" => $allEventsArray
        )
    ),JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);


 }else{
    echo json_encode(array("res"=>"error", "sms"=> "Password não podem ser iguais !"),JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
   }
   }else{
    echo json_encode(array("res"=>"error", "sms"=> "Password não são iguais !"),JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
   }

   
}else{
echo json_encode(array("res"=>"error","sms"=>"Falta algum parametro !"));
}

}catch(Exception $erro){
echo json_encode(array("res"=>"error","sms"=>"Falta algum parametro !","more" => $erro->getMessage()));



}
?>