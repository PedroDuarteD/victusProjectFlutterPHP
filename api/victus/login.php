<?php


require_once "validateHeaderRequest.php";



try {


  $jsonBruto = file_get_contents('php://input');

  $dados = json_decode($jsonBruto, true);

  $email = filter_var($dados['email'], FILTER_SANITIZE_EMAIL);
  $editPass = filter_var($dados['pass'], FILTER_SANITIZE_SPECIAL_CHARS);


  if (!empty($email) && !empty($editPass)) {






    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root", "");

    $query = $connect->query("select * from users where email = '$email';");


    $userData = $query->fetch();


    if (password_verify($editPass, $userData["pass"])) {

      //get carousel
      $carouselArray = array();

      $carouselData = $connect->query("select * from carousel_home;");

      while ($row = $carouselData->fetch()) {
        array_push($carouselArray, array(
          "title" => $row["title"],
          "description" => $row["description"],
          "actionTitle" => $row["actionTitle"],
          "image" => $row["urlImage"],
        ));
      }

      //Daily

      $dailyTitle = "";
      $dailyMessage = "";
      $dailyData = $connect->query("select * from dailymessage where myuser = " . $userData["id"] . " limit 1;");

      while ($row = $dailyData->fetch()) {
        $dailyTitle = $row["title"];
        $dailyMessage = $row["description"];
      }


      //show Events

      $allEventsArray = array();
      $getEventsData = $connect->query("select * from myevents where myuser = " . $userData["id"] . ";");

      while ($row = $getEventsData->fetch()) {

        array_push($allEventsArray, array(
          "title" => $row["title"],
          "inicio" => $row["inicio"]
        ));
      }




      echo json_encode(array(
        "res" => "success",
        "id" => $userData["id"],
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
      ), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);



    } else {
      echo json_encode(array("res" => "error", "sms" => "Password está errada !"), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    }


  } else {
    echo json_encode(array("res" => "error", "sms" => "Falta algum parametro !"));
  }

} catch (Exception $erro) {
  echo json_encode(array("res" => "error", "sms" => "Falta algum parametro !", "more" => $erro->getMessage()));



}


?>