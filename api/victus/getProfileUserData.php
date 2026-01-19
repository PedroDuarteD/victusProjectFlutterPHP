<?php

require_once "validateHeaderRequest.php";

try {


    if (isset($_GET["idUser"]) && !empty($_GET["idUser"])) {

        $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root", "");


        $verifyPesoquery = $connect->query("select * from users where id = " . $_GET["idUser"]);
        $verifyPeso = $verifyPesoquery->fetch();

        echo json_encode(array(
            "res" => "success",
            "name" => $verifyPeso["name"],
            "email" => $verifyPeso["email"],
            "peso" => (int) $verifyPeso["peso"],
        ), JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);


    } else {
        echo json_encode(array("res" => "error", "sms" => "Falta algum parametro !"));
    }

} catch (Exception $erro) {
    echo json_encode(array("res" => "error", "sms" => "Erro no try catch", "more" => $erro->getMessage()));



}

?>