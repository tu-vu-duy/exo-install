<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
					 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
	<head id="head">
		<title>Add db</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="slider.css"/>
		<script type="text/javascript" src="photo.js"></script>
  </head>
<body id="body">
<form id="submit_form" action="test.php" method="post">
  <div>
    <input type="hidden" name="url" id="url" value=""/>
    <input type="text" name="link" id="link" size="41" title="Nhap duong dan" value=""/>
    <input type="submit" onclick="FS.submit()" id="submit" title="Lay link anh" value="Lay link anh"/>
  </div>
</form>
<?php
function getContent($url_) {
  $body_ = "";
  if($url_ && strlen($url_) > 0) {
    if(strrpos( $url_, 'http') === false) {
       $url_ = 'http://'.$url_;
    }
    try {
      $body_             = file_get_contents($url_);
      $body_             = preg_replace('/<body.*>/','', $body_); 
      $body_             = preg_replace('/<\/body>/','', $body_); 
      $body_             = preg_replace('/<html.*>/','', $body_); 
      $body_             = preg_replace('/<\/html>/','', $body_);
     // $body_             = preg_replace('/<script.*\/script>/','', $body_);  
     // $body_             = preg_replace('/<script.*>/','', $body_);  
    } catch (Exception $e) {
    //	echo $e->errorMessage();
    }
  }
  return $body_;
}
  $url = "";
  if(array_key_exists('link',  $_POST)) {
    $url = $_POST['link'];
  }

  if(strlen($url) <= 0 && array_key_exists('url',  $_REQUEST)) {
    $url = $_REQUEST["url"];
  }

  $body = getContent($url);

?>

  <div id="Info"></div>
  <div id="DisplayInfo" style="padding: 15px;"></div>
  <div style="display:none"><?php echo $body; ?> </div>
  <script type="text/javascript">
    FS.local = '<?php echo $url; ?>';
    FS.init('Info');
  </script>
  <div id="ImageView" style="padding: 15px;"></div>
</body>
</html>
