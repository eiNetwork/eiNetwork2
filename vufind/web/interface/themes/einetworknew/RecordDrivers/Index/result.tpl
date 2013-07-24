<div id="record{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="resultsList">
  {*<div class="selectTitle">
  <input type="checkbox" class="titleSelect" name="selected[{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}]" id="selected{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" {if $enableBookCart}onclick="toggleInBag('{$summId|escape}', '{$summTitle|regex_replace:"/(\/|:)$/":""|escape:"javascript"}', this);"{/if} />&nbsp;
</div>*}        
<div class="imageColumn">
    {if $user->disableCoverArt != 1}  
    <div id='descriptionPlaceholder{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}' style='display:none'></div>
    <a href="{$url}/Record/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
    <img src="{$bookCoverUrl}" class="listResultImage" alt="{translate text='Cover Image'}"/>
    </a>
    {/if}
    {* Place hold link *}
</div>

<div class="resultDetails">
  <div class="result_middle">
  <div class="resultItemLine1">
  {if $summScore}({$summScore}) {/if}
	<a href="{$url}/Record/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title">{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:100:"..."|highlight:$lookfor}{/if}</a>
	{if $summTitleStatement}
    <div class="searchResultSectionInfo">
      {$summTitleStatement|regex_replace:"/(\/|:)$/":""|truncate:100:"..."|highlight:$lookfor}
    </div>
    {/if}
  </div>

  <div class="resultItemLine2">
    {if $summAuthor}
      {translate text=''}
      {if is_array($summAuthor)}
        {foreach from=$summAuthor item=author}
          <a href="{$url}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
        {/foreach}
      {else}
        <a href="{$url}/Author/Home?author={$summAuthor|escape:"url"}">{$summAuthor|highlight:$lookfor}</a>
      {/if}
    {/if}
    {if $summCorpAuthor}
      {translate text=''}
      {if is_array($summCorpAuthor)}
        {foreach from=$summCorpAuthor item=corpAuthor}
          <a href="{$url}/Author/Home?author={$corpAuthor|escape:"url"}">{$corpAuthor|highlight:$lookfor}</a>
        {/foreach}
      {else}
        <a href="{$url}/Author/Home?author={$summCorpAuthor|escape:"url"}">{$summCorpAuthor|highlight:$lookfor}</a>
      {/if}
    {/if}
	{if $summDate}
		<div>
			{$summDate.0|escape}
		</div>
	{/if}
  </div>
  
  {* //szheng:commented
  <div class="resultItemLine3">
    {if !empty($summSnippetCaption)}<b>{translate text=$summSnippetCaption}:</b>{/if}
    {if !empty($summSnippet)}<span class="quotestart">&#8220;</span>...{$summSnippet|highlight}...<span class="quoteend">&#8221;</span><br />{/if}
  </div>
  *}
    {include file="/usr/local/VuFind-Plus/vufind/web/interface/themes/einetwork/ei_tpl/formatType.tpl"}
    
  <div id = "holdingsSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="holdingsSummary">
    <div class="statusSummary" id="statusSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
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
            <li><a href="" onclick="window.location.href ='{$url}/Record/{$summId|escape:'url'}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</a></li>
            <li><a href="" {if $enableBookCart}onclick="getSaveToBookCart('{$summId|escape:"url"}','VuFind');return false;"{/if}>Move to Cart</a></li>
            <li><a href="" onclick="deleteItemInList('{$summId|escape:"url"}','VuFind')">Remove</a></li>
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
            <li><a href="" onclick="findInLibrary('{$summId|escape:"url"}',false,'150px','570px','auto')">Find in Library</a></li>
            <li><a href="" onclick="deleteItemInList('{$summId|escape:"url"}','VuFind')">Remove</a></li>
        </ul>
    </div>

    {else}

    <div class="btn-group results-action-btns">
        <button class="btn">Action</button>
        <button class="btn dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="" onclick="window.location.href ='{$url}/Record/{$summId|escape:'url'}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</a></li>
            <li><a href="" {if $enableBookCart}onclick="getSaveToBookCart('{$summId|escape:"url"}','VuFind',this);return false;"{/if}>Add to Cart</a></li>
        </ul>
    </div>

    {/if}
    <script type="text/javascript">
        addRatingId('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}');
        addIdToStatusList('{$summId|escape}');
        $(document).ready(function(){literal} { {/literal}
  	resultDescription('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}','{$summId}');
        {literal} }); {/literal}
getItemStatusCart('{$summId|escape}');
    </script>
</div>
</div>
</div>

