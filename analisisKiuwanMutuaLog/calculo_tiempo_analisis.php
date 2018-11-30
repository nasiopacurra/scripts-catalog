#!/usr/bin/php
<?php
//
// https://diego.com.es/lectura-de-archivos-en-php
//

if ($argc < 2 ) {
    exit( "Usage: ".$argv[0]." <kiuwanMutua.log.aaa-mm-dd>".PHP_EOL );
}
$sufijo=$argv[1];
$file="kiuwanMutua.log.".$sufijo;

$arr=array();
if (file_exists($file)) {
    $cnt=0;
    $fp = fopen($file, "r");
    while (!feof($fp)){
        $cnt++;
        $linea = fgets($fp);

        $pos=strpos($linea,"]");
        $clave=substr($linea,0,$pos+1);
        $texto=substr($linea,$pos+1,strlen($linea)-$pos-2);

        //echo $clave." - ".$texto.PHP_EOL;

        $arrLine=explode(" ",$clave);
        if ($arrLine[0] == "[") {

            $pid=$arrLine[1];
            $shell=$arrLine[2];
            $shell=str_replace("/mma/datos/scripts/","",$shell);
            $time=$arrLine[3];

            // echo $pid."-".$shell."-".$time." [".$texto."]".PHP_EOL;

            if (array_key_exists($pid,$arr)) {
                $arr[$pid]["Fin"]=$time;
            } else {
                $arr[$pid]=array("Shell" => $shell, "Ini" => $time, "Fin" => 0);
            }
        
        }

        //echo $linea;
//        if ( $cnt > 20 ) { break; }
    }
    fclose($fp);
} else {
    echo "El fichero $file no existe";
}

foreach($arr as $k => $v) {
    $datetime1 = DateTime::createFromFormat('YmdHis', $v["Ini"]);
    $datetime2 = DateTime::createFromFormat('YmdHis', $v["Fin"]);
    $interval = date_diff($datetime1, $datetime2);
    //echo "[ ".$k." ] - ".$v["Shell"]." - ".$v["Ini"]." - ".$v["Fin"]." - ".$interval->format("%H:%I:%S").PHP_EOL;
    echo $k.",".$v["Shell"].",".$v["Ini"].",".$v["Fin"].",".$interval->format("%H:%I:%S").PHP_EOL;
}

?>