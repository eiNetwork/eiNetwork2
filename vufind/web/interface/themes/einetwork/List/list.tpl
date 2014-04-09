{literal}
<script type="text/javascript">

	$(document).ready(function() {

		$('#placeHoldForm').submit(function(){

			if ($('#campus').val() == ''){
				alert('Please select a pickup location.');
				return false;
			}

		})

	});

</script>
{/literal}
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
	{if $sideRecommendations}
		{foreach from=$sideRecommendations item="recommendations"}
		{include file=$recommendations sideFacetSet=false}
		{/foreach}
	{/if}
  </div>
  {* End Narrow Search Options *}

  <div id="main-content">
	<input type="hidden" value="{$wishListID}" id="listId"/>
	<script type="text/javascript" src="/services/List/ajax.js"></script>
    <div id="searchInfo">
	{if $pageType eq 'WishList'}
		<h2>Wish Lists</h2>
		<h1><span id="wishTitle">{$listTitle}</span>&nbsp;<span style="font-size: 14px;">(<span style="color:#256292;cursor: pointer;" onclick="ajaxLightbox('/List/ListEdit?id={$wishListID}&source=VuFind&lightbox&method=editList',false,false,'450px',false,'200px'); return false;">edit</span>)</span></h1>
		<span><input type="button" value="Move All Physical Items to Book Cart" onclick="saveAllToBookCart()" class="button"></span>
		<span  style="margin-left:10px;"><input type="button" value="Delete This Wish List" onclick="getDeleteList('{$wishListID}')" class="button"></span>
		{if $pageLinks.all}<div class="pagination">{$pageLinks.all}</div>{/if}
	{/if}
	{if $pageType eq 'BookCart'}
	<div class="resulthead" style="font-size:16px;height:30px">
		
			{if count($recordSet)>1}
				Items in your book cart
			{elseif count($recordSet) == 1}
				Item in your book cart
			{else}
				Your book cart is empty
			{/if}
		
	</div>
	{/if}

	{if $preferred_message != ''}
		<div class="resulthead preferred-message-container" style="margin-bottom: 25px;">
			<div class="preferred-message">
				<p>{$preferred_message}</p>
			</div>
		</div>
	{/if}
	
      {* End Listing Options *}

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
        
      {if $pageLinks.all}<div class="pagination">{$pageLinks.all}</div>{/if}
      <b class="bbot"><b></b></b>
    </div>
    {* End Main Listing *}
  </div>
  {*right-bar template*}
  {include file="ei_tpl/right-bar.tpl"}
</div>



