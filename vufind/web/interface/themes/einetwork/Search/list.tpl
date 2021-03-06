<!--{literal}
<script type="text/javascript">

$(document).ready(function() {

	$('.selector').qtip({
	    content: {
	        text: 'My simple tooltip'
	    },
	    style: 'tooltip'
	});

});
</script>
{/literal}-->
<script type="text/javascript" src="{$path}/services/EcontentRecord/ajax.js?v3.0"></script>
 <script type="text/javascript" src="/js/ei_js/search.js?v3.0"></script>
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
		{include file=$recommendations}
		{/foreach}
	{/if}


  </div>
  {* End Narrow Search Options *}

  <div id="main-content">
	{if $author_sort_message}
		{literal}
				<script type="text/javascript">
					$(document).ready(function(){
						$("#sort-select option:eq(1)").attr('disabled','disabled');
						$("#sort-select option:eq(2)").attr('disabled','disabled');
					});
				</script>
		{/literal}
		<div class="author-sort-message">
			<p>You must select an author from the filters on the left, before you can sort by<br /><span class="bold">date ascending</span> or <span class="bold">date descending</span>.</p>
		</div>
	{/if}
    <div id="searchInfo">
	<div class="resulthead" style="height:30px; ">
		<div class="yui-u first" style="float:left; width:75%">
		{if $recordCount}
			{translate text='Sort by'}<span><img class="qtip-sort-by help-icon" style="float:left" src="/images/help_icon.png" /></span>
			<select name="sort" onchange="document.location.href = this.options[this.selectedIndex].value;" id="sort-select">
				{foreach from=$sortList item=sortData key=sortLabel}
					<option value="{$sortData.sortUrl|escape}"{if $sortData.selected} selected="selected"{/if}>{translate text=$sortData.desc}</option>
				{/foreach}
			</select>
		{/if}
		{if $spellingSuggestions}
		{/if}
		</div>
		<div style="float:right; width:25%">
			<div class="round-rectangle-button" value="Advanced Search" onclick="window.location.href='/Search/Advanced'" style="float:right; margin-right:10px;">
				{*<span class="resultAction_img_span">
					<img alt="view_details" src="/interface/themes/einetwork/images/Art/ActionIcons/MoreLikeThis.png" class="resultAction_img"/>
				</span> *}
				<div class="resultAction_span" style="padding-top:3px; padding-left:6px;">Advanced Search</div>
			</div>
		</div>
	</div>
	{if $recordCount}
		{$recordCount}{translate text=" items found for"}{/if}
	{if $searchType == 'basic'}<span style="font-style:italic; font-weight:570;">'{$lookfor|escape:"html"}'</span>{/if}
	{if $searchType == 'advanced'}
			<span style="font-style:italic; font-weight:570;">"{$lookfor|escape:"html"}"</span>
			<a  style="margin-left: 10px" href="{$path}/Search/Advanced?edit={$searchId}" class="small">{translate text="Edit this Advanced Search"}</a>
	{/if}

	{if $pageLinks.all}<span class="pagination" style="border-bottom: 0px; padding-bottom:3px; float: right">{$pageLinks.all}</span>{/if}
	<hr></hr>

<!--	<input class="button" style="width: 105px; padding-left: 2px; padding-right: 2px; text-align: center" value="Advanced Search" onclick="window.location.href='/Search/Advanced'">
-->	
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
      
      <div class="searchtools">
        <strong>{translate text='Search Tools'}:</strong>
        <a href="{$rssLink|escape}" class="feed">{translate text='Get RSS Feed'}</a>
        <!-- <a href="{$url}/Search/Email" class="mail" onclick="getLightbox('Search', 'Email', null, null, '{translate text="Email this"}'); return false;">{translate text='Email this Search'}</a> -->
        {if $savedSearch}<a href="{$url}/MyResearch/SaveSearch?delete={$searchId}" class="delete">{translate text='save_search_remove'}</a>{else}<a href="{$url}/MyResearch/SaveSearch?save={$searchId}" class="add">{translate text='save_search'}</a>{/if}
        <a href="{$excelLink|escape}" class="exportToExcel">{translate text='Export To Excel'}</a>
      </div>
    </div>
    {* End Main Listing *}
  </div>
  {*right-bar template*}
  {include file="ei_tpl/right-bar.tpl"}
</div>