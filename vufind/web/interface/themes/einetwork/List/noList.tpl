<script type="text/javascript" src="{$path}/services/EcontentRecord/ajax.js"></script>
{* Main Listing *}
{if (isset($title)) }
<script type="text/javascript">
	alert("{$title}");
</script>
{/if}
<div id="page-content" class="content">
  {* Narrow Search Options *}
  <div id="left-bar">
        {if $pageType eq 'WishList'}
            <div class="filters" id="wishLists" >
                    {if count($wishList)>1}
                     <dl class="narrowList navmenu narrowbegin">
                            <dt>{translate text='View List'}</dt>
                                    <dd>
                                            <form id='goToList' action='/List/Results' method='GET' name='goToList'> 
                                            <select id="goToListID" name='goToListID' onchange="this.form.submit()">
                                                    {foreach from=$wishList item = list key=key name = loop}
                                                            <option value="{$list.id}" {if $currentListID && $currentListID == $list.id} selected="selected"{/if}>{$list.title}									</option>
                                                    {/foreach}
                                            </select>
                                            {foreach from=$wishList item = list key=key name = loop}
                                                    {if $list.title == 'Book Cart'}
                                                            <input type="hidden" value='{$list.id}' name='bookCartID' id='bookCartID'/>
                                                    {/if}
                                            {/foreach}
                                            </form>
                                    </dd>
                     </dl>
                     {/if}
                     <dl class="narrowList navmenu narrowbegin" {if count($wishList)<=1}style="margin-top:10px" {/if}>
                            <dd>
                                    <input type="button" onclick="ajaxLightbox('/List/ListEdit?id=&amp;source=VuFind&amp;lightbox2',false,false,'400px',false,'200px'); return false;" class="button navmenu dd" value="Create New List" style="width:180px"/>
                            </dd>
                            <dd>
<!--                            	<input type="button" class="button yellow" onclick="window.location = '/List/Import';" class="button navmenu dd" value="Import List From Old Catalog" style="width:auto"/>
-->                            </dd>
                     </dl>
            </div>
	{/if}
  </div>
  {* End Narrow Search Options *}

  <div id="main-content">
	<input type="hidden" value="{$wishListID}" id="listId"/>
    <div id="searchInfo">
	<div class="resulthead">
            <div class="subPageTitle" style="height:40px;">You do not have any lists. <br> <!--<p style="color:red">You can import your lists from the old catalog by clicking on the Import list from old catalog button in the left hand column.</p>--></div>
            {* <div>Create a new List</div> *} 
            {*<div><a href="/List/Import">Import an existing list from your Classic Catalog account.</a></div>*}
	</div>
      {* End Listing Options *}

      {if $prospectorNumTitlesToLoad > 0}
        <script type="text/javascript">getProspectorResults({$prospectorNumTitlesToLoad}, {$prospectorSavedSearchId});</script>
      {/if}
      {* Prospector Results *}
      <div id='prospectorSearchResultsPlaceholder'></div>
        
      {if $pageLinks.all}<div class="pagination">{$pageLinks.all}</div>{/if}
      
      
      <b class="bbot"><b></b></b>
    </div>
    {* End Main Listing *}
  </div>
  {*right-bar template*}
  {include file="ei_tpl/right-bar.tpl"}
</div>



