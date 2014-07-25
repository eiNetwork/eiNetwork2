{literal}
<script type="text/javascript">
	
	$(document).ready(function() {

		$('.limit1').qtip({
		    content: {
		        text: 'Select to limit search results to available materials only'
		    },
		    style: 'tooltip',
		    classes: {
			content:'eintooltip'
		    }
		});


		$('.keep1').qtip({
		    content: {
		        text: 'Select to keep left column filters applied on your next search'
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

  	<div class="header-filters-container">

  		<ul class="header-filters">
  			<li><input type="checkbox" checked="checked" /> <span class="header-filter-text">{translate text="basic_search_keep_filters"} <img class="qtip-retain-filters" src="/images/help_icon_white.png" /></span></li>
  			<li><input type="checkbox" checked="checked" /> <span class="header-filter-text">Limit to available <img class="qtip-limit-avail" src="/images/help_icon_white.png" /></span></li>
  		</ul>

  	</div>


    
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

