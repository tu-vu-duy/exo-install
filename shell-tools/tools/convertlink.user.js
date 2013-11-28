// ==UserScript==
// @Author         Vu Duy Tu
// @name           Set link HTML by key 'evernote'
// @description    Automate replace text content 'evernote:///' by HTML link.
// @version        0.2
//
// ==/UserScript==

var ReplaceLink = {
	replaceHTMLLinks : function(text) {
		var exp = /(\bevernote:\/\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/igm;
		return text.replace(exp, "<a href='$1'>Evernote Link</a>");
	},
	init : function() {
		var all = document.body.getElementsByTagName('*');
		var elm;
		var textCt = "";
		for ( var i = 0; i < all.length; ++i) {
			elm = all[i];
			textCt = String(elm.textContent);
			if (textCt && textCt.length > 0 && textCt.indexOf('evernote:') >= 0) {
				elm.innerHTML = ReplaceLink.replaceHTMLLinks(textCt);
			}
		}
	}
};

ReplaceLink.init();
