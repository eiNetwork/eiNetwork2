{if !empty($addThis)}
<script type="text/javascript" src="https://s7.addthis.com/js/250/addthis_widget.js?pub={$addThis|escape:"url"}"></script>
{/if}
<script type="text/javascript">
{literal}$(document).ready(function(){{/literal}
	GetHoldingsInfo('{$id|escape:"url"}');
	{if $isbn || $upc}
		GetEnrichmentInfo('{$id|escape:"url"}', '{$isbn10|escape:"url"}', '{$upc|escape:"url"}');
	{/if}
	{if $isbn}
		GetReviewInfo('{$id|escape:"url"}', '{$isbn|escape:"url"}');
	{/if}
	{if $enablePospectorIntegration == 1}
		GetProspectorInfo('{$id|escape:"url"}');
	{/if}
	{if $user}
		redrawSaveStatus();
	{/if}
	
	{if (isset($title)) }
		alert("{$title}");
	{/if}
{literal}});{/literal}
function redrawSaveStatus() {literal}{{/literal}
		getSaveStatus('{$id|escape:"javascript"}', 'saveLink');
{literal}}{/literal}
</script>

{if $error}<p class="error">{$error}</p>{/if} 

<div class="row">
	<div class="col-xs-3 col-md-3">
		{include file="ei_tpl/Record/left-bar-record.tpl"}
	</div>
	<div class="col-xs-6 col-md-6">

		<div class="row">
			<div class="col-xs-3 col-md-3">
				<a class="thumbnail" href="{$bookCoverUrl}">							
					<img alt="{translate text='Book Cover'}" class="recordcover" src="{$bookCoverUrl}" />
				</a>
				<div id="goDeeperLink" class="godeeper" style="display:none">
					<a href="{$path}/Record/{$id|escape:"url"}/GoDeeper" onclick="ajaxLightbox('{$path}/Record/{$id|escape}/GoDeeper?lightbox', false,false, '700px', '110px', '70%'); return false;">
					<img alt="{translate text='Go Deeper'}" src="{$path}/images/deeper.png" /></a>
				</div>
			</div>
			<div class="col-xs-6 col-md-6">
				<div id='recordTitle'>{$recordTitleSubtitle|regex_replace:"/(\/|:)$/":""|escape} </div>
				{* Display more information about the title*}
				{if $mainAuthor}
					<div class="recordAuthor">
						<span class="resultLabel"></span>
						<span class="resultValue"><a href="{$path}/Author/Home?author={$mainAuthor|escape:"url"}">{$mainAuthor|escape}</a></span>
					</div>
				{/if}
					
				{if $corporateAuthor}
					<div class="recordAuthor">
						<span class="resultLabel">{translate text='Corporate Author'}:</span>
						<span class="resultValue"><a href="{$path}/Author/Home?author={$corporateAuthor|escape:"url"}">{$corporateAuthor|escape}</a></span>
					</div>
				{/if}
				{if $pubdate}
					<div>
						{$pubdate}
					</div>
				{/if}
				{*}
				{if $showOtherEditionsPopup}
				<div id="otherEditionCopies">
					<div style="font-weight:bold"><a href="#" onclick="loadOtherEditionSummaries('{$id}', false)">{translate text="Other Formats and Languages"}</a></div>
				</div>
				{/if}
				{*}
			</div>
			<div class="col-xs-3 col-md-3">
				<div class="btn-group-vertical">
					{if !isset($noRequest)}
						<button type="button" class="btn btn-default" {if $enableBookCart}onclick="getSaveToBookCart('{$id|escape:"url"}','VuFind');return false;"{/if}>Add to Cart</button>
					{/if}
					<button type="button" class="btn btn-default" {if isset($noRequest)}disabled="disabled"{/if} {if !isset($noRequest)}onclick="getToRequest('{$path}/Record/{$id|escape:'url'}/Hold')"{/if}>Request Now</button>
					<button type="button" class="btn btn-default" onclick="getSaveToListForm('{$id|escape}', 'VuFind'); return false;">Add To Wish List</button>
					<button type="button" class="btn btn-default" onclick="findInLibrary('{$id|escape:"url"}',false,'150px','570px','auto')">Find in Library</button>
				</div>
			</div>
		</div>

	</div>
	<div class="col-lg-3">
		{include file="ei_tpl/right-bar.tpl"}
	</div>
</div>

<!--{if $showStrands}
{* Strands Tracking *}{literal}
<!-- Event definition to be included in the body before the Strands js library -->
<script type="text/javascript">
if (typeof StrandsTrack=="undefined"){StrandsTrack=[];}
StrandsTrack.push({
	 event:"visited",
	 item: "{/literal}{$id|escape}{literal}"
});
</script>
{/literal}
{/if}-->
<script>getItemStatusCart('{$id|escape}')</script>