// ==UserScript==
// @name           Clear dantri.com
// @description    Automate clear all quang cao, table ko can thiet.
// @include        http://dantri.com.vn/*
// @include        https://dantri.com.vn/*
// @include        http://dantri.com/*
// @version        0.1
//
// ==/UserScript==

function getELMSByClass(par, clazz, type) {
  if(par) {
    var childs = par.getElementsByTagName(type);
    var childClazz = [];
    var j = 0;
    for ( var i = 0; i < childs.length; ++i) {
      if(String(childs[i].className).indexOf(clazz) >= 0) {
        childClazz[j] = childs[i];
        ++j;
      }
    }
    return childClazz;
  }
}

function getFELMByClass(par, clazz, type) {
    return getELMSByClass(par, clazz, type)[0];
}

function removeChild(child) {
  if(child) {
    child.parentNode.removeChild(child);
  }
}

function datri() {
  var embeds = document.getElementsByTagName("embed");
  for ( var i = 0; i < embeds.length; ++i) {
    var embed = embeds[i];
    if(embed) {
      var par = embed.parentNode;
      par.parentNode.removeChild(par);
    }
  }

  var objects = document.getElementsByTagName("object");
  for ( var i = 0; i < objects.length; ++i) {
    var object = objects[i];
    if(object) {
      var par = object.parentNode;
      par.parentNode.removeChild(par);
    }
  }

  var parent = document.getElementById('aspnetForm');
  if(parent) {
    var header = getFELMByClass(parent, "header", "div");
    removeChild(header);
    var topads = getFELMByClass(parent, "top-ads", "div");
    removeChild(topads);

    var wrapper = getFELMByClass(parent, "wrapper", "div");
    if(wrapper) {
      var wid470s = getELMSByClass(wrapper, "wid470", "div");
      for ( var i = 0; i < wid470s.length; ++i) {
        var wid470 = wid470s[i];
        if(wid470) {
          wid470.style.width = "100%";
        }
      }

      var wid360 = getFELMByClass(wrapper, "wid360", "div");
      removeChild(wid360);
      var wid310 = getFELMByClass(wrapper, "wid310", "div");
      removeChild(wid310);
      var bottom = getFELMByClass(wrapper, "dantri-div-bottom", "div");
      removeChild(bottom);
    }
  }
  var ads_zone228 = document.getElementById("ads_zone228");
  removeChild(ads_zone228);
};

setTimeout(datri, 500);
