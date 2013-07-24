<div id="record{$summId|escape}" class="econtent-resultsList">
<!--	<div class="selectTitle">
		<input type="checkbox" name="selected[econtentRecord{$summId|escape:"url"}]" id="selectedEcontentRecord{$summId|escape:"url"}" {if $enableBookCart}onclick="toggleInBag('econtentRecord{$summId|escape:"url"}', '{$summTitle|regex_replace:"/(\/|:'\")$/":""|escape:"javascript"}', this);"{/if} />&nbsp;
	</div>
-->	
	<div class="imageColumn"> 
		{if !isset($user->disableCoverArt) ||$user->disableCoverArt != 1}	
		<div id='descriptionPlaceholder{$summId|escape}' style='display:none'></div>
		<a href="{$path}/EcontentRecord/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{$summId|escape:"url"}">
		<img src="{$bookCoverUrl}" class="listResultImage" alt="{translate text='Cover Image'}"/>
		</a>
		{/if}
		{* Place hold link *}
		<div class='requestThisLink' id="placeEcontentHold{$summId|escape:"url"}" style="display:none">
			<a href="{$path}/EcontentRecord/{$summId|escape:"url"}/Hold"><img src="{$path}/interface/themes/default/images/place_hold.png" alt="Place Hold"/></a>
		</div>
		
		{* Checkout link *}
		<div class='checkoutLink' id="checkout{$summId|escape:"url"}" style="display:none">
			<a href="{$path}/EcontentRecord/{$summId|escape:"url"}/Checkout"><img src="{$path}/interface/themes/default/images/checkout.png" alt="Checkout"/></a>
		</div>
		
<!--		{* Access online link *}
		<div class='accessOnlineLink' id="accessOnline{$summId|escape:"url"}" style="display:none">
			<a href="{$path}/EcontentRecord/{$summId|escape:"url"}/Home?detail=holdingstab#detailsTab"><img src="{$path}/interface/themes/default/images/access_online.png" alt="Access Online"/></a>
		</div>
-->		{* Add to Wish List *}
		<div class='addToWishListLink' id="addToWishList{$summId|escape:"url"}" style="display:none">
			<a href="{$path}/EcontentRecord/{$summId|escape:"url"}/AddToWishList"><img src="{$path}/interface/themes/default/images/add_to_wishlist.png" alt="Access Online"/></a>
		</div>
	</div>

<div class="resultDetails">
	<div class="result_middle">
	<div class="resultItemLine1">
	<a href="{$path}/EcontentRecord/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title">{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:100:"..."|highlight:$lookfor}{/if}</a>
	{if $summTitleStatement}
		<div class="searchResultSectionInfo">
			{$summTitleStatement|regex_replace:"/(\/|:)$/":""|truncate:100:"..."|highlight:$lookfor}
		</div>
		{/if}
	</div>

	<div class="resultItemLine2">
		{if $summAuthor}
			{translate text='by'}
			{if is_array($summAuthor)}
				{foreach from=$summAuthor item=author}
					<a href="{$path}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
				{/foreach}
			{else}
				<a href="{$path}/Author/Home?author={$summAuthor|escape:"url"}">{$summAuthor|highlight:$lookfor}</a>
			{/if}
		{/if}

		{if $summDate}
			<div>
				{if $summDate.0|escape|count_characters == 4 }
					{$summDate.0|escape}
				{else}
					{* Some Overdrive Items don't have a bib record and will show up as 01/01/0001 - which date_format turns into '1'.  Any year less than 10 gets hidden.*}
					{if $summDate.0|date_format:"%Y"|count_characters > 1 }{$summDate.0|escape|date_format:"%Y"}{/if}
				{/if}
			</div>
		{/if}

	</div>
	
	{include file="/usr/local/VuFind-Plus/vufind/web/interface/themes/einetwork/ei_tpl/formatType.tpl"}

	{if $source != "OverDrive"}
		<div id="availableOnline">
			<span>
			<img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Available.png" alt="Available"/>
			</span>			
			{if $sourceUrl }
			<a style="cursor:pointer" class="overdriveAvailable" onclick="window.location.href='{$sourceUrl}'">Available Online</a>
			{else}
			<a style="cursor:pointer" class="overdriveAvailable" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}#links'">Available Online</a>
			{/if}			
		</div>
	{/if}
	
	<div id = "holdingsEContentSummary{$summId|escape:"url"}" class="holdingsSummary">
		<div class="statusSummary" id="statusSummary{$summId|escape:"url"}">
			<span class="unknown" style="font-size: 8pt;">{translate text='Loading'}...</span>
		</div>
	</div>
	</div>
	
	<div id ="searchStars{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="resultActions">
    {if $pageType eq 'WishList'}


    <div class="btn-group results-action-btns">
        <button class="btn">Action</button>
        <button class="btn dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</a></li>
        	{if sourceUrl}
        		<li><a href="" onclick="window.location.href='{$sourceUrl}'">Access Online</a></li>
        	{else}
        		<li><a href="" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}#links'">Access Online</a></li>
        	{/if}
        	<li><a href="" onclick="deleteItemInList('{$summId|escape:"url"}','eContent')">Remove</a></li>
        </ul>
    </div>

    {elseif $pageType eq 'BookCart'}

    <div class="btn-group results-action-btns">
        <button class="btn">Action</button>
        <button class="btn dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="" onclick="requestItem('{$summId|escape:"url"}','{$wishListID}')">Request Now</a></li>
            <li><a href="" onclick="getSaveToListForm('{$summId|escape:"url"}', 'VuFind'); return false;">Move to Wish List</a></li>
        	<li><a href="" onclick="requestItem('{$summId|escape:"url"}','{$wishListID}')">Find in Library</a></li>
        	<li><a href="" onclick="deleteItemInList('{$summId|escape:"url"}','eContent')">Remove</a></li>
        </ul>
    </div>

    {else}

    <div class="btn-group results-action-btns">
        <button class="btn">Action</button>
        <button class="btn dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</a></li>
            {if $sourceUrl}
            	<li><a href="" onclick="window.location.href='{$sourceUrl}'">Access Online</a></li>
            {else}
            	<li><a href="" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}#links'">Access Online</a></li>
            {/if}
        </ul>
    </div>

    {/if}
</div>
</div>

<script type="text/javascript">
	addRatingId('{$summId|escape:"javascript"}', 'eContent');
	addIdToStatusList('{$summId|escape:"javascript"}', {if strcasecmp($source, 'OverDrive') == 0}'OverDrive'{else}'eContent'{/if});
	$(document).ready(function(){literal} { {/literal}
		resultDescription('{$summId}','{$summId}', 'eContent');
	{literal} }); {/literal}
	
</script>

</div>