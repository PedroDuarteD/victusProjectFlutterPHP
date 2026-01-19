<?php



require_once "validateHeaderRequest.php";


try {
  header('Content-Type: application/json');



  $jsonBruto = file_get_contents('php://input');

  $dados = json_decode($jsonBruto, true);

  $email = filter_var($dados['edit_email'], FILTER_SANITIZE_EMAIL);
  $name = filter_var($dados['edit_name'], FILTER_SANITIZE_SPECIAL_CHARS);
  $pass = filter_var($dados['edit_pass'], FILTER_SANITIZE_SPECIAL_CHARS);
  $passC = filter_var($dados['edit_Cpass'], FILTER_SANITIZE_SPECIAL_CHARS);
  if (
    !empty($email) && !empty($name) && !empty($pass) && !empty($passC)

  ) {




    $id = null;

    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root", "");

    if ($pass == $passC) {
      $addUser = $connect->prepare("INSERT INTO users (id, name, email, pass) VALUES (:ID, :NAME, :EMAIL, :PASS)");
      $addUser->bindParam(':ID', $id);
      $addUser->bindParam(':NAME', $name);
      $addUser->bindParam(':EMAIL', $email);


      $options = [
        // Increase the bcrypt cost from 12 to 13.
        'cost' => 13,
      ];

      $encrypt = password_hash($pass, PASSWORD_BCRYPT, $options);

      $addUser->bindParam(':PASS', $encrypt);


      if ($addUser->execute()) {


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


        echo json_encode(array(
          "res" => "success",
          "buildapp" => array(
            "carousel" => $carouselArray,
            "daily" => array(
              "title" => "",
              "description" => ""
            ),
            "events" => []
          ),
          "id" => (int) $connect->lastInsertId()
        ));
      } else {
        echo json_encode(array(
          "res" => "error",
        ));
      }
    } else {
      echo json_encode(array(
        "res" => "error",
        "sms" => "Passwords não são iguais !"
      ), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    }




  } else {
    echo json_encode(array("res" => "error", "sms" => "Falta algum parametro !"));
  }

} catch (Exception $erro) {

  echo "erro no try" . $erro->getMessage();


}



?>