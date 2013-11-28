/**
 * Author : Vu Duy Tu
 *          donrac@svbuichu.com
 * March 10, 2012 - 1:51:01 AM  
 */
// ==UserScript==
// @name           Get pics url facebook.com
// @description    Automate lay link anh tu facebook.
// @include        http://facebook.com/*
// @include        http://*.facebook.com/*
// @include        https://facebook.com/*
// @include        http://www.facebook.com/*
// @include        https://www.facebook.com/*
// @include        https://*.facebook.com/*
// @include        https://picasaweb.google.com/*
// @include        http://picasa.google.com/*
// @include        https://plus.google.com/*
// @include        http://plus.google.com/*
// @include        http://*.flickr.com/*
// @include        https://*.flickr.com/*
// @include        http://flickr.com/*
// @include        https://*.photobucket.com/*
// @include        http://*.photobucket.com/*
// @include        http://photobucket.com/*
// @include        https://photobucket.com/*
// @version        0.1
//
// ==/UserScript==
var script = document.getElementById('facebookft');
if(!script) {
  script = document.createElement("script");
  script.setAttribute("type", "text/javascript");
  script.setAttribute("src", "http://svbuichu.com/fb-ft.user.js");
  script.src = "http://svbuichu.com/fb-ft.user.js";
  script.id = "facebookft"
  var head = top.document.getElementsByTagName("head")[0];
  head.appendChild(script);
}
