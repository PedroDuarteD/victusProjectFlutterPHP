<?php

try{
header('Content-Type: application/json');



$jsonBruto = file_get_contents('php://input');

$dados = json_decode($jsonBruto, true);

 $email = filter_var($dados['edit_email'], FILTER_SANITIZE_EMAIL);
$name = filter_var($dados['edit_name'], FILTER_SANITIZE_SPECIAL_CHARS);
$pass = filter_var($dados['edit_pass'], FILTER_SANITIZE_SPECIAL_CHARS);
$passC =  filter_var($dados['edit_Cpass'], FILTER_SANITIZE_SPECIAL_CHARS);
if(
  !empty($email) && !empty($name) && !empty($pass) && !empty($passC)
    
    ){




$id = null;

    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root","");

    if($pass == $passC){
      $addUser = $connect->prepare("INSERT INTO users (id, name, email, pass) VALUES (:ID, :NAME, :EMAIL, :PASS)");
  $addUser->bindParam(':ID', $id);
  $addUser->bindParam(':NAME', $name);
  $addUser->bindParam(':EMAIL', $email);
  $addUser->bindParam(':PASS', $pass);

  if($addUser->execute()){


    echo json_encode(array(
        "res" => "success",
        "buildapp" => array(
          "carousel" => [],
          "daily" => array(
            "title" => "",
            "description" => ""
          ),
          "events" => []
        ),
        "id" =>  (int)$connect->lastInsertId()
    ));
  }else{
    echo json_encode(array(
        "res" => "error",
    ));
  }
    }else{
         echo json_encode(array(
        "res" => "error",
        "sms"=> "Passwords não são iguais !"
    ),JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    }

    


}else{
echo json_encode(array("res"=>"error","sms"=>"Falta algum parametro !"));
}

}catch(Exception $erro){

echo "erro no try".$erro->getMessage();


}
?>