<div onmouseup="this.style.cursor='default';" id="popupboxHeader" class="popupHeader">
	{translate text='Login to your account'}
	<span><img src="/interface/themes/einetwork/images/closeHUDButton.png" class="close-button" style="float:right" onclick="hideLightbox()"></span>
</div>
<div id="popupboxContent" class="popupContent">
	<div id='ajaxLoginForm'>
		<form method="post" action="{$path}/MyResearch/Home" id="loginForm" onsubmit="processAjaxLogin();return false">
			<table>
				<tr class="popupLable">
					<td>{translate text='Username'}</td>
				</tr>
				<tr>
					<td><input type="text" name="username" id="username" value="{$username|escape}" size="15" class="form-control login-form-control"/></td>
				</tr>
				<tr class="popupLable">
					<td>{translate text='Password'}</td>
				</tr>
				<tr>
					<td><input type="password" name="password" id="password" size="15" class="form-control login-form-control"/></td>
				</tr>
				{*<tr style="margin-top:5px;">
					<td><input type="checkbox" class="form-control" id="showPwd" name="showPwd" onclick="return pwdToText('password')"/><label for="showPwd">{translate text="Reveal Password"}</label></td>
				</tr>*}
				{if !$inLibrary}
					<tr>
						<td><input class="form-control" type="checkbox" id="rememberMe" name="rememberMe"/><label for="rememberMe">{translate text="Remember Me"}</label></td>
					</tr>
				{/if}
				<tr>
					<td><a style="color:#9999FF" href="/MyResearch/PinReset">I forgot or don't have my pin</a></td>
				</tr>
				<tr>
					<td><input type="submit" class="btn btn-warning pull-right" name="submit" value="Login" style="margin-right:-265px" /></td>
				</tr>

				{if $comment}
					<tr>
						<td><input type="hidden" name="comment" name="comment" value="{$comment|escape:"html"}"/></td>
					</tr>
				{/if}
		</table>			
		</form>
	</div>
	<script type="text/javascript">$('#username').focus();</script>
</div>