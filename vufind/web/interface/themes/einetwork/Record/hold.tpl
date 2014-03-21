<script type="text/javascript" src="{$path}/js/jquery.selectric.js"></script>
<link rel="stylesheet" type="text/css" href="{$path}/interface/themes/einetwork/css/selectric.css">
{literal}
<script type="text/javascript">

	$(document).ready(function() {

		$('#placeHoldForm').submit(function(){

			if ($('#campus').val() == ''){
				alert('Please select a pickup location.');
				return false;
			}

		})

	});

	$(function(){
		$('#campus').selectric();
	});

</script>

<style>
{/literal}

{php}

$bold_count = $this->get_template_vars('preferred_count') + 1;

$i=0;
while ($i < $bold_count){

	$i++;

	if ($i < $bold_count){
		echo '.selectricItems li:nth-child(' . $i . '),';
	} else {
		echo '.selectricItems li:nth-child(' . $i . ')';
	}

	
}
{/php}
{literal}
{
	font-size:14px;
	font-weight: bolder;
}

</style>

{/literal}

{strip}

<script type="text/javascript" src="{$path}/services/Record/ajax.js"></script>

<div id="page-content" class="content">
	<div id="left-bar">
	{if $sideRecommendations}
		{foreach from=$sideRecommendations item="recommendations"}
		{include file=$recommendations}
		{/foreach}
	{/if}
	</div>
	<div id="main-content">
		<div class="resulthead" style="margin-bottom: 25px;">
			<h3>{translate text='Place a Hold'}</h3>
		</div>
		{if $preferred_message != ''}
			<div class="resulthead preferred-message" style="margin-bottom: 25px;">
				<p>{$preferred_message}</p>
			</div>
		{/if}
		<form id='placeHoldForm' name='placeHoldForm' action="{$path}/Record/{$id|escape:"url"}/Hold" method="post">
			<div style="margin-left: 20px">
				<div id="loginFormWrapper">
					{if (!isset($profile)) }
						You have been logged out. Please search and request item again.
					{/if}
					<div id='holdOptions' {if (!isset($profile)) }style='display:none'{/if}>
						<div style="display:inline">
							<span style="display: inline-block;margin:10px 20px 0 0;vertical-align:top">{translate text="I want to pick this up at"}:</span>
						</div>
						<div style="display:inline-block;">
							<select name="campus" id="campus">
								{if $preferred_count < 1}
									<option value=""></option>
								{/if}
								{if count($pickupLocations) > 0}
									{foreach from=$pickupLocations item=location}
										<option value="{$location->code}" {if $location->selected == "selected"}selected="selected"{/if}>{$location->displayName}</option>
									{/foreach}
								{else} 
									<option>placeholder</option>
								{/if}
							</select>
						</div>
						<div style="display:inline">
							<span style="display: inline-block;margin:-5px 20px 0 0;vertical-align:top">
								<input type="submit" class="button" name="submit" id="requestTitleButton" value="{translate text='Request This Title'}" {if (!isset($profile))}disabled="disabled"{/if}/>
							</span>
						</div>
						<div class='loginFormRow'>
							<input type="hidden" name="type" value="hold"/>
							<input type="checkbox" style="margin-right: 0px" name="autologout" /> Log me out after requesting the item. 
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	{include file="ei_tpl/right-bar.tpl"}
</div>
{/strip}