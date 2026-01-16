<?php

try{

if(
    isset($_GET["idLibrary"])  && !empty($_GET["idLibrary"]) &&
    isset($_GET["idUser"])  && !empty($_GET["idUser"])  &&
    isset($_GET["parametro"])  && !empty($_GET["parametro"])  
    
    ){


$myidLibrary = filter_input(INPUT_GET, "idLibrary");
$myidUser = filter_input(INPUT_GET, "idUser");
$parametro = filter_input(INPUT_GET, "parametro");








    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root","");




    if(isset($_GET["idRow"]) && !empty($_GET["idRow"]) ){
$idRow = filter_input(INPUT_GET, "idRow");

  $nameParametro = "";
  if($parametro==1){
    $nameParametro = "gosto";
  }else if($parametro == 2){
    $nameParametro = "star";
  }else if($parametro == 3){
    $nameParametro = "done";
  }


$sql = "DELETE FROM libraryuseractions WHERE id= $idRow";

  // use exec() because no results are returned
  $connect->exec($sql);

  echo json_encode(array(
        "res" => "success",
        "sms"=> "Update realizado com sucesso !"
    ));

    }else{


//verify if already exists

$query = $connect->query("select * from libraryuseractions where mylibrary = $myidLibrary and myuser = $myidUser;");


$breakAdd = false;
while ( $row = $query->fetch()){
    if($parametro==1 && $row["gosto"]==1){

    $breakAdd = true;
    }else if($parametro==2 && $row["star"]==1){
    $breakAdd = true;

    }else if($parametro==3 && $row["done"]==1){
    $breakAdd = true;

    }
}


if($breakAdd){
echo json_encode(array(
        "res" => "error",
        "sms"=> "Já existe não vai ser possivel adicionar !"
    ));
}else{
     $addUser = $connect->prepare("INSERT INTO libraryuseractions (id, mylibrary, myuser, gosto, star, done) VALUES (
    :ID, :MYLIBRARY, :MYUSER, :GOSTO, :STAR, :DONE)");
  $addUser->bindParam(':ID', $id);
  $addUser->bindParam(':MYLIBRARY', $myidLibrary);
  $addUser->bindParam(':MYUSER', $myidUser);

  if($parametro==1){
  $addUser->bindValue(':GOSTO', 1 );
  }else{
  $addUser->bindValue(':GOSTO',  null);
  }

    if($parametro==2){
  $addUser->bindValue(':STAR', 1 );
  }else{
  $addUser->bindValue(':STAR',  null);
  }


    if($parametro==3){
  $addUser->bindValue(':DONE', 1);
  }else{
  $addUser->bindValue(':DONE',  null);
  }



  if($addUser->execute()){


    echo json_encode(array(
        "res" => "success",
        "idRow" => (int)$connect->lastInsertId(),
        "sms" => "Criado com Sucesso",
    ));
    }else{
         echo json_encode(array(
        "res" => "erro",
        "sms"=> "Não foi possivel adicionar"
    ));
    }
}

    
 


   
  }



  

}else{
echo json_encode(array("res"=>"error","sms"=>"Falta algum parametro !"));
}

}catch(Exception $erro){

echo "erro no try".$erro->getMessage();


}
?>