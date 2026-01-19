<?php

require_once "../validateHeaderRequest.php";

try {


  // 1. Lê o corpo da requisição (string JSON)
  $json = file_get_contents("php://input");

  // 2. Decodifica para um array associativo do PHP
  $_PUT = json_decode($json, true);



  if (!empty($_PUT["idLibraryUser"]) && !empty($_PUT["number"])) {

    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root", "");

    $sql = "UPDATE libraryuser SET idlibseccontent =:PROG WHERE id = :ID ";
    // Prepare statement
    $stmt = $connect->prepare($sql);

    $stmt->bindParam(":PROG", $_PUT["number"]);
    $stmt->bindParam(":ID", $_PUT["idLibraryUser"]);
    // execute the query
    $stmt->execute();

    echo json_encode(array("res" => "success", "sms" => "Bom trabalho !"));



  } else {
    echo json_encode(array("res" => "error", "sms" => "Falta algum parametro !"));
  }

} catch (Exception $erro) {
  echo json_encode(array("res" => "error", "sms" => "Erro no try catch", "more" => $erro->getMessage()));



}

?>