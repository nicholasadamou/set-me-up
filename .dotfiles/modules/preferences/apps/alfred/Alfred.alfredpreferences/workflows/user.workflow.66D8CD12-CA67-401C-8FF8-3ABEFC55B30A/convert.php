<?php

if ( ! file_exists( $path = $argv[1] ) ) {
	print "Error: {$path} does not exist.\n";
	exit(1);
}
$data = file_get_contents( $path );
$type = exec("file --mime '" . $argv[1] . "' | awk '{print $2}' ");
$base64 = "data:{$type}base64," . base64_encode($data);
print $base64;