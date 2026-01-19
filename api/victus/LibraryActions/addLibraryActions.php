<?php
require_once "../validateHeaderRequest.php";

try {





  $jsonBruto = file_get_contents('php://input');

  $dados = json_decode($jsonBruto, true);

  $myidLibrary = filter_var($dados['idLibrary'], FILTER_SANITIZE_EMAIL);
  $myidUser = filter_var($dados['idUser'], FILTER_SANITIZE_SPECIAL_CHARS);
  $parametro = filter_var($dados['parametro'], FILTER_SANITIZE_SPECIAL_CHARS);

  if (
    !empty($myidLibrary) &&
    !empty($myidUser) &&
    !empty($parametro)

  ) {


    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root", "");


    //verify if already exists

    $query = $connect->query("select * from libraryuseractions where mylibrary = $myidLibrary and myuser = $myidUser;");


    $breakAdd = false;
    while ($row = $query->fetch()) {
      if ($parametro == 1 && $row["gosto"] == 1) {

        $breakAdd = true;
      } else if ($parametro == 2 && $row["star"] == 1) {
        $breakAdd = true;

      } else if ($parametro == 3 && $row["done"] == 1) {
        $breakAdd = true;

      }
    }


    if ($breakAdd) {
      echo json_encode(array(
        "res" => "error",
        "sms" => "Já existe não vai ser possivel adicionar !"
      ), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    } else {


      $addUser = $connect->prepare("INSERT INTO libraryuseractions (id, mylibrary, myuser, gosto, star, done) VALUES (
    :ID, :MYLIBRARY, :MYUSER, :GOSTO, :STAR, :DONE)");
      $addUser->bindParam(':ID', $id);
      $addUser->bindParam(':MYLIBRARY', $myidLibrary);
      $addUser->bindParam(':MYUSER', $myidUser);

      if ($parametro == 1) {
        $addUser->bindValue(':GOSTO', 1);
      } else {
        $addUser->bindValue(':GOSTO', null);
      }

      if ($parametro == 2) {
        $addUser->bindValue(':STAR', 1);
      } else {
        $addUser->bindValue(':STAR', null);
      }


      if ($parametro == 3) {
        $addUser->bindValue(':DONE', 1);
      } else {
        $addUser->bindValue(':DONE', null);
      }



      if ($addUser->execute()) {


        echo json_encode(array(
          "res" => "success",
          "idRow" => (int) $connect->lastInsertId(),
          "sms" => "Criado com Sucesso",
        ));
      } else {
        echo json_encode(array(
          "res" => "erro",
          "sms" => "Não foi possivel adicionar"
        ), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
      }
    }












  } else {
    echo json_encode(array("res" => "error", "sms" => "Falta algum parametro !"));
  }

} catch (Exception $erro) {

  echo "erro no try" . $erro->getMessage();


}
?>