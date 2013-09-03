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
				pinReg = /^[0-9]{0,8}$/;
			    {/literal}{*pinReg=/^[0-9]\d{3}$/;*}{literal}
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
    <script type="text/javascript" src="js/ei_js/jquery.nivo.slider.js"></script>
    <script type="text/javascript">
    $(window).load(function() {
        $('#slider').nivoSlider();
    });
    </script>
{/literal}

<div class="row">
	<div class="col-xs-12 col-md-12 splash-message"><h3>Get started by entering your search above.</h3></div>
</div>

<div class="row">
	<div class="col-xs-12 col-md-12">
		<div class="slider-wrapper theme-dark">
			<div id="slider" class="nivoSlider">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider10.png"  data-transition="slideInLeft">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider11.png"  data-transition="slideInLeft">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider12.png"  data-transition="slideInLeft">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider14.png"  data-transition="slideInLeft">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider15.png"  data-transition="slideInLeft">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider16.png"  data-transition="slideInLeft">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider1.png"  data-transition="slideInLeft">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider2.png"  data-transition="slideInLeft">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider3.png"  data-transition="slideInLeft">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider4.png"  data-transition="slideInLeft">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider5.png"  data-transition="slideInLeft">
				<img src="/interface/themes/einetworknew/images/Art/Slider/slider6.png"  data-transition="slideInLeft">
			    <img src="/interface/themes/einetworknew/images/Art/Slider/slider7.png"  data-transition="slideInLeft">
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-xs-6 col-md-6"><a onclick='getAccountSetting()' class="btn btn-default pull-right"><strong>I have a Library Card</strong></a></div>
	<div class="col-xs-6 col-md-6"><a href="{$path}/MyResearch/GetCard" class="btn btn-default"><strong>I need a Library Card</strong></a></div>
</div>