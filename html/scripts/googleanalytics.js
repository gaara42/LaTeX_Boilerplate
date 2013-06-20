var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-27956746-1']);
_gaq.push(['_trackPageview']);

(function() {
	var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

function googleA(){
	_gaq.push(['_trackPageview']);
}

// Add listeners for when users leave the page.
if(window.onpagehide || window.onpagehide === null){
	window.addEventListener('pagehide', googleA, false);
}else{
	window.addEventListener('unload', googleA, false);
}
window.onbeforeunload = function(){
   googleA();
}
window.addEventListener("beforeunload", function(e){
   googleA();
}, false);