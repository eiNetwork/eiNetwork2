<div onmouseup="this.style.cursor='default';" onmousedown="this.style.cursor='move';" id="popupboxHeader" class="header">
  <a onclick="hideLightbox(); return false;" href="">close</a>
  Rate Title
</div>
<div id="popupboxContent" class="content">
  {if $message}<div class="error">You must be logged in first.</div>{/if}
  <div id='loginFormWrapper'>
    <form method="post" action="{$url}/Record/{$id}/Rate" name="loginForm" onSubmit="ratingLogin('{$id}', '{$rating}'); return false;">
      <div>      
        <input type="hidden" name="rating" id="rating" value="{$rating}" />
        <div id='haveCardLabel' class='loginFormRow'>I have a Wake County Library Card</div>
        <div id ='loginUsernameRow' class='loginFormRow'>
          <div class='loginLabel'>{translate text='Username'}: </div>
          <div class='loginField'><input type="text" name="username" id="username" value="{$username|escape}" size="15"/></div>
        </div>
        <div id ='loginPasswordRow' class='loginFormRow'>
          <div class='loginLabel'>{translate text='Password'}: </div>
          <div class='loginField'><input type="password" name="password" id="password" size="15"/></div>
        </div>
        <div id='loginSubmitButtonRow' class='loginFormRow'>
          <input id="loginButton" type="image" name="submit" value="Login" src='{$path}/interface/themes/wcpl/images/login.png' alt='{translate text="Login to your account"}' />
        </div>
      </div>
    </form>
  </div>
  <div id='needACardWrapper'>
    <div id='needCardLabel' class='loginFormRow'>
    <a href="{$path}/MyResearch/GetCard">I need a Wake County Libraries Card</a>
    </div>
    <div class='loginFormRow'>
    <a href="{$path}/MyResearch/GetCard"><img src="wcpl" alt="Get a Library Card" /></a>
    </div>
  </div>
  <div id='retreiveLoginInfo'>
    <div id='emailPinLabel' class='loginFormRow'>
      <a href="{$path}/MyResearch/EmailPin">EMAIL MY PIN</a>
    </div>
  </div>
</div>
