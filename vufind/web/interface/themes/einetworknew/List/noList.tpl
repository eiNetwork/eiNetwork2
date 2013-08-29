<script type="text/javascript" src="{$path}/services/EcontentRecord/ajax.js"></script>
{* Main Listing *}

  <div id="main-content" class="col-xs-9 col-md-9">
	<input type="hidden" value="{$wishListID}" id="listId"/>
    <div id="searchInfo">
	<div class="resulthead">
            <div class="subPageTitle" style="height:40px;">You dont have any wish lists. <br> <p style="color:red">You can import your wish lists from the old catalog by clicking on the Import list from old catalog button.</p></div>
            {* <div>Create a new List</div> *} 
            {*<div><a href="/List/Import">Import an existing list from your Classic Catalog account.</a></div>*}
	</div>

        <div {if count($wishList)<=1}style="margin-top:10px" {/if}>
	        <input type="button" class="btn btn-warning" onclick="ajaxLightbox('/List/ListEdit?id=&amp;source=VuFind&amp;lightbox2',false,false,'400px',false,'200px'); return false;" class="button navmenu dd" value="Create New Wish List" style="width:180px"/>
              	<input type="button" class="btn btn-warning" onclick="window.location = '/List/Import';" class="button navmenu dd" value="Import List From Old Catalog" style="width:auto"/>
	</div>
      {* End Listing Options *}
      
    </div>
    {* End Main Listing *}
  </div>
  <div class="col-xs-3 col-md-3">
	{*right-bar template*}
	{include file="ei_tpl/right-bar.tpl"}
  </div>
</div>



