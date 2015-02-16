<script type="text/javascript" src="{$path}/js/jquery.selectric.js"></script>
<link rel="stylesheet" type="text/css" href="{$path}/interface/themes/einetwork/css/selectric.css">
{literal}
<script type="text/javascript">

	$(document).ready(function() {

		$('#placeHoldForm').submit(function(){

			alert('test')

			if ($('#campus').val() == ''){
				alert('Please select a pickup location.');
				return false;
			}

		})

		$(function(){
			$('#campus').selectric();
		});

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
<script type="text/javascript" src="{$path}/services/EcontentRecord/ajax.js"></script>
{* Main Listing *}
{if (isset($title)) }
<script type="text/javascript">
	alert("{$title}");
</script>
{/if}
<div id="page-content" class="content">
  {* Narrow Search Options *}
  <div id="left-bar">
	{if $sideRecommendations}
		{foreach from=$sideRecommendations item="recommendations"}
		{include file=$recommendations sideFacetSet=false}
		{/foreach}
	{/if}
  </div>
  {* End Narrow Search Options *}

  <div id="main-content">
	<input type="hidden" value="{$wishListID}" id="listId"/>
	<script type="text/javascript" src="/services/List/ajax.js"></script>
    <div id="searchInfo">
	{if $pageType eq 'WishList'}
		<h2>My Lists</h2>
		<h1><span id="wishTitle">{$listTitle}</span>&nbsp;<span style="font-size: 14px;">(<span style="color:#256292;cursor: pointer;" onclick="ajaxLightbox('/List/ListEdit?id={$wishListID}&source=VuFind&lightbox&method=editList',false,false,'450px',false,'200px'); return false;">edit</span>)</span></h1>
		<span><input type="button" value="Move All Physical Items to Book Cart" onclick="saveAllToBookCart()" class="button"></span>
		<span  style="margin-left:10px;"><input type="button" value="Delete This List" onclick="getDeleteList('{$wishListID}')" class="button"></span>
		{if $pageLinks.all}<div class="pagination">{$pageLinks.all}</div>{/if}
		<hr></hr>
	{/if}
	{if $pageType eq 'BookCart'}
	<div class="resulthead" style="font-size:16px;height:30px">
			{if count($recordSet)>5}
				Please note that Book Carts or Lists with more than 1,000 items will not display.
			{elseif count($recordSet) > 1}
				
			{elseif count($recordSet) == 1}

			{else}
				Your book cart is empty
			{/if}
	</div>
	{/if}
	
	{if $preferred_message != ''}
		<div class="resulthead preferred-message-container" style="margin-bottom: 25px;">
			<div class="preferred-message">
				<p>{$preferred_message}</p>
			</div>
		</div>
	{/if}

	{if $pageType eq 'BookCart'}
	<form name='placeHoldForm' id='placeHoldForm' action="{$url}/MyResearch/HoldMultiple" method="post">
	<div>
		<div id="loginFormWrapper" style="border-bottom-color: rgb(238,238,238);border-bottom-style: solid;border-bottom-width: 0px;padding-bottom: 10px;padding-left: 2px;width: 638px;padding-top: 0px">
			{foreach from=$ids item=id}
				<input type="hidden" name="selected[{$id|escape:url}]" value="on" id="selected{$id|escape:url}" class="selected"/>
			{/foreach}
			{if (!isset($profile)) }
				<div id ='loginUsernameRow' class='loginFormRow'>
					<div class='loginLabel'>{translate text='Username'}: </div>
					<div class='loginField'><input type="text" name="username" id="username" value="{$username|escape}" size="15"/></div>
				</div>
				<div id ='loginPasswordRow' class='loginFormRow'>
					<div class='loginLabel'>{translate text='Password'}: </div>
					<div class='loginField'><input type="password" name="password" id="password" size="15"/></div>
				</div>
				<div id='loginSubmitButtonRow' class='loginFormRow'>
					<input id="loginButton" type="button" onclick="GetPreferredBranches('{$id|escape}');" value="Login"/>
				</div>
			{/if}
			<div id='holdOptions' {if (!isset($profile)) }style='display:none'{/if}>
				<div class='loginFormRow'>
					<div style="margin-top:15px;padding-left:5px;text-align: left;margin-bottom:15px">
						<span style="margin-right:15px;font-size:15px">{translate text="Pickup Location"}: </span>
						<div><span class='loginField' style=float:left>
							<select name="campus" id="campus" style="width:260px">
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
						</span>
						<span>
							<input type="button" onclick="requestAllItems('{$wishListID}')" class="button yellow" style="margin-top: 0px;float:right;width:130px;" name="submit" id="requestTitleButton" value="{translate text='Request All'}" {if (!isset($profile))}disabled="disabled"{/if}/>
						</span>
						</div>
					</div>
				</div>
			</div>
			<div></br></div>
		</div>
		{if $pageLinks.all}<div class="pagination" style="bordert-top: 0px; padding-top: 1px; border-bottom: 0px; padding-bottom:3px" >{$pageLinks.all}</div>{/if}
		{if count($recordSet)>0}
			<div class='loginFormRow'>
				<input type="hidden" name="holdType" value="hold"/>
			</div>
		{/if}
		<hr></hr>

	</div>
	</form>
	{/if}

	
      {* End Listing Options *}

      {if $subpage}
        {include file=$subpage}
      {else}
        {$pageContent}
      {/if}
      
      {if $pageLinks.all}</br><div class="pagination">{$pageLinks.all}</div>{/if}
      <b class="bbot"><b></b></b>
    </div>
    {* End Main Listing *}
  </div>
  {*right-bar template*}
  {include file="ei_tpl/right-bar.tpl"}
</div>



