<div id="loginHome">
{literal}
<script type="text/javascript">
	$(document).ready(function() {
		$('input[title]').each(function(i) {
			if ($(this).val() === "") {
			    $(this).val($(this).attr('title'));
			}
		});
		$('#loginForm').submit(function(){
			var pin=$("#pin").val();
			{/literal}{* var pinReg=/^[0-9]\d{3}$/; *}{literal}
			var pinReg = /^[0-9]{0,8}$/;
			var card=$("#card").val();
			var cardReg=/^[1-9]\d{13}$/;
			var cardReg1=/^[1-9]\d{6}$/;
			if(card==""||!card||pin==""||!pin){
				$('#cardError').html('&nbsp;');
					return false;
			}else{
				if((cardReg.test(card)||cardReg1.test(card))&&pinReg.test(pin)){
					$('#cardError').html('&nbsp;');
					return true;
				}else{
					if(!(cardReg.test(card)||cardReg1.test(card))){
						$('#cardError').text('*please enter a valid 14 or 7 digit card number');
					}
					if(!pinReg.test(pin)){
						$('#pinError').text('*please enter a valid 4 digit PIN');
					}
					cardValid=false;
					return false;
				}
			}
		}); 
	    $('#card').focusout(function(){
			var card=$(this).val(),
			    cardReg=/^[1-9]\d{13}$/;
			cardReg1=/^[1-9]\d{6}$/;
			if(card == ""){
				$(this).val($(this).attr('title'));
				$('#cardError').html('&nbsp;');
				return false;
			}else{
				if(cardReg.test(card)||cardReg1.test(card)){
					$('#cardError').html('&nbsp;');
					return true;
				}else{
					$('#cardError').text('*please enter a valid 14 or 7 digit card number');
					cardValid=false;
					return false;
				}
			}
	    });
    	$('#card').focusin(function(){
    		if($(this).val() == $(this).attr('title')){
    			$(this).val("");
    		}
    	});
	    $('#pin').focusout(function(){
			var pin=$(this).val(),
			   {/literal} {* pinReg=/^[0-9]\d{3}$/; *}{literal}
			    pinReg = /^[0-9]{0,8}$/;
			if(pin==""){
				$('#pinError').html('&nbsp;');
				$(this).val($(this).attr('title'));
				$(this).get(0).type = "text";
				return false;
			}else{
				if(!pinReg.test(pin)){
					$('#pinError').text('*please enter a valid 4 digit PIN');
					pinValid=false;
					return false;
				}else{
					$('#pinError').html('&nbsp;');
					return true;
				}
			}
		});
		$('#pin').focusin(function(){
			var pin=$(this).val();
			if(pin == $(this).attr('title')){
				$(this).val("");
				$(this).get(0).type = "password";
			}
		});
		$('[placeholder]').parents('form').submit(function() {
			$(this).find('[placeholder]').each(function() {
				var input = $(this);
				if (input.val() == input.attr('placeholder')) {
		 			input.val('');
				}
			});
		});
	});
</script>
{/literal}
	<div class="loginHome-left"></div>
	
	<div class="loginHome-center">
        <p style="color:orange; font-weight:bold;">A new mobile-friendly design is coming soon.  <a href="https://librarycatalog.einetwork.net/MyResearch/ComingSoon">Check it out!</a></p>

		<div class="login">
			<form id="loginForm" action="{$path}/MyResearch/Home" method="post" autocomplete="on">
				<div><b>I have a Library Card</b></div>
				{if $message}
					<div class="error">Sorry, the account information you entered does not match our records. Please check and try again.</div>
				{/if}
				<div id="email">
					Library Card Number:
					<input id="card" class="text" type="text" name="username" value="{$username|escape}" maxlength="14"/>
					<div id="cardError">&nbsp;</div>
				</div>
				<div id="password">
					4 digit PIN number:
					<input id="pin" class="text" type="password" name="password" maxlength="8"/>
					<div id="pinError">&nbsp;</div>
					<div><a href="/MyResearch/PinReset"> I forgot or want to change my PIN.</a></div>
				</div>
				<div>
					<input class="button" type="submit" name="submit" value="Login" alt='{translate text="Login"}' />
				</div>
			</form>
		</div>
		<div class="register">
			<div><a href="{$path}/MyResearch/GetCard"><b>I need a Library Card</b></a></div>
			<div id="description">
				With a free catalog account, you can request items directly from the catalog, view your past searches and get personalized recommendations for items you might like.
			</div>
			<div>
				<a href="{$path}/MyResearch/GetCard">
					<input class="button" type="submit" name="submit" value="Register"/>
				</a>
			</div>
		</div>
	</div>
	<div class="loginHome-right"></div>
</div>
