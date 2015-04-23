// code to flash the notification center
var NCBG_StartColor, NCBG_EndColor;
var NCBG_LerpStartTime, NCBG_LerpLength, NCBG_FlashInterval, NCBG_FlashIndex;

function flashNotificationCenter(endColor, lerpTime){
    if (NCBG_StartColor == null) {
        // this is dependent on the return value of this css beign in the format 'rgb(x,y,z)'.  if the format of that style changes,
        // this code will need to be updated
        var bgColor = $('.notification-center').css("background-color");
        var pieces = bgColor.split(/[(,)]/);
        NCBG_StartColor = {r:parseInt(pieces[1]), g:parseInt(pieces[2]), b:parseInt(pieces[3])};
    }
    NCBG_EndColor = endColor;
    NCBG_LerpLength = lerpTime;
    NCBG_LerpStartTime = new Date().getTime();
    NCBG_FlashIndex = 0;
    NCBG_FlashInterval = setInterval(changeNotificationCenterBackground, 33);
}

function changeNotificationCenterBackground(){
    var currentTime = new Date().getTime();
    var progress = (currentTime - NCBG_LerpStartTime) / NCBG_LerpLength;
    if (NCBG_FlashIndex % 2) {
        progress = 1 - progress;
    }
    if ((progress >= 1) && !(NCBG_FlashIndex % 2)) {
        progress = 1;
        NCBG_FlashIndex++;
        NCBG_LerpStartTime = currentTime;
    }
    else if ((progress <= 0) && (NCBG_FlashIndex % 2)) {
        progress = 0;
        NCBG_FlashIndex++;
        NCBG_LerpStartTime = currentTime;
        if (NCBG_FlashIndex >= 10) {
            clearInterval(NCBG_FlashInterval);
        }
    }
    $('.notification-center').css('background-color', lerpNCBGColor(progress));
}

function lerpNCBGColor(progress) {
    var newColor = "rgb(" + Math.round(NCBG_StartColor.r + (NCBG_EndColor.r - NCBG_StartColor.r) * progress) +
                     "," + Math.round(NCBG_StartColor.g + (NCBG_EndColor.g - NCBG_StartColor.g) * progress) +
                     "," + Math.round(NCBG_StartColor.b + (NCBG_EndColor.b - NCBG_StartColor.b) * progress) + ")";
    return newColor;
}