(function($){
	resetTimer();
})(jQuery);
var timer1, timer2;
//move view back to top to see popup
function resetTimer(){
	hideLightbox();
    clearTimeout(timer1);
    clearTimeout(timer2);
    var wait=5;
    timer1=setTimeout("alertUser()", (60000*wait));
    timer2=setTimeout("logout()", 70000*wait);
}

function alertUser(){
	
	var message = "<p>Attention! Your catalog session is about to expire if you don't click \"Continue\".</p>";
	message += "<button class='btn btn-primary' onclick='resetTimer()'>Continue</button> <button class='btn btn-default' onclick='logout()'>Exit</button>";

	lightbox(message);

}
function logout(){
	//Redirect to logout page
	window.location = path + "/MyResearch/Logout";
}