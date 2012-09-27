/* SizeWatcher, by Arjan Eising 2012. License: MIT. https://github.com/arjaneising/SizeWatcher */
(function(){var e,t;t=function(){return"getElementsByClassName"in document};if(t()){Function.prototype.swBindContext=function(){var e,t,n,r,i,s;t=this;r=arguments[0];n=[];for(e=i=1,s=arguments.length;1<=s?i<=s:i>=s;e=1<=s?++i:--i)n.push(e);return function(e){n.push(e);n.reverse();return t.apply(r,n)}};HTMLElement.prototype.swAddClass=function(e){if((" "+this.className+" ").indexOf(" "+e+" ")===-1)return this.className+=" "+e};HTMLElement.prototype.swRemoveClass=function(e){var t;t=new RegExp("(^|\\s)"+e+"(\\s|$)","i");return this.className=this.className.replace(t," ").replace(/^\s+|\s+$/g,"")}}e=function(){function e(e,n){var r,i;this.container=e!=null?e:document;n==null&&(n={});this.doNothing=!t();if(this.doNothing)return!1;this.resizeMethod=this.resize.swBindContext(this);window.addEventListener("resize",this.resizeMethod,!1);this.resizeTimeout=null;this.breakpoints=[];typeof this.container=="string"&&(this.container=document.querySelector(this.container));this.timerTimeout=(r=n.timerTimeout)!=null?r:25;this.boxSize=(i=n.boxSize)!=null?i:"auto"}e.prototype.breakpoint=function(e,t,n){n==null&&(n={});if(this.doNothing)return!1;this.breakpoints.push({from:e,to:t,options:n,prevTrue:!1});return this.reallyResize.call(this,this.breakpoints.length-1)};e.prototype.destroy=function(){delete this.doNothing;delete this.resizeTimeout;delete this.breakpoints;window.removeEventListener("resize",this.resizeMethod,!1);return delete this.resizeMethod};e.prototype.trigger=function(){return this.doNothing?!1:this.reallyResize.call(this)};e.prototype.resize=function(){if(this.doNothing)return!1;this.resizeTimeout&&clearTimeout(this.resizeTimeout);return this.resizeTimeout=setTimeout(this.reallyResize.swBindContext(this),this.timerTimeout)};e.prototype.reallyResize=function(e){var t,n,r,i,s,o,u,a,f,l,c,h,p,d,v,m,g,y,b,w,E,S,x,T,N,C,k;e==null&&(e=!1);if(this.doNothing)return!1;this.boxSize==="border-box"||this.boxSize==="auto"&&this.container.nodeName.toLowerCase()==="body"?n=this.container.offsetWidth:n=parseInt(window.getComputedStyle(this.container,null).getPropertyValue("width"),10);x=this.breakpoints;for(s=p=0,g=x.length;p<g;s=++p){t=x[s];if(e&&s!==e)continue;a=!1;l=!1;t.from<=n&&n<t.to&&(a=!0);if(a&&!t.prevTrue){l=!0;(T=t.options.enter)!=null&&T.call(document,this.container,n);t.options.className!=null&&this.container.swAddClass(t.options.className)}if(!a&&t.prevTrue){l=!0;(N=t.options.leave)!=null&&N.call(document,this.container,n);t.options.className!=null&&this.container.swRemoveClass(t.options.className)}if(!l)continue;this.breakpoints[s].prevTrue=a;if(t.options.move!=null&&a){C=t.options.move;for(o=d=0,y=C.length;d<y;o=++d){f=C[o];h=f.to==="this"?this.container:this.container.querySelector(f.to);i=this.container.querySelectorAll(f.selector);for(u=v=0,b=i.length;v<b;u=++v){r=i[u];f.before!=null?h.insertBefore(r,h.querySelector(f.before)):f.after!=null?h.insertBefore(r,h.querySelector(f.after).nextSibling):h.appendChild(r)}}}if(t.options.order!=null&&a){k=t.options.order;for(o=m=0,w=k.length;m<w;o=++m){c=k[o];i=this.container.querySelectorAll(c);for(u=S=0,E=i.length;S<E;u=++S){r=i[u];if(c.indexOf(!1)&&r.parentNode!==this.container)continue;this.container.appendChild(r)}}}}};return e}();window.SizeWatcher=e}).call(this);