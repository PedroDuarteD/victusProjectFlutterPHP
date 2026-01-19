<?php

require_once "validateHeaderRequest.php";



try {

    if (isset($_GET["id"]) && !empty($_GET["id"])) {



        $myid = filter_input(INPUT_GET, "id");


        $connect = new PDO("mysql:host=localhost;dbname=victus_db", "root", "");

        $query = $connect->query("select * from library inner join libraryuser on library.id=libraryuser.idlibrary where iduser = $myid ;");



        $myLibrary = array();
        while ($rows = $query->fetch()) {


            //need to get all content

            $amount = 0;

            $getallContentQuery = $connect->query(
                "select librarysection_conteudo.id from libraryuser inner join librarysection on  librarysection.idlibrary =  libraryuser.idlibrary  inner join librarysection_conteudo 
on librarysection_conteudo.idlibrarysection = librarysection.id where iduser = $myid and libraryuser.idlibrary = " . $rows["id"] . " order by librarysection_conteudo.idlibrarysection;"
            );

            $countDone = 0;
            $max = 0;

            $continueAdding = true;
            while ($row = $getallContentQuery->fetch()) {

                if ($continueAdding) {
                    if ($row["id"] == $rows["idlibseccontent"]) {
                        $continueAdding = false;
                    }
                    $countDone += 1;
                }


                $max += 1;
            }

            $percent = ($countDone * 100) / $max;

            array_push($myLibrary, array(
                "id" => $rows["id"],
                "title" => $rows["title"],
                "description" => $rows["description"],
                "url" => $rows["url"],
                "progress" => (int) $percent,
            ));
        }

        echo json_encode(array(
            "res" => "success",
            "library" => $myLibrary
        ));

    } else {
        echo json_encode(array("res" => "error", "sms" => "Falta algum parametro !"));
    }

} catch (Exception $erro) {

    echo "erro no try" . $erro->getMessage();


}

?>