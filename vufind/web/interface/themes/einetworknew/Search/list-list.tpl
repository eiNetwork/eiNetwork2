<script type="text/javascript">
$(document).ready(function() {literal} { {/literal}
  doGetStatusSummaries();
  doGetRatings();
  {if $user}
  doGetSaveStatuses();
  {/if}
{literal} }); {/literal}
</script>

<form id="addForm" action="{$url}/MyResearch/HoldMultiple">
	<div id="addFormContents">
		{* Make sure to trigger the proper events when selecting and deselecting *}
		{*<div class='selectAllControls'> 
		  <a href="#" onclick="$('.titleSelect').not(':checked').attr('checked', true).trigger('click').attr('checked', true);return false;">Select All</a> /
		  <a href="#" onclick="$('.titleSelect:checked').attr('checked', false).trigger('click').attr('checked', false);return false;">Deselect All</a>
		</div>
		*}
		{foreach from=$recordSet item=record name="recordLoop"}
		    {$record}
		{/foreach}
		<input type="hidden" name="type" value="hold" />	
		
		{if !$enableBookCart}
		<input type="submit" name="placeHolds" value="Request Selected Items" class="requestSelectedItems"/>
		{/if}
	</div>
</form>

{if $showStrands}
{* Add tracking to strands based on the user search string.  Only track searches that have results. *}
{literal}
<script type="text/javascript">

//This code can actually be used anytime to achieve an "Ajax" submission whenever called
if (typeof StrandsTrack=="undefined"){StrandsTrack=[];}

StrandsTrack.push({
   event:"searched",
   searchstring: "{/literal}{$lookfor|escape:"url"}{literal}"
});

</script>
{/literal}
{/if}