<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
					 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr" class="albums">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Slider tools.</title>
    <link rel="stylesheet" type="text/css" href="slider.css"/> 
  </head>
  <body class="albums">
<?php
// we connect to example.com and port 3307

$user = $_REQUEST['user'];
$album = $_REQUEST['album'];

if (strlen($user) > 0) {
  $nameab = $user;
  if(strlen($album) > 0 && $album == "wedding") {
	$nameab = $user . " Wedding Photos.";
  }
  $displayname = ($user == "nhimxu") ? "Nhim Xu Live Show" : $nameab;


  $sqlcn = mysql_connect('localhost:3306', 'gxlongchau', 'tukhoico');
  if (!$sqlcn) {
      die('Could not connect: ' . mysql_error());
  }
    mysql_select_db('svbuichu', $sqlcn); 
    $strQuery = "SELECT * FROM `imageurl` i WHERE `i`.userid='".$user."'";
    if(strlen($album) > 0) {
       $strQuery .= " AND `i`.`albumname`='".$album. "'";
    }
    $strQuery .= " ORDER BY `i`.`index` ASC";
    $result= mysql_query($strQuery);
    $link="";
    while($x=mysql_fetch_array($result))  {
       $link .= "\"". trim($x["url"]) . "\",";
    }
    $link .= "XXX";
    $link = str_replace(",XXX","", $link);
    $link = str_replace(",",",\n", $link);
  mysql_close($sqlcn);
  if(strlen($link) > 5) {
?>
    <div id="r"></div>
		<div id="g" style="width: 1px; height: 1px;"></div>
    <div id="Parent">
        <div id="copy"><?php echo $displayname; ?>.</div>
    </div>
      <script type = "text/javascript">
      top.document.title = '<?php echo $displayname; ?>';
      var IMGS = [
<?php 
 echo $link;
?>
      ];

      var LENGTH = IMGS.length;
      var CACHE = 0;
      var NEXT = 0;
      var ISGOOGLE = false;//(IMGS[0].indexOf('google') > 0)
    </script>
    <script type="text/javascript" src="http://vnjs.net/www/project/oy/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="display.js"></script>
<?php 
  } else {
?>
    <div id="Parent2">
        <div id="info">  Album cua ban <b><?php echo $user; ?></b> hien chua co anh nao.</div>
    </div>
<?php 
  }
} else {
?>
    <div id="Parent2">
        <div class="image_info" id="info">
           <span>Duong dang de xem anh chua dung. </br> No co cau truc la: http://svbuichu.com/albums.php?user=$userid<br/></span>
           <span>vi du: <a href="http://svbuichu.com/albums.php?user=nhimxu">http://svbuichu.com/albums.php?user=nhimxu</a><br/></span>
        </div>
    </div>
<?php 
}
?>
  </body>
</html>
