<div id="page-content" class="row">
  
  <div id="main-content" class="col-xs-9 col-md-9">
    <h2>Saved Searches</h2>
      {if !$noHistory}
      {if $saved}
        <div><h3>{translate text="history_saved_searches"}</h3><br /></div>
        <table class="table" width="640px" >
          <tr>
            <th width="25%">{translate text="history_time"}</th>
            <th width="30%">{translate text="history_search"}</th>
            <th width="30%">{translate text="history_limits"}</th>
            <th width="10%">{translate text="history_results"}</th>
            <th width="5%">&nbsp;</th>
          </tr>
          {foreach item=info from=$saved name=historyLoop}
          {if ($smarty.foreach.historyLoop.iteration % 2) == 0}
          <tr class="evenrow">
          {else}
          <tr class="oddrow">
          {/if}
            <td>{$info.time}</td>
            <td><a href="{$info.url|escape}">{if empty($info.description)}{translate text="history_empty_search"}{else}{$info.description|escape}{/if}</a></td>
            <td>{foreach from=$info.filters item=filters key=field}{foreach from=$filters item=filter}
              <b>{translate text=$field|escape}</b>: {$filter.display|escape}<br/>
            {/foreach}{/foreach}</td>
            <td>{$info.hits}</td>
<!--            <td><a href="{$path}/MyResearch/SaveSearch?delete={$info.searchId|escape:"url"}&amp;mode=history" class="delete">{translate text="history_delete_link"}</a></td>
-->
                <td><button type="button" class="btn btn-warning" onClick="window.location.href='{$path}/MyResearch/SaveSearch?delete={$info.searchId|escape:"url"}&amp;mode=history'" class="delete"'">Delete</button></td>
          </tr>
          {/foreach}
        </table>
        <br/>
      {/if}

      {if $links}
        <div>
          <button type="button" class="btn btn-warning pull-right" onclick="window.location.href='{$path}/Search/History?purge=true'" class="delete"'">Purge my Unsaved Searches</button>        
          <div class="resulthead"><h3>{translate text="My Unsaved Searches"}</h3></div>
          <br />
        </div>
        <table class="table" width="640px">
          <tr>
            <th width="25%">{translate text="history_time"}</th>
            <th width="30%">{translate text="history_search"}</th>
            <th width="30%">{translate text="history_limits"}</th>
            <th width="10%">{translate text="history_results"}</th>
            <th width="5%">&nbsp;</th>
          </tr>
          {foreach item=info from=$links name=historyLoop}
          {if ($smarty.foreach.historyLoop.iteration % 2) == 0}
          <tr class="evenrow">
          {else}
          <tr class="oddrow">
          {/if}
            <td>{$info.time}</td>
            <td><a href="{$info.url|escape}">{if empty($info.description)}{translate text="history_empty_search"}{else}{$info.description|escape}{/if}</a></td>
            <td>{foreach from=$info.filters item=filters key=field}{foreach from=$filters item=filter}
              <b>{translate text=$field|escape}</b>: {$filter.display|escape}<br/>
            {/foreach}{/foreach}</td>
            <td>{$info.hits}</td>
            <td><button type="button" class="btn btn-warning" onclick='getToRequest("{$path}/MyResearch/SaveSearch?save={$info.searchId|escape:"url"}&amp;mode=history")'>Save</button></td>
          </tr>
          {/foreach}
        </table>
<!--        <br/><button type="button" class="btn btn-warning pull-right" onclick="window.location.href='{$path}/Search/History?purge=true'" class="delete"'">Purge my Unsaved Searches</button>        
-->      {/if}

      {else}
        <div class="resulthead"><h3>{translate text="history_recent_searches"}</h3></div>
        {translate text="history_no_searches"}
      {/if}
    </div>

  <div class="col-xs-3 col-md-3">
	{*right-bar template*}
	{include file="ei_tpl/right-bar.tpl"}
  </div>
</div>
