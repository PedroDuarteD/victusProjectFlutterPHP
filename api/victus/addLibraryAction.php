<?php

try{

if(
    isset($_GET["idLibrary"])  && !empty($_GET["idLibrary"]) &&
    isset($_GET["idUser"])  && !empty($_GET["idUser"])  &&
    isset($_GET["parametro"])  && !empty($_GET["parametro"])  &&
    isset($_GET["valor"])  && !empty($_GET["valor"])  
    
    ){


$myidLibrary = filter_input(INPUT_GET, "idLibrary");
$myidUser = filter_input(INPUT_GET, "idUser");
$parametro = filter_input(INPUT_GET, "parametro");
$valor = filter_input(INPUT_GET, "valor");








    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root","");
//verify if already exists

$query = $connect->query("select * from libraryuseractions where mylibrary = $myidLibrary and myuser = $myidUser;");


$breakAdd = false;
while ( $row = $query->fetch()){
    if($parametro==1 && $row["gosto"]==$valor){

    $breakAdd = true;
    }else if($parametro==2 && $row["star"]==$valor){
    $breakAdd = true;

    }else if($parametro==3 && $row["done"]==$valor){
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
        "res" => "success"
    ));
    }else{
         echo json_encode(array(
        "res" => "erro",
        "sms"=> "Não foi possivel adicionar"
    ));
    }
}

    
 


   
  }else{
echo json_encode(array("res"=>"error","sms"=>"Falta algum parametro !"));
}

}catch(Exception $erro){

echo "erro no try".$erro->getMessage();


}
?>