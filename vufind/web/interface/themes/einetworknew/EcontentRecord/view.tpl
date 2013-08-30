<script type="text/javascript" src="{$path}/services/EcontentRecord/ajax.js"></script>
{if !empty($addThis)}
<script type="text/javascript" src="https://s7.addthis.com/js/250/addthis_widget.js?pub={$addThis|escape:"url"}"></script>
{/if}
<script type="text/javascript">
{literal}$(document).ready(function(){{/literal}
	GetEContentHoldingsInfo('{$id|escape:"url"}');
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
	  //alert("{$title}");
	{/if}
{literal}});{/literal}
function redrawSaveStatus() {literal}{{/literal}
    getSaveStatus('{$id|escape:"javascript"}', 'saveLink');
{literal}}{/literal}
</script>

{if $error}<p class="error">{$error}</p>{/if}

<div class="row">

    <div class="col-xs-3 col-md-3">
        {include file = "EcontentRecord/left-bar-record.tpl"}
    </div>
    <div class="col-xs-6 col-md-6">

    </div>
    <div class="col-xs-3 col-md-3">
        {include file="ei_tpl/right-bar.tpl"}
    </div>
</div>

{if $showStrands}   
{* Strands Tracking *}{literal}
<!-- Event definition to be included in the body before the Strands js library -->
<script type="text/javascript">
if (typeof StrandsTrack=="undefined"){StrandsTrack=[];}
StrandsTrack.push({
   event:"visited",
   item: "{/literal}econtentRecord{$id|escape}{literal}"
});
</script>
{/literal}
{/if}
     