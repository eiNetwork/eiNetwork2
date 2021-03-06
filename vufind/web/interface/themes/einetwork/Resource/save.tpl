<div onmouseup="this.style.cursor='default';" id="popupboxHeader" class="popupHeader">
	<span class="popupHeader-title">{translate text='add_favorite_prefix'} {$record->title|escape:"html"} {translate text='add_favorite_suffix'}</span>
	<span onclick="hideLightbox()"><img class="close-button" src="/interface/themes/einetwork/images/closeHUDButton.png" style="float:right" ></span>
</div>
<div id="popupboxContent" class="popupContent">
<form onSubmit="saveRecord('{$id|escape}', '{$source|escape}', this, {literal}{{/literal}add: '{translate text='Add to list'}', error: '{translate text='add_favorite_fail'}'{literal}}{/literal}); return false;">
<input type="hidden" name="submit" value="1" />
<input type="hidden" name="record_id" value="{$id|escape}" />
<input type="hidden" name="source" value="{$source|escape}" />
{if !empty($containingLists)&&count($containingLists)>0}
  <p>
  {if count($containingLists)>1}
    {translate text="This item is already part of the following lists"}:<br />
  {else}
    {translate text="This item is already part of the following list"}:<br />
  {/if}
  {foreach from=$containingLists item="list"}
	{if $list.title|escape:"html" neq "Book Cart"}
		<a href="{$path}/MyResearch/MyList/{$list.id}">{$list.title|escape:"html"}</a><br />
	{/if}
  {/foreach}
  </p>
{/if}

{* Only display the list drop-down if the user has lists that do not contain
 this item OR if they have no lists at all and need to create a default list *}
{if (!empty($nonContainingLists) || (empty($containingLists) && empty($nonContainingLists))) }
  {assign var="showLists" value="true"}
{/if}

<table style="margin-left:5px">
  {if $showLists}
  <tr style="height:25px;vertical-align:middle">
    <td>
      {translate text='Choose a List'}
    </td>
  </tr>
  {/if}
  <tr>
    <td>
      {if $showLists}
      <select name="list">
        {foreach from=$nonContainingLists item="list"}
	{if $list.title|escape:"html" neq "Book Cart"}
        <option value="{$list.id}">{$list.title|escape:"html"}</option>
	{/if}
        {foreachelse}
        <option value="">{translate text='My Lists'}</option>
        {/foreach}
      </select>
      {/if}
      <button  class="button"
         onclick="ajaxLightbox('{$path}/MyResearch/ListEdit?id={$id|escape}&source={$source|escape}&lightbox',false,false,'450px',false,'200px'); return false;">{translate text="Create a new list"}</button>
    </td>
  </tr>
  {if $showLists}
  
  <tr><td><input type="submit" class="button" value="{translate text='Save'}" style="margin-left:320px;width:70px;background-color:rgb(244,213,56)"></td></tr>
  {/if}
</table>
</form>
</div>