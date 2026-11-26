<?php

function array_flatten($array,$return) {
	foreach($array as $value) {
		if(is_array($value)) {
			$return = array_flatten($value, $return);
		}
		else {
			if(isset($value)) {
				$return[] = $value;
			}
		}
	}
	return $return;
    }

 function flatten($input) {

   $result = array_flatten($input, array());
    return $result;
}
