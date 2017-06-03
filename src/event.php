<?php
/**
 * This file write
 */

function convert_multi_array($array) {
    $out = $_SERVER['QUERY_STRING']; // extract($_REQUEST); ; //implode("&",array_map(function($a) {return implode("~",$a);},$array));
    print_r($out);
    return $out;
}

function updateFile($dest, $content) {
    $fh = fopen($dest, 'w');
    print_r(error_get_last()); // debug info
    fwrite($fh, $content);
    fclose($fh);
}


$name = $_GET['name'];
if(preg_match('/^[A-Za-z0-9\-_.]+$/', $name)>0) {
    updateFile('/share/event',
        "EVENT_NAME:\n"
        . $name
        ."\n\nEVENT_TIMESTAMP:\n"
        . time()
        . "\n\nEVENT_PARAMETERS: \n"
        . $_SERVER['QUERY_STRING']
        . "\n\nEVENT_BODY: \n"
        . file_get_contents('php://input'));
    echo 'ok';

}



