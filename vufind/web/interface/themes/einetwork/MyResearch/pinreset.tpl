<div id="loginHome">
{literal}
<script type="text/javascript">
	$(document).ready(function() {
	    $('input[title]').each(function(i) {
		if (!$(this).val()) {
		    $(this).val($(this).attr('title'));
		}
		$(this).focus(function() {
		    if ($(this).val() == $(this).attr('title')) {
			$(this).val('');
		    }
		    if($(this).attr('id')=='pin'){
			$('#pin').get(0).type = 'password';
		    }
		});
		$(this).blur( function() {
		    if ($(this).val() == '') {
			$(this).val($(this).attr('title'));
			$('#pin').get(0).type='text';
		    }
		});
	    });
	});
</script>
{/literal}	
<div id="page-content" class="content">
	<div class="loginHome-left"></div>
	<div class="loginHome-center">
		<p>Please enter your 14 digit library card number.   An email from helpdesk@einetwork.net will be sent to the email address in your patron record
		with a link to reset your PIN.</p><p>If you don't have an email address on file, please contact your library staff to assign one to your record.</p>
		<div class="login">
			<form id="pinresetform" class="getacard" method="POST" action="{$path}/MyResearch/PinReset">
				<div class="title">Library Card number for PIN Reset</div>
					<div id="barcode">
						<div>
							<input name="barcode" type="text" class="text"/>
						</div>
					</div>
				</div>
				<div class="pinresetform-button">
					<input class="button" type="submit" name="submit" value="Request PIN Reset" alt='{translate text="Login"}' />
				</div>
			</form>
		</div>
	<div>
	<div class="loginHome-right"></div>
</div>