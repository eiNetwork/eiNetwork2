<div id="record{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="resultsList">
<div class="imageColumn">
    {if $user->disableCoverArt != 1}
    <div id='descriptionPlaceholder{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}' style='display:none'></div>
    <a href="{$url}/Record/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
    <img src="{$bookCoverUrl}" class="listResultImage" alt="{translate text='Cover Image'}"/>
    </a>
    {/if}
    {* Place hold link *}
    <div class='requestThisLink' id="placeHold{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" style="display:none">
      <a href="{$url}/Record/{$summId|escape:"url"}/Hold"><img src="{$path}/interface/themes/default/images/place_hold.png" alt="Place Hold"/></a>
    </div>
</div>
<div class="resultDetails">
  <div>
    <h2>{if $summScore}({$summScore}) {/if}<a href="{$url}/Record/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}">{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}{/if}</a></h2>
    {if $summTitleStatement}
    <div>{$summTitleStatement|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}</div>
    {/if}
  </div>
  <div>
    <p>
    {if !empty($summFormats)}
      <span class="format">
        {if is_array($summFormats)}
          {foreach from=$summFormats item=format}
            <span class="icon-{$format|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$format}</span>
          {/foreach}
        {else}
          <span class="icon-{$summFormats|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$summFormats}</span>
        {/if}
      </span>
    {/if}
    {if !empty($summAuthor)}
      <span class="author">
        {if is_array($summAuthor)}
          {foreach from=$summAuthor item=author}
            <a href="{$url}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
          {/foreach}
        {else}
          <a href="{$url}/Author/Home?author={$summAuthor|escape:"url"}">{$summAuthor|highlight:$lookfor}</a>
        {/if}
      </span>
    {/if}
    {if $summDate}{translate text='Published'} {$summDate.0|escape}{/if}</p>
  </div>
  <div>
    <p>{if !empty($summSnippetCaption)}<b>{translate text=$summSnippetCaption}:</b>{/if}
    {if !empty($summSnippet)}<span class="quotestart">&#8220;</span>...{$summSnippet|highlight}...<span class="quoteend">&#8221;</span>{/if}</p>
  </div>
  <div id="holdingsSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="holdingsSummary">
    <div class="statusSummary" id="statusSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
      <span class="unknown" style="font-size: 8pt;">{translate text='Loading'}...</span>
    </div>
  </div>
</div>
<div id ="searchStars{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="resultActions">
  <div class="rate{if $summShortId}{$summShortId}{else}{$summId|escape}{/if} stat">
    <div class="statVal">
      <span class="ui-rater">
        <span class="ui-rater-starsOff" style="width:90px;"><span class="ui-rater-starsOn" style="width:0px"></span></span>
        (<span class="ui-rater-rateCount-{if $summShortId}{$summShortId}{else}{$summId|escape}{/if} ui-rater-rateCount">0</span>)
      </span>
    </div>
    <div id="saveLink{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
      {if $user}
        <div id="lists{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}"></div>
        <script type="text/javascript">
          getSaveStatuses('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}');
        </script>
      {/if}
      {if $showFavorites == 1}
        <a href="{$url}/Resource/Save?id={$summId|escape:"url"}&amp;source=VuFind" style="padding-left:8px;" onclick="getSaveToListForm('{$summId}', 'VuFind'); return false;">{translate text='Add to'} <span class='myListLabel'>MyLIST</span></a>
      {/if}
    </div>
    {assign var=id value=$summId scope="global"}
    {assign var=shortId value=$summShortId scope="global"}
    {include file="Record/title-review.tpl"}
  </div>
  <script type="text/javascript">
    $(
       function() {literal} { {/literal}
           $('.rate{if $summShortId}{$summShortId|escape}{else}{$summId|escape}{/if}').rater({literal}{ {/literal}module: 'Record', recordId: '{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}',  rating:0.0, postHref: '{$url}/Record/{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}/AJAX?method=RateTitle'{literal} } {/literal});
       {literal} } {/literal}
    );
  </script>
</div>
<script type="text/javascript">
  addRatingId('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}');
  addIdToStatusList('{$summId|escape}');
  $(document).ready(function(){literal} { {/literal}
    resultDescription('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}','{$summId}');
  {literal} }); {/literal}
</script>
</div>
