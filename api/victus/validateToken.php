<?php

require_once __DIR__ . '/vendor/autoload.php';
use Firebase\JWT\JWT;
use Firebase\JWT\Key;


$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

// A chave tem de ser EXATAMENTE a mesma que usou no createToken.php
$key = $_ENV["KEY"];

try {
    // Se a assinatura não bater ou o token estiver expirado, 
    // o PHP vai lançar uma exceção (erro).
    $decoded = JWT::decode(
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0IiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdCIsImV4cCI6MTc2ODU3NzY4MCwiaWF0IjoxNzY4NTc2NjgwLCJ1aWQiOiJvbGEiLCJlbWFpbCI6InBlZHJvb3RyYWJhbGhhZG9yQGdtYWlsLmNvbSJ9.hC73Pgii2QknAiXMvucVKDJDMykbeDH-OGF2ZNnbMWw"
        ,
        new Key($key, 'HS256')
    );

    // Se chegou aqui, a assinatura é VÁLIDA e os dados são REAIS
    echo "Acesso concedido para o ID: " . $decoded->uid;

} catch (Exception $e) {
    // Aqui apanhas o "Invalid Signature" ou "Expired Token"
    echo "Erro na validação: " . $e->getMessage();
}

?>