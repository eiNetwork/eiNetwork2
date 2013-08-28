<script type="text/javascript" src="{$path}/services/EcontentRecord/ajax.js"></script>
 <script type="text/javascript" src="/js/ei_js/search.js"></script>
{* Main Listing *}
{if (isset($title)) }
<script type="text/javascript">
	alert("{$title}");
</script>
{/if}


<div class="row">
	<div class="col-xs-3 col-md-3 facets">
		{if $sideRecommendations}
			{foreach from=$sideRecommendations item="recommendations"}
				{include file=$recommendations}
			{/foreach}
		{/if}
	</div>
	<div class="col-xs-6 col-md-6">

		<div class="row">
			<div class="col-xs-5 col-md-5">
				{if $recordCount}
					<div class="input-group">
						<span class="input-group-addon">{translate text='Sort by'}</span>
						<select name="sort" onchange="document.location.href = this.options[this.selectedIndex].value;" class="form-control">
							{foreach from=$sortList item=sortData key=sortLabel}
								<option value="{$sortData.sortUrl|escape}"{if $sortData.selected} selected="selected"{/if}>{translate text=$sortData.desc}</option>
							{/foreach}
						</select>
					</div>
				{/if}

				{if $spellingSuggestions}
				{/if}
			</div>
			<div class="col-xs-7 col-md-7" style="text-align:right">
				<a href="" class="btn btn-default" onclick="window.location.href='/Search/Advanced'">Advanced Search</a>
			</div>
		</div>

		{if $searchType == 'advanced'}
			<div class="row">
				<div class="col-xs-12 col-md-12">
					<span style="font-style:italic; font-weight:570;">"{$lookfor|escape:"html"}"</span>
					<a style="margin-left: 10px" href="{$path}/Search/Advanced?edit={$searchId}" class="small">{translate text="Edit this Advanced Search"}</a>
				</div>
			</div>
		{/if}

		{if $recordCount}
			<div class="row">
				<div class="col-xs-12 col-md-12">
					<div class="items-found">
						{$recordCount}{translate text=" items found for"}{if $searchType == 'basic'} <span style="font-style:italic; font-weight:570;">'{$lookfor|escape:"html"}'</span>{/if}
					</div>
				</div>
			</div>
		{/if}

		<div class="row">
			<div class="col-xs-4 col-md-4">
				
			</div>
			<div class="col-xs-8 col-md-8" style="text-align: right">
				{if $pageLinks.all}
					<ul class="pagination pagination-sm">{$pageLinks.all}</ul>
				{/if}
			</div>
		</div>
		
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

		<div class="row">
			<div class="col-xs-12 col-md-12" style="text-align: right">
				{if $pageLinks.all}
					<ul class="pagination pagination-sm">{$pageLinks.all}</ul>
				{/if}
			</div>
		</div>

		<div class="searchtools">
			<strong>{translate text='Search Tools'}:</strong>
			<a href="{$rssLink|escape}" class="feed">{translate text='Get RSS Feed'}</a>
			<a href="{$url}/Search/Email" class="mail" onclick="getLightbox('Search', 'Email', null, null, '{translate text="Email this"}'); return false;">{translate text='Email this Search'}</a>
			{if $savedSearch}<a href="{$url}/MyResearch/SaveSearch?delete={$searchId}" class="delete">{translate text='save_search_remove'}</a>{else}<a href="{$url}/MyResearch/SaveSearch?save={$searchId}" class="add">{translate text='save_search'}</a>{/if}
			<a href="{$excelLink|escape}" class="exportToExcel">{translate text='Export To Excel'}</a>
		</div>
		{* End Main Listing *}

	</div>
	<div class="col-xs-3 col-md-3">
		 {*right-bar template*}
  		{include file="ei_tpl/right-bar.tpl"}
	</div>
</div>