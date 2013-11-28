// Author : Minh js
// Modify : Duy Tu.
      var MAXPAGE = 1;
      var CRPAGE = 1;
      var LIMIT = 0;
			var CACHE = 0;
			var NEXT = 0;
      var IMGPAGE = 150;
			if(typeof IMGS == "undefined") {
				var IMGS = [];
				var LENGTH = 0;
			}
			var waiting = document.getElementById("copy");
			var inn = (waiting) ? waiting.innerHTML : "";
      var pageInfo = inn + "<br/>";
			function setInnerHTML (sms) {
				if(waiting && waiting.innerHTML != sms) {
					waiting.innerHTML = sms;
				}
			}

			function getIndex(index) {
				var j = 0;
				if(index >= LENGTH) {
					var t = Math.round(index/LENGTH);
					j = index - ((t > 0)?t:1)*LENGTH;
				} else {
					j = index;
				}
				return j;
			}

      function getIMGSRC(index) {
        var i = index + LIMIT*(CRPAGE - 1);
				return IMGS[getIndex(i-1)];;
			}

      function getIMGMSRC(index) {
				return IMGS[getIndex(index-1)];
			}

      function setPage(index) {
				CRPAGE = index;
        Oy.removeImage();
        Oy.index = 0;
        Oy.render();
			}

      function getLimit() {
        LIMIT = IMGPAGE;
        if(LENGTH > IMGPAGE) {
          var x = Math.round(LENGTH/IMGPAGE);
          var dt = LENGTH - x*IMGPAGE;
          var y = Math.round(dt/x);
          LIMIT = IMGPAGE + y;
          MAXPAGE = x;
        }

        for (var i = 1 ; i <= MAXPAGE && MAXPAGE > 1; ++i) {
          pageInfo += '<a class="pageinfo" onclick="setPage(\'' + i + '\')"> Trang ' + i + " </a>";
        }
        return LIMIT;
      }

			var Oy = {
				isRandom: false,
				autoShow: true,
				timeShow: new Date().getTime(),
				timeOut: 5000,
				maxSize: 640,
				minSize: 64,
				limit: getLimit(),
				range: [],
				index: 0,
				zoomIn: false,
				current: null,
				cX: 0,
				cY: 0,
				timer: 0,
				process: false,
				getRange: function(limit) {
					var re = [];
					for (var i = 0; i < limit; ++i) {
						re.push(i);
					}
					for (var i = 0 ; i < limit; ++i) {
						re.splice(Math.floor(Math.random()*limit), 0, re.splice( Math.floor(Math.random()*limit), 1)[0]);
					}
					return re;
				},
				
				getFx: function(limit, index) {
					var step = 2/(limit-1);
					var x = index * step - 1;
					var f1 = -(2*Math.abs(x)/3 - Math.sqrt(1-x*x));
					var f2 = -(2*Math.abs(x)/3 + Math.sqrt(1-x*x));
					var delta = Math.random() * (f1-f2);
					return {
						delta: delta,
						x: x,
						f1: f1,
						f2: f2
					}
				},
				
				scaleImage: function(image, fixSize) {
					var fixHeight = image.height;
					var fixWidth = image.width;
					var nW, nH;
					if (fixWidth > fixHeight) {
						nW = fixSize;
						nH = fixSize*fixHeight/fixWidth;
					} else {
						nH = fixSize;
						nW = fixSize*fixWidth/fixHeight;
					}
					image.width = nW;
					image.height = nH;
				},
				
				showImage: function() {
					Oy.scaleImage(this, Oy.minSize);
					var nH = this.height;
					var nW = this.width;
					var index = this.id;
					var fx = Oy.getFx(Oy.limit, Oy.range.shift());
					var opacity = !Oy.zoomIn ? 1 : 0;
					var display = !Oy.zoomIn ? "block" : "none";
					jQuery(this).addClass("loaded")
					.css({
						visibility: 'visible',
						opacity: opacity,
						display: display,
						zIndex: 9,
						left: 300*fx.x - nW/2 + "px",
						top: 200*fx.f2 + 200*fx.delta - nH/2 + "px"
					});
					
				},
        removeImage: function () {
          var R = document.getElementById("r");
          R.innerHTML = "";
        },
        showOnclick: function (nId) {
          Oy.zoomIn = true;
					Oy.process = true;
					var showed = jQuery("#r img.loaded").css({opacity: 1, display: 'block'});
					var len = showed.length, fx, img, nW, nH;
					var newRange = Oy.getRange(len);
					for (var i = 0; i < len; ++i) {
						img = showed[i];
						nH = img.height;
						nW = img.width;
						
						if (img.id == nId) {
							if (img.width > img.height) {
								nW = Oy.maxSize;
								nH = Oy.maxSize * img.height/img.width;
							} else {
								nH = Oy.maxSize;
								nW = Oy.maxSize * img.width/img.height;
							}
							
							jQuery(img).css({
								zIndex: 1,
							}).animate(
								{
									height: nH,
									width: nW,
									top: -nH/2 - 6,
									left: -nW/2 - 6,
								},
								{
									complete: function() {
										Oy.timer = setTimeout(Oy.closeImage, 5000);
										Oy.process = false;
									}
								}
							);
							
							continue;
						}
						
						if (img.width > img.height) {
							nW = Oy.minSize;
							nH = Oy.minSize * img.height/img.width;
						} else {
							nH = Oy.minSize;
							nW = Oy.minSize * img.width/img.height;
						}
						
						fx = Oy.getFx(len, newRange.shift());
						jQuery(img)
						.css({zIndex: 9})
						.animate({
							height: nH,
							width: nW,
							left: 300*fx.x - nW/2 + "px",
							top: (i%2 == 0 ? 200*fx.f2 : 200*fx.f1) - nH/2 + "px"
						});
					}
        },
				clickOnImage: function(elm) {
					setInnerHTML(pageInfo);
					Oy.timeShow = new Date().getTime();
					if(elm && elm.id) {
						this.id = elm.id;
					}
					if (Oy.process) {
            Oy.closeImage();
          }
					clearTimeout(Oy.timer);
					if (this.id == Oy.current) {
						Oy.closeImage();
						return;
					}
					Oy.current = this.id;
				  Oy.showOnclick(Oy.current);
				
				},
				closeImage: function() {
					Oy.timeShow = new Date().getTime();
					var showed = jQuery("#r img").css({display: "block", opacity: 1});
					var len = showed.length, fx, img, nW, nH;
					var newRange = Oy.getRange(len);
					Oy.process = true;
					for (var i = 0; i < len; ++i) {
						img = showed[i];
						nH = img.height;
						nW = img.width;
						fx = Oy.getFx(len, newRange.shift());
						
						if (img.id == Oy.current) {
							if (img.width > img.height) {
								nW = Oy.minSize;
								nH = Oy.minSize * img.height/img.width;
							} else {
								nH = Oy.minSize;
								nW = Oy.minSize * img.width/img.height;
							}
							jQuery(img).animate(
								{
									height: nH,
									width: nW,
									left: 300*fx.x - nW/2 + "px",
									top: 200*fx.f2 + 200*fx.delta	- nH/2 + "px"
								},
								{
									duration: 700,
									complete: function() {
										Oy.current = null;
										Oy.zoomIn = false;
										Oy.process = false;
									}
								}
							);
						} else {
							jQuery(img).css('z-index', 9)
							.animate({
								left: 300*fx.x - nW/2 + "px",
								top: 200*fx.f2 + 200*fx.delta	- nH/2 + "px"
							});
						}
					}
				},
        render: function() {
					if (Oy.index < Oy.limit) {
						Oy.timeShow = new Date().getTime();
						Oy.index ++;
						var img = jQuery("<img />").attr({
							id: Oy.index,
							src: getIMGSRC(Oy.index)
						}).load(Oy.showImage).click(Oy.clickOnImage).appendTo("#r");
						setTimeout(Oy.render, 200);
						setInnerHTML(inn + "<br/> ^^ Vui lòng đợi quá trình load ảnh hoàn thành ^^ <b>" + Math.round((Oy.index/Oy.limit)*100) + "%</b>");
					}
				}
				
			}
			
			jQuery(window).resize(function() {
				Oy.cY =	jQuery(window).height()/2;
				Oy.cX = jQuery(window).width()/2;
				jQuery("#r").css({
					top: Oy.cY,
					left: Oy.cX
				});
			});


			jQuery(window).load(
        Oy.render(),
        function autoShow() {
				  var t = (new Date().getTime()) - Oy.timeShow;
				  if(Oy.autoShow && t > Oy.timeOut)	{
					  var id = 1;
					  if(Oy.isRandom) {
						  id = Math.floor(Math.random()*(Oy.limit))+1;
					  } else {
					    if(CACHE == 0) {
						    NEXT = Math.floor(Math.random()*(Oy.limit-1));
					    } else {
						    ++NEXT;
                if(NEXT > Oy.limit*CRPAGE) {
                  if(CRPAGE < MAXPAGE) {
                     CRPAGE = CRPAGE + 1;
                  } else {
                     CRPAGE = 1;
                     NEXT = 1;
                  }
                  Oy.removeImage();
                  Oy.index = 0;
                  Oy.render();
                }
              }
              id = NEXT;
					  }
            CACHE = 1;
					  setTimeout("showImageX('"+id+"')", 100);
				  }
				  setTimeout(autoShow, 1000);
        }

      );
			
			jQuery(function() {
				if (!Oy.cX || !Oy.cY) {
					jQuery(window).resize();
				}
				Oy.range = Oy.getRange(Oy.limit);
				for (var i = 1; i <= Oy.limit; ++i) {
					var img = new Image();
					img.src = getIMGSRC(i);
				}

			});

	function getKeynum(event) {
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
	}
	function calculateKey(event) {
		var keynum = getKeynum(event);
		var eventHandler = '';
		if(keynum == 37){
			eventHandler = 'onLeftArrow' ;
		} else if(keynum == 39){
			eventHandler = 'onRightArrow' ;
		} else if(keynum == 38){
			eventHandler = 'onUpArrow' ;
		} else if(keynum == 40){
			eventHandler = 'onDownArrow' ;
		} else if(keynum == 36){
			eventHandler = 'onHome' ;
		} else if(keynum == 35){
			eventHandler = 'onEnd' ;
		}
		var show = false;
		if(eventHandler == 'onLeftArrow') {
			--NEXT;
			if(NEXT == 0) NEXT = LENGTH;
			show = true;
		}
		if(eventHandler == 'onRightArrow') {
			++NEXT;
			if(NEXT == (LENGTH + 1)) NEXT = 0;
			show = true;
		}
		if(eventHandler == 'onHome') {
			NEXT = LENGTH;
			show = true;
		}
		if(eventHandler == 'onEnd') {
			NEXT = 1;
			show = true;
		}
		if(show == true) {
      if(NEXT > Oy.limit*CRPAGE) {
        if(CRPAGE < MAXPAGE) {
           CRPAGE = CRPAGE + 1;
        } else {
           CRPAGE = 1;
           NEXT = 1;
        }
        Oy.removeImage();
        Oy.index = 0;
        Oy.render();
      }

			setTimeout("showImageX('" +NEXT+"')", 200);
		}
	}

  function showImageX(id) {
    var img = document.getElementById(String(id));
		if(img) {
			Oy.clickOnImage(img);
		}
  }

	function addOnkeyDown() {
		document.documentElement.onkeydown = calculateKey;
	}
addOnkeyDown();
