<?php

try{

if(
    isset($_GET["id"])  && !empty($_GET["id"])&&
    isset($_GET["id"])  && !empty($_GET["id"])
    ){



$myid = filter_input(INPUT_GET, "id");


    $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root","");

   $query = $connect->query("select * from library where myuser = $myid ;");

   $myLibrary  = array();
   while($rows = $query->fetch()){
        array_push($myLibrary, array(
            "id" => $rows["id"],
            "title" => $rows["title"],
            "description" => $rows["description"],
            "url" => $rows["url"],
            "progress" => $rows["progress"],
        ));
   }

    echo json_encode(array(
        "res" => "success",
        "library" => $myLibrary
    ));

}else{
echo json_encode(array("res"=>"error","sms"=>"Falta algum parametro !"));
}

}catch(Exception $erro){

echo "erro no try".$erro->getMessage();


}
?>