<?php



require_once "validateHeaderRequest.php";


try {
  header('Content-Type: application/json');



  $jsonBruto = file_get_contents('php://input');

  $dados = json_decode($jsonBruto, true);

  $title = filter_var($dados['title'], FILTER_SANITIZE_SPECIAL_CHARS);
  $desc = filter_var($dados['desc'], FILTER_SANITIZE_SPECIAL_CHARS);
  $url = filter_var($dados['url'], FILTER_SANITIZE_SPECIAL_CHARS);

  if (
    !empty($title) && !empty($desc) && !empty($url)

  ) {




    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root", "");

    $addUser = $connect->prepare("INSERT INTO library (id, title, description, url) VALUES (:ID, :TITLE, :DESCRIPTION, :URL)");
    $id = null;
    $addUser->bindParam(':ID', $id);
    $addUser->bindParam(':TITLE', $title);
    $addUser->bindParam(':DESCRIPTION', $desc);
    $addUser->bindParam(':URL', $url);

    if ($addUser->execute()) {


      echo json_encode(array(
        "res" => "success",
        "sms" => "Adicionado com sucesso !"
      ));
    } else {
      echo json_encode(array(
        "res" => "error",
        "sms" => "Não foi possível adicionar !"
      ));
    }




  } else {
    echo json_encode(array("res" => "error", "sms" => "Falta algum parametro !"));
  }

} catch (Exception $erro) {

  echo "erro no try" . $erro->getMessage();


}



?>