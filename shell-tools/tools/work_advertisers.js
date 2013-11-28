function AD(id, width, height) {
    this.id = (id) ? id : "";
    this.className = "";
    this.content = "";
    this.link = "";
    this.width = (width) ? width : "auto";
    this.height = (height) ? height :"auto";
    this.prentId = "";
    this.getBlockContent = function () {
      var div = document.createElement("div");
      div.id = this.id;
      div.className = this.className;
      div.style.width = this.width;
      div.style.height = this.height;
      div.style.display = "inline-block";
      if(String(this.link).length > 0) {
         div.innerHTML = '<a href="' + this.link + '">' + this.content + '</a>';
      } else {
         div.innerHTML += this.content;
      }
      return div;
    }
};

var ADSCore = {
    indexBl: null,
    ads: [],
    len: 0,
    blockIds: [],
    getElement : function(elm) {
      var elm_ = null;
      if(typeof(elm) == "string") {
        elm_ = document.getElementById(elm);
        if(!elm_) {
          elm_ = document.getElementsByClassName(elm)[0];
        }
        if(!elm_ && elm === "body") {
          elm_ = document.getElementsByTagName(elm)[0];
        }
      } else if(elm){
        elm_ = elm;
      }
      return elm_;
    },
    createElement : function (type, id, calzz, style) {
      var elm = document.createElement(type);
      elm.id = id;
      elm.className = calzz;
      elm.setAttribute('style', style);
      return elm;
    },
    setDefaultPrentId: function (elm) {
      ADSCore.indexBl = ADSCore.getElement(elm);
    },
    setAdvertiser: function (ad) {
      ADSCore.blockIds[ADSCore.len] = ad.id;
      ADSCore.ads[ADSCore.len] = ad;
      ADSCore.len += 1;
    },
    display: function (id) {
      if(ADSCore.indexBl != null && id != null && id >= 0 && id < ADSCore.len) {
        var ad = ADSCore.ads[id];
        if(ad.prentId) {
          var pr = ADSCore.getElement(ad.prentId);
          if(pr){
           if(pr.style.display == 'none') {
              pr.style.display = 'inline-block';
           }
           pr.appendChild(ad.getBlockContent());
          }
        } else {
          ADSCore.indexBl.style.display = 'block';
          ADSCore.indexBl.appendChild(ad.getBlockContent());
        }
      }
    },
    randomly: function () {
      var t = 1, i = 0;
      var ids = String("");
      while (t <= 3) {
        i = Math.floor(Math.random()*ADSCore.len);
        if(ids.indexOf(String(i)) < 0) {
          ADSCore.display(i);
          ids += i + "";
          t += 1;
        }
      }
    }
};

(function createIndexBlock() {
  var body = ADSCore.getElement("body");
  var style = 'background: #ffffff; overflow:auto; display:none;';
  var topLeft = ADSCore.getElement("TopLeft");
  if(!topLeft)  {
    topLeft = ADSCore.createElement('div', 'TopLeft', 'TopLeft', style);
    body.insertBefore(topLeft, body.firstChild);
  }
  var topRight = ADSCore.getElement("TopRight");
  if(!topRight)  {
    topRight = ADSCore.createElement('div', 'TopRight', 'TopRight', style + 'float:right;');
    body.insertBefore(ADSCore.createElement('div', '', '', 'clear:right;'), body.firstChild);
    body.insertBefore(topRight, body.firstChild);
  }

  var bottomLeft = ADSCore.getElement("BottomLeft");
  if(!bottomLeft)  {
    bottomLeft = ADSCore.createElement('div', 'BottomLeft', 'BottomLeft', style);
    body.appendChild(bottomLeft);
  }
  var bottomRight = ADSCore.getElement("BottomRight");
  if(!bottomRight)  {
    bottomRight = ADSCore.createElement('div', 'BottomRight', 'BottomRight', style + 'float:right;');
    body.appendChild(bottomRight);
    body.appendChild(ADSCore.createElement('div', '', '', 'clear:right;'));
  }

  style += 'position: absolute;z-index:300000;';

  var onTopLeft = ADSCore.getElement("OnTopLeft");
  if(!onTopLeft)  {
    onTopLeft = ADSCore.createElement('div', 'OnTopLeft', 'OnTopLeft', style + 'top:0px; left:0px;');
    body.appendChild(onTopLeft);
  }
  var onTopRight = ADSCore.getElement("OnTopRight");
  if(!onTopRight)  {
    onTopRight = ADSCore.createElement('div', 'OnTopRight', 'OnTopRight', style + 'top:0px; right:0px;');
    body.appendChild(onTopRight);
  }

  var onBottomLeft = ADSCore.getElement("OnBottomLeft");
  if(!onBottomLeft)  {
    onBottomLeft = ADSCore.createElement('div', 'OnBottomLeft', 'OnBottomLeft', style + 'bottom:0px; left:0px;');
    body.appendChild(onBottomLeft);
  }
  var onBottomRight = ADSCore.getElement("OnBottomRight");
  if(!onBottomRight)  {
    onBottomRight = ADSCore.createElement('div', 'OnBottomRight', 'OnBottomRight', style + 'bottom:0px; right:0px;');
    body.appendChild(onBottomRight);
  }

})();

(function init() {
  // default index element for display. Ex: set it in to body
  ADSCore.setDefaultPrentId('body') ;
  // crateting advertisers ...

  var ad = new AD('bl1', '180px', '130px');
  ad.content = '<div style="background: url(\'http://odesk-prod-portraits.s3.amazonaws.com/Users:tuvd08:PortraitUrl_100?AWSAccessKeyId=1XVAX3FNQZAFC9GJCFR2&Expires=2147483647&Signature=v6f6m%2FHjFHyjIPEYRh%2BynV2Z6t8%3D&1332239289\'); padding: 30px;"> Company #1 </div>';
  ad.link = 'http://odesk.com';
  ADSCore.setAdvertiser(ad);


  ad = new AD('bl2', '300px');
  ad.content = 'Company #2';
  ad.prentId = 'copy';
  ADSCore.setAdvertiser(ad);


  ad = new AD('', '', '150px');
  ad.content = 'Company #3';
  ADSCore.setAdvertiser(ad);

  ad = new AD('', '120px', '100px');
  ad.prentId = 'copy';
  ad.content = 'Company #4';
  ADSCore.setAdvertiser(ad);


  ad = new AD();
  ad.prentId = 'XXX';
  ad.content = 'Company #5';
  ADSCore.setAdvertiser(ad);


  ad = new AD();
  ad.prentId = 'XXX';
  ad.content = 'Company #6';
  ADSCore.setAdvertiser(ad);

  ad = new AD();
  ad.prentId = 'TopLeft';
  ad.content = 'Company #7';
  ADSCore.setAdvertiser(ad);

  ad = new AD();
  ad.prentId = 'TopRight';
  ad.content = 'Company #8';
  ADSCore.setAdvertiser(ad);

  ad = new AD();
  ad.prentId = 'OnTopLeft';
  ad.content = 'Company #9';
  ADSCore.setAdvertiser(ad);

  ad = new AD();
  ad.prentId = 'OnTopRight';
  ad.content = 'Company #10';
  ADSCore.setAdvertiser(ad);

  ad = new AD();
  ad.prentId = 'OnBottomRight';
  ad.content = 'Company #11';
  ADSCore.setAdvertiser(ad);

  ad = new AD();
  ad.prentId = 'OnBottomLeft';
  ad.content = 'Company #12';
  ADSCore.setAdvertiser(ad);


  ad = new AD();
  ad.prentId = 'BottomRight';
  ad.content = 'Company #13';
  ADSCore.setAdvertiser(ad);

  ad = new AD();
  ad.prentId = 'BottomLeft';
  ad.content = 'Company #14';
  ADSCore.setAdvertiser(ad);

  ADSCore.randomly();

})();








