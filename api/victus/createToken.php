<?php

require_once __DIR__ . '/vendor/autoload.php';
use Firebase\JWT\JWT;

$headers = getallheaders();

$emailHeader = "";
$passHeader = "";
foreach ($headers as $nome => $valor) {


    if ($nome == "email" && $valor == "pedro@gmail.com") {
        $emailHeader = $valor;
    }

    if ($nome == "pass" && $valor == "sdf2zeroe###2FF") {
        $passHeader = $valor;
    }

}


if (!empty($emailHeader) && !empty($passHeader)) {





    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
    $dotenv->load();



    $jsonBruto = file_get_contents('php://input');

    $dados = json_decode($jsonBruto, true);

    $payload = [
        "iss" => "http://localhost",
        "aud" => "http://localhost",
        "exp" => time() + 1000,
        "iat" => time(),
    ];



    $encode = JWT::encode($payload, $_ENV["KEY"], "HS256");

    echo json_encode(array(
        "res" => "success",
        "token" => $encode
    ));

} else {
    echo json_encode(array(
        "res" => "error",
    ));

}

?>