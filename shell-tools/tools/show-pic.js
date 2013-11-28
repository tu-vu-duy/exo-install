var PIC = {
	mWith : "120px",
	img : null,
	id : 20,
	hiddenAll : function() {
		PIC.hidden(this);
		if (this.id === "contImg") {
			PIC.hidden(document.getElementById('showImg'));
		} else {
			PIC.hidden(document.getElementById('contImg'));
		}
		PIC.img = null;
	},
	hidden : function(elm) {
		if (elm) {
			elm.innerHTML = "";
			elm.style.display = "none";
		}
	},
	opacityIM : function() {
		PIC.id = PIC.id + 1;
		if (PIC.img != null) {
			if (i < 100) {
				PIC.img.style.opacity = PIC.id / 100;
				PIC.img.style.filter = 'alpha(opacity=' + PIC.id + ')';
				try {
					setTimeout("PIC.opacityIM()", 10);
				} catch (exc) {
					alert(exc);
				}
			} else {
				PIC.img.style.opacity = 1;
				PIC.img.style.filter = 'alpha(opacity=' + 100 + ')';
				PIC.id = 20;
			}
		}
	},
	displayPic : function() {
		PIC.displayElmPic(this)
	},
  displayElmPic: function (elm) {
    var myBody = document.getElementsByTagName("body")[0];
		var div = document.getElementById('showImg');
		if (!div) {
			div = document.createElement("div");
			div.id = 'showImg';
			div.className = 'ShowImg';
			myBody.appendChild(div);
			div.onclick = PIC.hiddenAll;
		}
		div.style.display = "block";
		var html = document.getElementsByTagName("html")[0];
		div.style.width = html.offsetWidth + "px";
		div.style.height = html.offsetHeight + "px";
		
		var cont = document.getElementById('contImg');
		if (!cont) {
			cont = document.createElement("div");
			cont.id = "contImg";
      cont.className = "ContentImg";
			myBody.appendChild(cont);
		}
		cont.style.display = "block";
    if(cont.firstChild){
      cont.removeChild(cont.firstChild);
    }
    KEYIMG.setCurrent(elm);
		PIC.img = document.createElement("img");
		PIC.img.src = elm.src;
		if (PIC.img.width > (html.offsetWidth - 200)) {
			PIC.img.width = (html.offsetWidth - 200);
		}
		cont.style.left = (html.offsetWidth - PIC.img.width) / 2 + "px";
		var sTop = (document.documentElement.scrollTop);
    var wd = document.documentElement.clientHeight;
		cont.style.top = (sTop + (wd - (PIC.img.height+20) )/2)  + "px";
		cont.appendChild(PIC.img);
		PIC.id = 20;
		PIC.opacityIM();
		cont.onclick = PIC.hiddenAll;
  }

};

var KEYIMG = {
    IMGS :[],
    current : 0,
    maxSize: 0,
    getKeynum : function (event) {
		    var keynum = false ;
		    if(window.event) { /* IE */
			    keynum = window.event.keyCode;
			    event = window.event ;
		    } else if(event.which) { /* Netscape/Firefox/Opera */
			    keynum = event.which ;
		    }
			    if(keynum == 0) {
			    keynum = event.keyCode ;
		    }
			    return keynum ;
	    },
      calculateKey : function (event) {
      var keynum = KEYIMG.getKeynum(event);
		  if(keynum == 37){//onLeftArrow
        var show = KEYIMG.current - 1;
        if(show < 0) {
          show = (KEYIMG.maxSize-1);
          KEYIMG.current = show;
        }
        PIC.displayElmPic(KEYIMG.IMGS[show]);
		  } else if(keynum == 39){//onRightArrow
        var show = KEYIMG.current + 1;
        if(show == KEYIMG.maxSize) show = 0;
        PIC.displayElmPic(KEYIMG.IMGS[show]);
		  } else if(keynum == 38){//onUpArrow

		  } else if(keynum == 40){//onDownArrow

		  } else if(keynum == 36){//onHome

		  } else if(keynum == 35){//onEnd

		  }else if(keynum == 27){//ESC
        PIC.hidden(document.getElementById('showImg'));
        PIC.hidden(document.getElementById('contImg'));
		  }
    },
    setCurrent : function (img) {
      for (var i = 0; i < KEYIMG.maxSize; ++i) {
         if(KEYIMG.IMGS[i] === img) {
            KEYIMG.current = i;
            break;
         }
      }
    }
};

var BBIMG = {
	classN : "GridImage",
	height : "",
	width : "150",
	type : "IMG",// GR, IMG
	getAllSRCImgs : function(str) {
		str = String(str);
		var t = 0;
		var k = 1;
		var x, y, z;
		var link = [];
		var j = 0;
		while (k > -1) {
			k = str.indexOf("http", t);
			x = str.indexOf(",", k + 3) + 1;
			y = str.indexOf(".jpg", k + 3) + 4;
			if(y < 5)y = str.indexOf(".JPG", k + 3) + 4;
			z = str.indexOf(".gif", k + 3) + 4;
			if ((x < y || y < 10) && (x < z || z < 10) && x > 10)
				t = x;
			if ((y < x || x < 10) && (y < z || z < 10) && y > 10)
				t = y;
			if ((z < x || x < 10) && (z < y || y < 10) && z > 10)
				t = z;
			link[j] = str.substring(k, t);
			++j;
		}
		return link;
	},
	baseImg : function(links) {
		var imgs = [];
		for ( var i = 0; i < links.length; ++i) {
			var img = document.createElement("img");
			img.src = links[i];
			if (String(BBIMG.height).length > 0) {
				img.height = BBIMG.height;
			}
			if (String(BBIMG.width).length > 0) {
				img.width = BBIMG.width;
			}
			img.onclick = PIC.displayPic;
			imgs[i] = img;
		}
		if (BBIMG.type === "GR") {
			var s = imgs.length;
			var table = document.createElement("table");
			table.className = "UIGridIMG";
			table.setAttribute("border", "0");
			var r = Math.round(s / 5);
			if (r < 1)
				r = 1;
			else if (r * 5 < s) {
				r += 1;
			}
			var t = 0;

			for ( var i = 0; i < r && t < s; ++i) {
				var Row = table.insertRow(i);
				for ( var j = 0; j < 5 && t < s; ++j) {
					var Cell = Row.insertCell(j);
					Cell.appendChild(imgs[t]);
					++t;
				}
			}
			return table;
		} else {
			var cont = document.createElement("div");
      cont.className = "UIDivIMG";
			for ( var i = 0; i < imgs.length; ++i) {
				if (String(BBIMG.width).length < 0) {
					imgs[i].width = "150";
				}
				cont.appendChild(imgs[i]);
			}
			return cont;
		}
	}
};

(function displayIMG() {
	var head = top.document.getElementsByTagName("head")[0];
  if(head) {
    var link = document.createElement("link");
    link.type = "text/css";
    link.setAttribute("rel", "stylesheet");
    link.href = "http://svbuichu.com/svbuichu.css";
    head.appendChild(link);
  }

  var pageWrapper = document.getElementById("pageWrapper");
  var mWith = 0;
  if(pageWrapper) {
    mWith = pageWrapper.offsetWidth;
  }
	var allBBs = document.getElementsByClassName(BBIMG.classN);
	for ( var i = 0; i < allBBs.length; ++i) {
    BBIMG.type = allBBs[i].getAttribute("type");
    if(mWith > 0) {
      if(BBIMG.type === "GR") {
        BBIMG.width = Math.round((mWith - 125)/5);
      } else {
        BBIMG.width = Math.round((mWith - 170)/4);
      }
    }
    var p = allBBs[i].getElementsByTagName("p")[0].innerHTML = "";
		var cont = allBBs[i].getElementsByTagName("div")[0].innerHTML;
		allBBs[i].innerHTML = "";
		allBBs[i].appendChild(BBIMG.baseImg(BBIMG.getAllSRCImgs(cont)));
	}
	
})();


(function initOnload() {
	var myBody = top.document.getElementsByTagName("body")[0];
	var maxW = myBody.offsetWidth - 100;
  var l = 0;
	var allprs = document.getElementsByClassName("content");
	for ( var i = 0; i < allprs.length; ++i) {
		var pics = allprs[i].getElementsByTagName("img");
		for ( var j = 0; j < pics.length; ++j) {
			pics[j].onclick = PIC.displayPic;
			if (pics[j].width > maxW) {
				pics[j].width = maxW;
			}
      KEYIMG.IMGS[l] = pics[j];
      ++l;
		}
	}
  KEYIMG.maxSize = l;
})();

(function addOnkeyDown() {
		document.documentElement.onkeydown = KEYIMG.calculateKey;
})();

function refresh() {
  window.location.href = window.location;
  window.location.reload(true);
}


