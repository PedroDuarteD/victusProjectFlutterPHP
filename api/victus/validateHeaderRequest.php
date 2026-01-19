<?php


require_once __DIR__ . '/vendor/autoload.php';
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$headers = getallheaders();

if (isset($headers['authorization'])) {
    if (preg_match('/Bearer\s(\S+)/', $headers['authorization'], $matches)) {


        $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
        $dotenv->load();

        $key = $_ENV["KEY"];

        try {

            $decoded = JWT::decode($matches[1], new Key($key, 'HS256'));

        } catch (Exception $e) {

            http_response_code(400);
        }



    }
}


?>