<div id="page-content" class="content">
  {* Narrow Search Options *}
  <div id="sidebar">
    {if $sideRecommendations}
      {foreach from=$sideRecommendations item="recommendations"}
        {include file=$recommendations}
      {/foreach}
    {/if}
  </div>
  
  <div id="main-content">
    {* Recommendations *}
    {*if $topRecommendations}
      {foreach from=$topRecommendations item="recommendations"}
        {include file=$recommendations}
      {/foreach}
    {/if*}
    <div class="resulthead"><h3>{translate text='nohit_heading'}</h3></div>
      
      <p class="error">{translate text='nohit_prefix'} - <b>{$lookfor|escape:"html"}</b> - {translate text='nohit_suffix'}</p>

    <div>
    <ul id="noResultsSuggest">
    {if $author}<li>Try searching <a href="{$contrib_search_link}">Author/Artist/Contributor</a> instead. This is a broader search that also searches for performers, composers, directors, and organizations that contributed to the work.</br></br></li>{/if}
    <li>Check the <b>spelling</b> of your search terms.
      {if $spellingSuggestions}
        <div class="correction">{translate text='nohit_spelling'}:<br/>
        {foreach from=$spellingSuggestions item=details key=term name=termLoop}
          {$term|escape} &raquo; {foreach from=$details.suggestions item=data key=word name=suggestLoop}<a href="{$data.replace_url|escape}">{$word|escape}</a>{if $data.expand_url} <a href="{$data.expand_url|escape}"><img src="/images/silk/expand.png" alt="{translate text='spell_expand_alt'}"/></a> {/if}{if !$smarty.foreach.suggestLoop.last}, {/if}{/foreach}{if !$smarty.foreach.termLoop.last}<br/>{/if}
        {/foreach}
        </div>
        <br/>
      {/if}</li>
    <li>If you're not sure of the spelling, you can use <b>wildcard characters</b> in your search terms to substitute for any characters where you're not sure of the spelling.<br /><br /></li>
	    <ul><li><b>The question mark ?</b> can substitute for any single character.    For example, a search for S?dney Crosby will find Sidney or Sydney</li>
	    <li><b>The asterisk *</b> can substitute for multiple characters.  For example, a search for Prisoner of Az*  will find Prisoner of Azkhaban</li>
	    <li><b>The tilde ~ </b>used at the end of a single word search term will search for similar, "sounds like" spellings of your search term.   For example, a search for King~ will find Kynge, Ting, Xing, and Kinde</li>
      
    </ul></br>
    <li>Are there filters applied at left?   Try <b>removing some or all of the filters</b>.</li></br>
    <li>Restate your query by using more, other or broader terms.</li>
    </ul>

      {if $parseError}
          <p class="error">{translate text='nohit_parse_error'}</p>
      {/if}
      

      
      {* Display Repeat this search links *}
      {if strlen($lookfor) > 0 && count($repeatSearchOptions) > 0}
    <div class='repeatSearchHead'><h4>Try another catalog</h4></div>
      <div class='repeatSearchList'>
      {foreach from=$repeatSearchOptions item=repeatSearchOption}
        <div class='repeatSearchItem'>
            <a href="{$repeatSearchOption.link}" class='repeatSearchName' target='_blank'>{$repeatSearchOption.name}</a>{if $repeatSearchOption.description} - {$repeatSearchOption.description}{/if}
		      </div>
        {/foreach}
    </div>
    {/if}

		{if $enableMaterialsRequest}
    Can't find what you are looking for? Try our <a href="http://www.einetwork.net/ils/requests/acquire_web_ngc.php">Materials Request Service</a>.
    {/if}
    	</div>
    </div>
    		 {*right-bar template*}
  {include file="ei_tpl/right-bar.tpl"}
</div>