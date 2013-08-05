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

<div class="row">
	<div class="col-lg-3">

	</div>
	<div class="col-lg-6">
		<p class="notification">We are receiving reports about some users not receiving email notices for upcoming due dates, hold pickups, or overdue items. You may wish to check My Account or contact your local library for this information. Please contact your email provider if you believe you are not receiving these notices.</p>

		<div class="row">
			<div class="col-lg-6">
				<h4>I have a Library Card</h4>
				<form id="loginForm" action="/MyResearch/Home" method="post" autocomplete="on">
					<div class="form-group">
						<label for="username">Library Card Number</label>
						<div>
							<input id="card" type="text" class="form-control" id="inputEmail" placeholder="Email" name="username" value="{$username|escape}" maxlength="14" />
						</div>
						<div id="cardError">&nbsp;</div>
					</div>
					<div class="form-group">
						<label for="password">4 digit PIN number</label>
						<div>
							<input id="pin" type="password" class="form-control" id="inputPassword" placeholder="Password" name="password">
						</div>
						<div id="pinError">&nbsp;</div>
					</div>
					<div class="form-group">
						<div>
							<input type="submit" name="submit" class="btn btn-default" value="Login" />
						</div>
					</div>
				</form>
			</div>
			<div class="col-lg-6">
				<h4><a href="http://librarycatalog.einetwork.net/MyResearch/GetCard">I need a Library Card</a></h4>
				<p>With a free catalog account, you can request items directly from the catalog, view your past searches and get personalized recommendations for items you might like.</p>
				<a href="http://librarycatalog.einetwork.net/MyResearch/GetCard" class="btn btn-info">Register</a>
			</div>
		</div>

	</div>
	<div class="col-lg-3">

	</div>
</div>