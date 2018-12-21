#!/usr/bin/php
<?php
//
// https://diego.com.es/lectura-de-archivos-en-php
//

if ($argc < 2 ) {
    exit( "Usage: ".$argv[0]." <kiuwanMutua.log.aaa-mm-dd>".PHP_EOL );
}
$sufijo=$argv[1];
$file="/cygdrive/c/PAC_Backups/kiuwan_logs/kiuwanMutua.log.".$sufijo;


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

$arr86400=array();
for ($i = 1; $i <= 86400; $i++) { $arr86400[$i]=0; }

$minSS=999999999999;
$maxSS=0;
foreach($arr as $k => $v) {
    $datetime1 = DateTime::createFromFormat('YmdHis', $v["Ini"]);
    $datetime2 = DateTime::createFromFormat('YmdHis', $v["Fin"]);
    $interval = date_diff($datetime1, $datetime2);
    // echo "[ ".$k." ] - ".$v["Shell"]." - ".$v["Ini"]." - ".$v["Fin"]." - ".$interval->format("%H:%I:%S").PHP_EOL;
    // echo $k.",".$v["Shell"].",".$v["Ini"].",".$v["Fin"].",".$interval->format("%H:%I:%S").PHP_EOL;
    $strIntervalo=$interval->format("%H%I%S");
    $hh=intval(substr($strIntervalo,0,2));
    $mm=intval(substr($strIntervalo,2,2));
    $ss=($hh*3600)+($mm*60)+intval(substr($strIntervalo,4,2))+1;
    $ptoInicial=$v["Ini"];
    $ptoHH=intval(substr($ptoInicial,8,2));
    $ptoMM=intval(substr($ptoInicial,10,2));
    $ptoSS=($ptoHH*3600)+($ptoMM*60)+intval(substr($ptoInicial,12,2));
    echo $k.",".$v["Shell"].",".$v["Ini"].",".$v["Fin"].",".$interval->format("%H:%I:%S").",".$ptoSS.",".$ss.PHP_EOL;
    if ( $ss < $minSS ) { $minSS=$ss; }
    if ( $ss > $maxSS ) { $maxSS=$ss; }
    for ($i = $ptoSS; $i <= ($ptoSS+$ss); $i++) { $arr86400[$i]++; }
}

//echo "Minimo tiempo de Ejecucion: [".$minSS."]".PHP_EOL;
//echo "Maximo tiempo de Ejecucion: [".$maxSS."]".PHP_EOL;

//for ($i = 1; $i <= 86400; $i++) { 
//    $hh=intval($i/3600);
//    $resto=$i-($hh*3600);
//    $mm=intval($resto/60);
//    $ss=$resto-($mm*60);
//    $hhStr=str_pad($hh, 2, '0', STR_PAD_LEFT);
//    $mmStr=str_pad($mm, 2, '0', STR_PAD_LEFT);
//    $ssStr=str_pad($ss, 2, '0', STR_PAD_LEFT);
//    echo $hhStr.":".$mmStr.":".$ssStr."#".$arr86400[$i].PHP_EOL;
//}


?>