<?php
	// File Path to save file
	$file = 'uploads/recording.m4a';
	
	// Get the Request body
	$request_body = @file_get_contents('php://input');
	
	// Get some information on the file
	$file_info = new finfo(FILEINFO_MIME);
	
	// Extract the mime type
	$mime_type = $file_info->buffer($request_body);

	// Logic to deal with the type returned
	switch($mime_type) 
	{
    	case "audio/mp4; charset=binary":
        	
        	// Write the request body to file
			file_put_contents($file, $request_body);
			
			break;
			
		default:
			// Handle wrong file type here
	}
?>
