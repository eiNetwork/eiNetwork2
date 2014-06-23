{literal}
<script type="text/javascript">
	$(document).ready(function() {
		/*
		$("#GoButton").hide();
		
		$("#lookfor").focus(function(){
			$("#GoButton").show();
		}).blur(function(){
			$("#GoButton").hide();
		});
		*/
	});
	
	$(document).ready(function() {

	$('.limit1').qtip({
	    content: {
	        text: 'Select to limit serach results to available materials only'
	    },
	    style: 'tooltip',
	    classes: {
		content:'eintooltip'
	    }
	});

});
	
	$(document).ready(function() {

	$('.keep1').qtip({
	    content: {
	        text: 'Select to keep left column filters applied on your next serach'
	    },
	   style: 'tooltip',
	    classes: {
		content:'eintooltip'
	    }
	});

});
</script>
{/literal}

<div class="center-header-middle">
	{*}
	{if $searchType == 'advanced'}
		<a href="{$path}/Search/Advanced?edit={$searchId}" class="small">{translate text="Edit this Advanced Search"}</a> |
		<a href="{$path}/Search/Advanced" class="small">{translate text="Start a new Advanced Search"}</a> |
		<a href="{$url}" class="small">{translate text="Start a new Basic Search"}</a>
		<br />{translate text="Your search terms"} : "<b>{$lookfor|escape:"html"}</b>"
	{else}
	{*}
  <form method="get" action="{$path}/Union/Search" id="searchForm" class="search" onsubmit='startSearch();'>

    <span id="search-label">Search</span>
    <span id="search-type">
	  <select id="search-select" name="basicType">
	    {foreach from=$basicSearchTypes item=searchDesc key=searchVal}
	      <option value="{$searchVal}"{if $searchIndex == $searchVal} selected="selected"{/if}>
		{translate text=$searchDesc}
	      </option>
	    {/foreach}
	  </select>
    </span>
    <span id="for-label">for</span>
    <div>
      <input id="lookfor" class="text" type="text" name="lookfor" value="{$lookfor|escape:"html"}"  />
      <input id="GoButton" class="button" type="submit" value=""/>
    </div>

   {* Do we have any checkbox filters? *}
  {assign var="hasCheckboxFilters" value="0"}
  {if isset($checkboxFilters) && count($checkboxFilters) > 0}
    {foreach from=$checkboxFilters item=current}
      {if $current.selected}
	{assign var="hasCheckboxFilters" value="1"}
      {/if}
    {/foreach}
  {/if}
  {if $filterList || $hasCheckboxFilters}
    <div class="keepFilters">
      <input type="checkbox" checked="checked" onclick="filterAll(this);" /> <font class="keep1" color="white">{translate text="basic_search_keep_filters"}</font>
      <div style="display:none;">
	{foreach from=$filterList item=data key=field}
	  {foreach from=$data item=value}
	    <input type="checkbox" checked="checked" name="filter[]" value='{$value.field}:"{$value.value|escape}"' />
	  {/foreach}
	{/foreach}
	{foreach from=$checkboxFilters item=current}
	  {if $current.selected}
	    <input type="checkbox" checked="checked" name="filter[]" value="{$current.filter|escape}" />
	  {/if}
	{/foreach}
      </div>
    </div>
    
  {/if}
    {php}

      if (strpos($_SERVER['REQUEST_URI'], 'Search', 0) > 0){
        echo '<div class="availFilter"><input name="limit_avail" id="limitToAvail" type="checkbox"> <font class="limit1" color="white">Limit to available</font></div>';
      }

    {/php}
  </form>
    {if false && strlen($lookfor) > 0 && count($repeatSearchOptions) > 0}
    <div class='repeatSearchBox'>
      <label for='repeatSearchIn'>Repeat Search In: </label>
      <select name="repeatSearchIn" id="repeatSearchIn">
        {foreach from=$repeatSearchOptions item=repeatSearchOption}
          <option value="{$repeatSearchOption.link}">{$repeatSearchOption.name}</option>
        {/foreach}
      </select>
      <input type="button" name="repeatSearch" value="{translate text="Go"}" onclick="window.open(document.getElementById('repeatSearchIn').options[document.getElementById('repeatSearchIn').selectedIndex].value)">
    </div>
    {/if}
</div>

<div class="center-header-buttom">&nbsp;</div>

