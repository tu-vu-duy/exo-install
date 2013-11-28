/**
 * Created by The Sinh Vien Cong Giao Bui Chu
 * Author : Vu Duy Tu
 *          donrac@svbuichu.com
 * March 10, 2012 - 1:51:01 AM  
 */

String.prototype.trim = function () {
  return this.replace(/^\s+|\s+$/g, "");
};

var FS = {
  links : [],
  username: "svbuichu",
  id: "",
  urlPhoto: "https://www.facebook.com/",
  local: String(window.location),
  decode: function (str) {
    return unescape(str.replace(/\+/g, " "));
  },
  setCookie: function (name_, value, expiredays) {
    var exdate = new Date();
    exdate.setDate(exdate.getDate() + expiredays);
    document.cookie = name_ + "=" + escape(value) + ((expiredays == null) ? "" : ";expires=" + exdate.toGMTString());
  },

  getCookie: function (name_) {
    if (document.cookie.length > 0) {
      var start = document.cookie.indexOf(name_ + "=");
      if (start != -1) {
        start = start + name_.length + 1;
        var end = document.cookie.indexOf(";", start);
        if (end == -1) end = document.cookie.length;
        return unescape(document.cookie.substring(start, end));
      }
    }
    return "";
  },
  createElement : function (type, id, calzz, style, inner) {
      var elm = document.createElement(type);
      if(id && id != '') elm.id = id;
      if(calzz && calzz != '') elm.className = calzz;
      if(style && style != '') elm.setAttribute('style', style);
      if(inner && inner != '') elm.innerHTML = inner;
      return elm;
  },
  openAllAnbum: function () {
    var mainAb = document.getElementById("pagelet_photo_albums");
    if (mainAb) {
      var as = document.getElementsByClassName("uiMediaThumb");
      for (var i = 0; i < as.length; ++i) {
        var link = as[i].href;
        if (link && String(link).indexOf("media/set/") > 0) {
          window.open(link);
        }
      }
    }
  },

  getThumbPics: function () {
    var allLink = FS.createElement('div', 'links');
    var bbcodes = FS.createElement('div', '', '', 'border:solid 1px #b7b7b7', 'BBCode [IMG]');
    var allbbs = FS.createElement('div', '', '', 'border:solid 1px #b7b7b7', 'BBCode [IMGS]<br/>[IMGS=GR]');
    if (FS.local.indexOf("media/set/") > 0 || FS.local.indexOf('sk=photos') > 0) {
      var as = [];
      var pics = document.getElementById('pagelet_photos_of_me');
      if(pics) {
        as = pics.getElementsByClassName("uiMediaThumb");
      } else {
        as = document.getElementsByClassName("uiMediaThumb");
      }
      var j = 0;
      FS.links = [];
      for (var i = 0; i < as.length; ++i) {
        var link = as[i].href;
        if (link && String(link).indexOf("photo.php") > 0) {
          var src = String(as[i].getAttribute("ajaxify"));
          src = src.substring((src.indexOf("src=") + 4), src.indexOf("theater") - 1);
          allLink.innerHTML += "<br/>" + FS.decode(src);
          bbcodes.innerHTML += "<br/>[IMG]" + FS.decode(src) + "[/IMG]";
          allbbs.innerHTML += FS.decode(src);
          FS.links[j] = FS.decode(src);
          ++j;
        }
      }
    }
    top.document.getElementsByTagName("body")[0].style.overflow = "auto";
    allbbs.innerHTML += "[/IMGS]";
    var divCt = FS.createElement('div');
    divCt.appendChild(allLink);
    divCt.appendChild(bbcodes);
    divCt.appendChild(allbbs);
    return divCt;
  },
  getKeyGl: function (link) {
    var key = String(link);
    if (key.indexOf("/s") > 0) {
      if (key.indexOf("/s128") > 0) key = "s128";
      else if (key.indexOf("/s197") > 0) key = "s197";
      else if (key.indexOf("/s172") > 0) key = "s172";
      else {
        var t = 0;
        for (var i = 1; i < 9; ++i) {
          t = key.indexOf("/s" + i);
          if (t > 0) break;
        }
        if (t > 0) {
          key = key.substring(t + 1, key.indexOf("/", t + 2));
        }
      }
    }
    if ((key === link) && (key.indexOf("/w") > 0)) {
      var t = 0;
      for (var i = 1; i <= 9; ++i) {
        t = key.indexOf("/w" + i);
        if (t > 0) break;
      }
      if (t > 0) {
        key = key.substring(t + 1, key.indexOf("/", t + 2));
      }
    }
    if (key === link) {
      return "";
    } else {
      return key;
    }
  },
  getPicasa: function (size) {
    var allLink = FS.createElement('pre', 'links', '', 'padding:0px;margin:3px 0;font-family:Arial;');
    var bbcodes = FS.createElement('pre', '', '', 'border:solid 1px #b7b7b7;padding:0px;margin:3px 0;font-family:Arial;', 'BBCode [IMG]');
    var allbbs = FS.createElement('div', '', '', 'border:solid 1px #b7b7b7', 'BBCode [IMGS]<br/>[IMGS=GR]');
    if (FS.local.indexOf("google") > 0) {
      var cont = document.getElementById('lhid_content');
      if (cont == null) {
        cont = document.getElementById('lhid_albums');
        if(cont == null) {
          cont = document.getElementById('contentPane');
          if(cont == null) {
            cont = document.getElementById('feedContent');
            if(cont == null) {
              cont = document.getElementsByClassName('Yo4mPb')[0];
              if(cont == null) {
                cont = document.getElementsByClassName('i4fcIb')[0];
              }
            }
          }
        }
      }
      if (cont) {
        var links = cont.getElementsByTagName('img');
        var larrayA = new Array();
        var larrayBB = new Array();
        var larrayABB = new Array();
        var link = "";
        var key = "";
        var j = 0;
        FS.links = [];
        for (var i = 0; i < links.length; ++i) {
          link = String(links[i].src) + "";
          if (link.length > 0 && link.indexOf("/img/") < 0 && link.indexOf("moz-icon") < 0) {
            key = FS.getKeyGl(link);
            if (key.length > 0) {
              link = link.replace(key, size);
            }
            larrayA.push('\n' + link);
            larrayBB.push("\n[IMG]" + link + "[/IMG]");
            larrayABB.push(link);
            FS.links[j] = link;
            ++j;
          }
        }
        allLink.appendChild(document.createTextNode(larrayA.join('')));
        bbcodes.appendChild(document.createTextNode(larrayBB.join('')));
        allbbs.appendChild(document.createTextNode(larrayABB.join('')));
      }
    }
    
    allbbs.innerHTML += "[/IMGS]";
    var divCt = FS.createElement('div');
    divCt.appendChild(allLink);
    divCt.appendChild(bbcodes);
    divCt.appendChild(allbbs);
    return divCt;
  },
  getKeyFK: function (link) {
    var key = String(link);
    if (key.indexOf("_s.jpg") > 0) key = "_s.jpg";
    else if (key.indexOf("_o.jpg") > 0) key = "_o.jpg";
    else if (key.indexOf("_b.jpg") > 0) key = "_b.jpg";
    else if (key.indexOf("_m.jpg") > 0) key = "_m.jpg";
    else if (key.indexOf("_z.jpg") > 0) key = "_z.jpg";
    else if (key.indexOf("_t.jpg") > 0) key = "_t.jpg";
    else key = "";
    return key;
  },
  getFlickr: function (size) {
    var allLink = FS.createElement('div', 'links');
    var bbcodes = FS.createElement('div', '', '', 'border:solid 1px #b7b7b7', 'BBCode [IMG]');
    var allbbs = FS.createElement('div', '', '', 'border:solid 1px #b7b7b7', 'BBCode [IMGS]<br/>[IMGS=GR]');
    if (FS.local.indexOf("flickr.com") > 0) {
      var cont = document.getElementById('setThumbs');
      if (cont === null) {
        cont = document.getElementById('main');
        if (cont === null) cont = document.getElementById('findr');
      }
      if (cont) {
        var links = cont.getElementsByTagName('img');
        var link = "";
        var key = "";
        var j = 0;
        FS.links = [];
        for (var i = 0; i < links.length; ++i) {
          link = String(links[i].src) + "";
          if (link.length > 0 && (link.indexOf("static.flickr") > 0 || link.indexOf("static.flickr") > 0)) {
            key = FS.getKeyFK(link)
            if (key.length > 0) {
              link = link.replace(key, size);
            }
            allLink.innerHTML += "<br/>" + link;
            bbcodes.innerHTML += "<br/>[IMG]" + link + "[/IMG]";
            allbbs.innerHTML += link;
            FS.links[j] = link;
            ++j;
          }
        }
      }
    }
    allbbs.innerHTML += "[/IMGS]";
    var divCt = FS.createElement('div');
    divCt.appendChild(allLink);
    divCt.appendChild(bbcodes);
    divCt.appendChild(allbbs);
    return divCt;
  },
  getBucket: function (size) {
    var allLink = FS.createElement('div', 'links');
    var bbcodes = FS.createElement('div', '', '', 'border:solid 1px #b7b7b7', 'BBCode [IMG]');
    var allbbs = FS.createElement('div', '', '', 'border:solid 1px #b7b7b7', 'BBCode [IMGS]<br/>[IMGS=GR]');
    if (FS.local.indexOf("photobucket.com") > 0) {
      var cont = document.getElementById('thumbContainer');
      if (cont === null) {
        cont = document.getElementsByClassName('tresults')[0];
      }
      if (cont) {
        var items = cont.getElementsByClassName("thumbnail");
        var link = "";
        var j = 0;
        FS.links = [];
        if (items && items.length > 0) {
          for (var i = 0; i < items.length; ++i) {
            var item = items[i].getAttribute("pbinfo");
            eval("var json = " + item + ";");
            link = (size === "full") ? json.mediaUrl : json.mediaThumbUrl;
            allLink.innerHTML += "<br/>" + link;
            bbcodes.innerHTML += "<br/>" + json.links["IMG code"];
            allbbs.innerHTML += link;
            FS.links[j] = link;
            ++j;
          }
        } else {
          var links = cont.getElementsByTagName('img');
          for (var i = 0; i < links.length; ++i) {
            link = String(links[i].src) + "";
            if (link.length > 0 && links[i].className === "under off") {
              if (size != "full") { //th_
                link = link.substring(0, link.lastIndexOf("/") + 1) + "th_" + link.substring(link.lastIndexOf("/") + 1);
              }
              allLink.innerHTML += "<br/>" + link;
              bbcodes.innerHTML += "<br/>[IMG]" + link + "[/IMG]";
              allbbs.innerHTML += link;
              FS.links[j] = link;
              ++j;
            }
          }
        }
      }
    }
    allbbs.innerHTML += "[/IMGS]";
    var divCt = FS.createElement('div');
    divCt.appendChild(allLink);
    divCt.appendChild(bbcodes);
    divCt.appendChild(allbbs);
    return divCt;
  },
  block: function (info) {
    var div = document.getElementById('block');
    if (!div) {
      var style = "position: absolute;z-index:300000; overflow:auto; top: 80px; left: 30px; border:3px double gray; background: #ffffff; padding: 10px";
      div = FS.createElement("div", "block", "", style);
      div.style.minWidth = "400px";
      div.style.overflow = "auto";
      var myBody = top.document.getElementsByTagName("body")[0];
      myBody.appendChild(div);
    }
    div.style.display = "block";
    div.innerHTML = "<a href=\"javascript:void(0);\" onclick=\"FS.close('block')\">[X]</a>";
    div.appendChild(info);

    var at1 = FS.createElement('a', '', '', '','Hien Thi Anh');
    at1.href = "javascript:void(0);";
    at1.onclick = FS.Show;
    div.appendChild(at1);

    if (FS.local.indexOf("/organize") > 0) {
      div.style.maxHeight = "450px";
      div.style.maxWidth = "600px";
    }
  },

  getCrUser: function () {
    var noscript = top.document.getElementsByTagName("noscript")[0];
    var ct = String(noscript.innerHTML);
    var id = ct.indexOf("URL=/") + 5;
    var username = FS.getCookie("olduser");
    FS.id = "";
    if (id > 0 && ct.indexOf("media/set") < 0) {
      if (ct.indexOf("profile.php") > 0 && ct.indexOf("?id=") > 0) {
        id = ct.indexOf("?id=", id + 1);
        username = ct.substring(id + 4, ct.indexOf("&", id + 4));
        FS.id = username;
      } else if (ct.indexOf("photo.php") > 0 && ct.indexOf("?fbid=") > 0) {
        var pr = document.getElementById('fbPhotoPageHeader');
        if(pr) {
          var arr = pr.getElementsByTagName('a');
          for(var i = 0; i < arr.length; ++i) {
            var href = String(arr.href);
            if((id=href.indexOf('profile.php?id=')) > 0) {
              var x = href.indexOf('&');
              username = href.substring(id+15, (x > 0) ? x : href.length);
              FS.id = username;
              break;
            }
          }
        }
      } else {
        var x = ct.substring(id, ct.indexOf("?", id + 1));
        if(x.indexOf('/') > 0) {
          username = FS.getCookie("c_user");
        } else {
          username = x;
        }
      }
    }
    return username;
  },
  startGet: function () {
    if (FS.id.length > 0) {
      window.location = FS.urlPhoto + "profile.php?id=" + FS.id + "&sk=photos";
    } else {
      window.location = FS.urlPhoto + FS.username + "?sk=photos";
    }
  },
  Show: function () {
    var div = document.getElementById('links');
    if (div) {
      var block = document.getElementById('block');
      var cont = new Array();
      var tem = FS.createElement('div', 'showpics');
      for (var i = 0; i < FS.links.length; ++i) {
        cont.push("<img src=\"" + FS.links[i] + "\">");
        var img = FS.createElement('img');
        img.src = FS.links[i];
        tem.appendChild(img);
      }
      var tem2 = FS.createElement('div', '', '', 'padding: 10px',  "HTML Code:<br/> ");
      tem2.appendChild(document.createTextNode(cont.join()));
      block.appendChild(tem);
      block.appendChild(tem2);
    }
  },
  close: function (id) {
    var div = document.getElementById(id);
    if (div) {
      div.style.display = "none";
      div.innerHTML = "";
    }
  },
 displayBlock: function (elm, id) {
    var div = document.getElementById(id);
    if (div) {
      var stt = div.style.display;
      if(stt === '' || stt === 'block') {
        stt = 'none';
        if(elm) {
          elm.innerHTML = "[O]";
        }
      } else {
        stt = 'block';
        if(elm) {
          elm.innerHTML = "[X]";
        }
      }
      div.style.display = stt;
      FS.setCookie("display" + id, stt, 10000);
    }
  },
  button: function () {
    var div = document.getElementById('button');
    if (!div) {
      var Pdiv = document.createElement("div");
      div = document.createElement("div");
      div.id = 'button';
      div.setAttribute("style", "position: absolute; z-index:290000; overflow:auto; top: 50px; left: 30px; border: 3px double gray; background: #ffffff; padding: 5px");
      div.style.position = "absolute";
      div.style.minWidth = "10px";
      div.style.overflow = "auto";
      div.style.top = "40px";
      div.style.left = "30px";
      div.style.border = "solid 2px gray";
      div.style.background = "#ffffff";
      div.style.padding = "5px";
      Pdiv.appendChild(div);
      var myBody = top.document.getElementsByTagName("body")[0];
      myBody.appendChild(Pdiv);
    }
    div.style.display = "block";
    var html = "<a style=\"float:right\" href=\"javascript:void(0);\" onclick=\"FS.displayBlock(this,'blockbutton')\">[X]</a>";
    var stt = FS.getCookie("displayblockbutton");
    if(stt === "") {
      stt = "block";
      FS.setCookie("displayblockbutton", stt, 10000);
    } else if(stt === "none") {
      html = "<a style=\"float:right\" href=\"javascript:void(0);\" onclick=\"FS.displayBlock(this,'blockbutton')\">[O]</a>";
    }
    html +="<div style=\"float:left; display:" + stt + " \" id=\"blockbutton\">";
    if (FS.local.indexOf("facebook") > 0) {
      FS.username = FS.getCrUser();
      html += "Dang xem trang cua: <b>" + FS.username + "</b>&nbsp&nbsp&nbsp<br/>";
      var olduser = FS.getCookie("olduser");
      if (olduser === "" || FS.username != olduser) {
        FS.setCookie("olduser", FS.username, 10000);
      }

      if (FS.local.indexOf("sk=photos") > 0) {
        html += "<a style='border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block' onclick='FS.openAllAnbum()' href='javascript:void(0);'> Open all albums</a>";
        html += "&nbsp&nbsp&nbsp<a style='border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block' onclick='FS.block(FS.getThumbPics())' href='javascript:void(0);'> Display all link</a>";
      } else if (FS.local.indexOf("media/set/") > 0) {
        html += "<a style='border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block' onclick='FS.block(FS.getThumbPics())' href='javascript:void(0);'> Display all link</a>";
      } else {
        html += "<a style='border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block' onclick='FS.startGet()' href='javascript:void(0);'> Lay link anh</a>";
      }
    } else if (FS.local.indexOf("google") > 0) {
      var show = (FS.local.indexOf("picasa") > 0);
      if (FS.local.indexOf("plus.google.com") > 0 && FS.local.indexOf("/photos/") > 0) {
        show = true;
      }
      if (show === true) {
        html += "<a style=\"border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block\" onclick=\"FS.block(FS.getPicasa('s640'))\" href=\"javascript:void(0);\"> Display all link Size 640px</a>";
        html += "<br/><a style=\"border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block\" onclick=\"FS.block(FS.getPicasa('s720'))\" href=\"javascript:void(0);\"> Display all link Size 720px</a>";
        html += "<br/><a style=\"border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block\" onclick=\"FS.block(FS.getPicasa('s1024'))\" href=\"javascript:void(0);\"> Display all link Size 1024px</a>";
        html += "<br/><a style=\"border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block\" onclick=\"FS.block(FS.getPicasa('s2048'))\" href=\"javascript:void(0);\"> Display all link Full size</a>";
      } else {
        div.style.display = "none";
      }
    } else if (FS.local.indexOf("flickr") > 0) {
      html += "<br/><a style=\"border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block\" onclick=\"FS.block(FS.getFlickr('.jpg'))\" href=\"javascript:void(0);\"> Display all link Size 500px</a>";
      html += "<a style=\"border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block\" onclick=\"FS.block(FS.getFlickr('_z.jpg'))\" href=\"javascript:void(0);\"> Display all link Size 640px</a>";
      html += "<br/><a style=\"border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block\" onclick=\"FS.block(FS.getFlickr('_b.jpg'))\" href=\"javascript:void(0);\"> Display all link Size 1024px</a>";
    } else if (FS.local.indexOf("photobucket.com") > 0) {
      html += "<br/><a style=\"border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block\" onclick=\"FS.block(FS.getBucket('mini'))\" href=\"javascript:void(0);\"> Display all link smale Size</a>";
      html += "<br/><a style=\"border: solid 1px gray; padding: 3px; background: #EEEEEE; float:left; display:block\" onclick=\"FS.block(FS.getBucket('full'))\" href=\"javascript:void(0);\"> Display full Size</a>";
    }
    html +="</div>";
    div.innerHTML = html;
  }
};

setTimeout(FS.button, 1000);
