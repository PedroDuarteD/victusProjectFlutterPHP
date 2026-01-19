<?php
require_once "../validateHeaderRequest.php";

try {


    // Lê o conteúdo bruto
    $json = file_get_contents('php://input');

    // Decodifica para um array associativo
    $dados = json_decode($json, true);

    if (!empty($dados["idRow"])) {


        $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root", "");

        $sql = "DELETE FROM libraryuseractions WHERE id= " . $dados["idRow"];

        $connect->exec($sql);

        echo json_encode(array(
            "res" => "success",
            "sms" => "Update realizado com sucesso !"
        ));


    } else {
        echo json_encode(array("res" => "error", "sms" => "Falta algum parametro !"));
    }

} catch (Exception $erro) {

    echo "erro no try" . $erro->getMessage();


}
?>