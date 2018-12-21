#!/usr/bin/php
<?php
//
// https://diego.com.es/lectura-de-archivos-en-php
//

if ($argc < 2 ) {
    exit( "Usage: ".$argv[0]." <listado_plugins.txt>".PHP_EOL );
}
$file=$argv[1];

$arr=array();
if (file_exists($file)) {
    $cnt=0;
    $fp = fopen($file, "r");
    while (!feof($fp)){
        $cnt++;
        $linea = fgets($fp);

        $arrLine=explode(" - ",$linea);
        $padre=$arrLine[0];
        $arrDepencias=explode(",",str_replace("]","",str_replace("[","",$arrLine[1])));

        // echo $linea.PHP_EOL;
        // echo "Padre: [".$padre."]".PHP_EOL;
        foreach($arrDepencias as $k => $v) {
            $v=trim($v);
            // echo "Dependencia: [".$v."]".PHP_EOL;
            echo $padre."#".$v.PHP_EOL;
        }

        // if ( $cnt > 20 ) { break; }
    }
    fclose($fp);
} else {
    echo "El fichero $file no existe";
}

?>