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
		<h2>Wish Lists</h2>
		<h1><span id="wishTitle">{$listTitle}</span>&nbsp;<span style="font-size: 14px;">(<span style="color:#256292;cursor: pointer;" onclick="ajaxLightbox('/List/ListEdit?id={$wishListID}&source=VuFind&lightbox&method=editList',false,false,'450px',false,'200px'); return false;">edit</span>)</span></h1>
		<span><input type="button" value="Move All Physical Items to Book Cart" onclick="saveAllToBookCart()" class="button"></span>
		<span  style="margin-left:10px;"><input type="button" value="Delete This Wish List" onclick="getDeleteList('{$wishListID}')" class="button"></span>
		{if $pageLinks.all}<div class="pagination">{$pageLinks.all}</div>{/if}
	{/if}
	{if $pageType eq 'BookCart'}
	<div class="resulthead" style="font-size:16px;height:30px">
		
			{if count($recordSet)>1}
				Items in your book cart
			{elseif count($recordSet) == 1}
				Item in your book cart
			{else}
				Your book cart is empty
			{/if}
		
	</div>
	{/if}
	
	{if $pageType eq 'BookCart'}
	<form name='placeHoldForm' id='placeHoldForm' action="{$url}/MyResearch/HoldMultiple" method="post">
	<div>
			{if $holdDisclaimer}
				<div id="holdDisclaimer">{$holdDisclaimer}</div>
			{/if}
			
	    <div id="loginFormWrapper" style="border-bottom-color: rgb(238,238,238);border-bottom-style: solid;border-bottom-width: 1px;padding-bottom: 10px;padding-left: 2px;width: 638px;padding-top: 0px">
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
			<div style="margin-top:15px;padding-left:5px;text-align: left;margin-bottom:15px"> <span style="margin-right:15px;font-size:15px">{translate text="Pickup Location"}: </span>
			 <span class='loginField'>
			 <select name="campus" id="campus" style="width:260px">
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
			 {if $showHoldCancelDate == 1}
			       <div id='cancelHoldDate'><b>{translate text="Automatically cancel this hold if not filled by"}:</b>
			       <input type="text" name="canceldate" id="canceldate" size="10">
			       <br /><i>If this date is reached, the hold will automatically be cancelled for you.  This is a great way to handle time sensitive materials for term papers, etc. If not set, the cancel date will automatically be set 6 months from today.</i>
			       </div>
			 {/if}
			</div>
	        </div>
	        {if $pageLinks.all}<div class="pagination">{$pageLinks.all}</div>{/if}
		{if count($recordSet)>0}
			<div class='loginFormRow'>
			<input type="hidden" name="holdType" value="hold"/>
			</div>
		{/if}
	      </div>
	      </div>
	</div>
	</form>
	{/if}
      {* End Listing Options *}

      {if $subpage}
        {include file=$subpage}
      {else}
        {$pageContent}
      {/if}

      {if $prospectorNumTitlesToLoad > 0}
        <script type="text/javascript">getProspectorResults({$prospectorNumTitlesToLoad}, {$prospectorSavedSearchId});</script>
      {/if}
      {* Prospector Results *}
      <div id='prospectorSearchResultsPlaceholder'></div>
        
      {if $pageLinks.all}<div class="pagination">{$pageLinks.all}</div>{/if}
      <b class="bbot"><b></b></b>
    </div>
    {* End Main Listing *}
  </div>
  {*right-bar template*}
  {include file="ei_tpl/right-bar.tpl"}
</div>


