<?php



require_once "validateHeaderRequest.php";




try {


  // 1. Lê o corpo da requisição (string JSON)
  $json = file_get_contents("php://input");

  // 2. Decodifica para um array associativo do PHP
  $_PUT = json_decode($json, true);



  if (
    isset($_PUT["email"]) && isset($_PUT["pass"]) && isset($_PUT["Confirmpass"])
  ) {



    $email = filter_var($_PUT["email"], FILTER_VALIDATE_EMAIL);

    $editPass = $_PUT["pass"];

    $editConfirmPass = $_PUT["Confirmpass"];


    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root", "");

    $query = $connect->query("select * from users where email = '$email';");


    $userData = $query->fetch();


    if ($editConfirmPass == $editPass) {

      if (!password_verify($editPass, $userData["pass"])) {

        $sql = "UPDATE users SET pass=:PASS WHERE id = :ID ";

        // Prepare statement
        $stmt = $connect->prepare($sql);

        $options = [
          // Increase the bcrypt cost from 12 to 13.
          'cost' => 13,
        ];

        $encryptPassword = password_hash($editPass, PASSWORD_BCRYPT, $options);

        $stmt->bindParam(":PASS", $encryptPassword);
        $stmt->bindParam(":ID", $userData["id"]);

        // execute the query
        $stmt->execute();








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

        $dailyData = $connect->query("select * from dailymessage where myuser = " . $userData["id"] . ";");

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
          "id" => (int) $userData["id"],
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
        echo json_encode(array("res" => "error", "sms" => "Password não podem ser iguais !"), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
      }
    } else {
      echo json_encode(array("res" => "error", "sms" => "Password não são iguais !"), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    }


  } else {
    echo json_encode(array("res" => "error", "sms" => "Falta algum parametro !"));
  }

} catch (Exception $erro) {
  echo json_encode(array("res" => "error", "sms" => "Erro no try catch", "more" => $erro->getMessage()));



}

?>