// formName --> file php
// ty
function ajax() {
};

ajax.prototype.getRequest = function(id) {
	var xmlhttp;
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera,
								// Safarip
		xmlhttp = new XMLHttpRequest();
	} else {// code for IE6, IE5
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200 && id) {
			document.getElementById(id).innerHTML = xmlhttp.responseText;
		}
	}
  return xmlhttp;
};

ajax.prototype.submitform = function(formName, idblock, reloadall ) {
  var xmlhttp = ajax.getRequest(idblock);
  xmlhttp.open("POST", formName, true);
  xmlhttp.send();
  if(reloadall) {
    setTimeout("window.location.reload( false )", 1050);
  }
};

ajax.prototype.requestURL = function(formName, str, idblock, reloadall) {
  var xmlhttp = ajax.getRequest();
  xmlhttp.open("GET", formName + "?" + ajax.encodeURL(str), true);
  xmlhttp.send();
  if(reloadall) {
     window.location.reload( false );
  }
};

ajax.prototype.encodeURL = function(str) {
  arr = [" ", "\"", "&", "'", "/", "?"];
  arr2 = ["%20", "%22", "%26", "%27", "%2F", "%3F"];
  for (var i = 0; i < arr.length; ++i) {
    while(str.indexOf(arr[i]) >= 0) {
      str = str.replace(arr[i], arr2[i]);
    }
  }
};

ajax = new ajax() ;
