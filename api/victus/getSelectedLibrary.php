<?php

try{

if(
    isset($_GET["idLibrary"])  && !empty($_GET["idLibrary"]) &&
    isset($_GET["idUser"])  && !empty($_GET["idUser"]) 
    ){



$myidLibrary = filter_input(INPUT_GET, "idLibrary");
$myidUser = filter_input(INPUT_GET, "idUser");



    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root","");





     $gelURLVideoquery = $connect->query("select * from library where id = $myidLibrary ;");

      $urlVideo = "";
   
   while($rows = $gelURLVideoquery->fetch()){
    $urlVideo = $rows["video"];
   }



    
 $queryActions = $connect->query("select * from libraryuseractions where mylibrary = $myidLibrary and myuser = $myidUser ;");



 
      $idRowGosto = -1;
      $idRowStar = -1;
      $idRowDone = -1;


      while( $row = $queryActions->fetch()){
        if($row["gosto"]=="0" || $row["gosto"]=="1"){
            $idRowGosto = $row["id"];
        }

        if($row["star"]=="0" || $row["star"]=="1"){
            $idRowStar = $row["id"];
        }

        if($row["done"]=="0" || $row["done"]=="1"){
            $idRowDone = $row["id"];
        }
      }



     
 $query = $connect->query("select * from librarysection where idlibrary = $myidLibrary ;");

   $sectionArray  = array();


    
   
   while($rows = $query->fetch()){

   $contentArray  = array();

    $queryContent = $connect->query("select * from librarysection_conteudo where idlibrarysection = ".$rows["id"]." ;");

    

    while($contentRow = $queryContent->fetch()){
        array_push($contentArray, array("id"=> $contentRow["id"], "title"=> $contentRow["title"]));
    }


        array_push($sectionArray, array(
            "title" => $rows["title"],
            "content" => $contentArray

        ));
   }







    

    echo json_encode(array(
        "res" => "success",
        "idRowGosto" => $idRowGosto,
        "idRowStar" => $idRowStar,
        "idRowDone" => $idRowDone,
        "idlibrary" => $myidLibrary,
        "sections" => $sectionArray,
        "videoURL" => $urlVideo,
    ),JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);



  

}else{
echo json_encode(array("res"=>"error","sms"=>"Falta algum parametro !"));
}

}catch(Exception $erro){

echo "erro no try".$erro->getMessage();


}
?>