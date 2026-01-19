<?php

require_once "validateHeaderRequest.php";

try {


  // 1. Lê o corpo da requisição (string JSON)
  $json = file_get_contents("php://input");

  // 2. Decodifica para um array associativo do PHP
  $_PUT = json_decode($json, true);



  if (!empty($_PUT["idUser"]) && !empty($_PUT["number"])) {

    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root", "");


    $verifyPesoquery = $connect->query("select peso from users where id = " . $_PUT["idUser"]);
    $verifyPeso = $verifyPesoquery->fetch();

    $sql = "UPDATE users SET peso =:PROG WHERE id = :ID ";
    // Prepare statement
    $stmt = $connect->prepare($sql);

    $stmt->bindParam(":PROG", $_PUT["number"]);
    $stmt->bindParam(":ID", $_PUT["idUser"]);
    // execute the query
    if ($stmt->execute()) {

      if ($verifyPeso["peso"] < $_PUT["number"]) {
        echo json_encode(array("res" => "success", "sms" => "Muitos Parabéns !"), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

      } else {
        echo json_encode(array("res" => "success", "sms" => "Agora não foi tão bom. :)"), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

      }

    } else {
      echo json_encode(array("res" => "error", "sms" => "algo deu errado no update !"));
    }


  } else {
    echo json_encode(array("res" => "error", "sms" => "Falta algum parametro !"));
  }

} catch (Exception $erro) {
  echo json_encode(array("res" => "error", "sms" => "Erro no try catch", "more" => $erro->getMessage()));



}

?>