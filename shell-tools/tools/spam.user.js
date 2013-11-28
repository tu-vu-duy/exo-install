// ==UserScript==
// @name           Get pics url facebook.com
// @description    Automate lay link anh tu facebook.
// @version        0.1
//

var arrs = ['google_ads_frame', 'google_ads_frame1', 'google_ads_frame2', 'google_image_div', 'adsense_bottom'];
for (var i = 0; i < arrs.length; ++i) {
  var script = document.getElementById(arrs[i]);
  if(script) {
    script.style.display="none";
    script.innerHTML = "";
  }
}
