<script type="text/javascript" src="{$path}/services/EcontentRecord/ajax.js"></script>
 <script type="text/javascript" src="/js/ei_js/search.js"></script>
{* Main Listing *}
{if (isset($title)) }
<script type="text/javascript">
	alert("{$title}");
</script>
{/if}


<div class="row-fluid">
	<div class="span3 facets">
		{if $sideRecommendations}
			{foreach from=$sideRecommendations item="recommendations"}
			{include file=$recommendations}
			{/foreach}
		{/if}
	</div>
	<div class="span6">
		<div class="search-sort">
			{if $recordCount}
				{translate text='Sort by'}
					<select name="sort" onchange="document.location.href = this.options[this.selectedIndex].value;">
						{foreach from=$sortList item=sortData key=sortLabel}
							<option value="{$sortData.sortUrl|escape}"{if $sortData.selected} selected="selected"{/if}>{translate text=$sortData.desc}</option>
						{/foreach}
					</select>
			{/if}
			{if $spellingSuggestions}
			{/if}
		</div>
	
		<a href="" class="btn advanced-search-btn" onclick="window.location.href='/Search/Advanced'" style="float:right; margin-right:10px;">Advanced Search</a>

		{if $searchType == 'advanced'}
			<span style="font-style:italic; font-weight:570;">"{$lookfor|escape:"html"}"</span>
			<a style="margin-left: 10px" href="{$path}/Search/Advanced?edit={$searchId}" class="small">{translate text="Edit this Advanced Search"}</a>
		{/if}

		{if $recordCount}
			<div class="items-found">
				{$recordCount}{translate text=" items found for"}{if $searchType == 'basic'} <span style="font-style:italic; font-weight:570;">'{$lookfor|escape:"html"}'</span>{/if}
			</div>
		{/if}

		{if $pageLinks.all}
			<div class="pagination"><ul>{$pageLinks.all}</ul></div>
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
    
  		{if $pageLinks.all}
			<div class="pagination"><ul>{$pageLinks.all}</ul></div>
		{/if}
  
		<div class="searchtools">
			<strong>{translate text='Search Tools'}:</strong>
			<a href="{$rssLink|escape}" class="feed">{translate text='Get RSS Feed'}</a>
			<a href="{$url}/Search/Email" class="mail" onclick="getLightbox('Search', 'Email', null, null, '{translate text="Email this"}'); return false;">{translate text='Email this Search'}</a>
			{if $savedSearch}<a href="{$url}/MyResearch/SaveSearch?delete={$searchId}" class="delete">{translate text='save_search_remove'}</a>{else}<a href="{$url}/MyResearch/SaveSearch?save={$searchId}" class="add">{translate text='save_search'}</a>{/if}
			<a href="{$excelLink|escape}" class="exportToExcel">{translate text='Export To Excel'}</a>
		</div>
		{* End Main Listing *}
	</div>
	<div class="span3">
		 {*right-bar template*}
  		{include file="ei_tpl/right-bar.tpl"}
	</div>
</div>