<div id = "holdingsSummary" class="holdingsSummary {$holdingsSummary.class}">
	{if $holdingsSummary.class == 'here'}
		{if $holdingsSummary.callnumber}
			<div class='callNumber'>
				<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Available.png"/ alt="Available"></span>
				<span class="label label-success"><a style="cursor:pointer; color: #fff" onclick="findInLibrary('{$holdingsSummary.recordId|escape:"url"}',false,'150px','570px','auto')">It's Here {$holdingsSummary.callnumber}</a></span>
			</div>
		{elseif $holdingsSummary.isDownloadable}
			<div>
				<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Available.png"/ alt="Available"></span>
				<span class="label label-success"><a href='{$holdingsSummary.downloadLink}'target='_blank' class="availableOnline">Available Online</a></span>
			</div>
		{/if}
	{elseif $holdingsSummary.inLibraryUseOnly}
		<div>
			<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Noncirculating.png"/ alt="Noncirculating"></span>
			<span class="label label-success" style="cursor:pointer" onclick="findInLibrary('{$holdingsSummary.recordId|escape:"url"}',false,'150px','570px','auto')">Available for in Library use Only</span>
		</div>
		<script>
			var n = "{$holdingsSummary.recordId}".replace(/\./g, "");
		{literal}
			if(document.getElementById("request-now"+n)){
				var t = document.getElementById("request-now"+n);
				t.onclick = "";
				t.style.backgroundColor = "rgb(192,192,192)";
				t.style.color = "rgb(248,248,248)";
				t.style.cursor = "default";
				if($("#request-now"+n+" .resultAction_span")!=null)$("#request-now"+n+" .resultAction_span").text("In Library Only");
				if($("#request-now"+n+" .action-lable-span")!=null)$("#request-now"+n+" .action-lable-span").text("In Library Only");
				
			}
		{/literal}
		</script>

	{elseif $holdingsSummary.class == 'nearby'}
		<div>
			<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Available.png"/ alt="Available"></span>
			<span class="label label-success" style="cursor:pointer" onclick="findInLibrary('{$holdingsSummary.recordId|escape:"url"}',false,'150px','570px','auto')">Available at your preferred Libraries</span>
		</div>
	{elseif $holdingsSummary.status == "On Order"}
		<div>
			<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Available.png"/ alt="Available"></span>
			<span class="label label-success" style="cursor:pointer" onclick="findInLibrary('{$holdingsSummary.recordId|escape:"url"}',false,'150px','570px','auto')">On Order</span>
		</div>

	{elseif $holdingsSummary.class == 'available'}
		<div>
			<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Available.png"/ alt="Available"></span>
			<span class="label label-success" style="cursor:pointer" onclick="findInLibrary('{$holdingsSummary.recordId|escape:"url"}',false,'150px','570px','auto')">Available at other Libraries</span>
		</div>
	{elseif $holdingsSummary.class == 'unavailable'}
		<div>
			<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/CheckedOut.png"/ alt="CheckedOut"></span>
			<span class="label label-default">No copies Available</span>
		</div>
	{elseif $holdingsSummary.class == 'reserve' or $holdingsSummary.numCopies == 0}
		<div>
			<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/CheckedOut.png"/ alt="CheckedOut"></span>
			<span class="label label-danger" style="cursor:pointer" onclick="findInLibrary('{$holdingsSummary.recordId|escape:"url"}',false,'150px','570px','auto')">Checked Out</span>
		</div>
	{else $holdingsSummary.class == 'checkedOut'}
		<div>
			<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/CheckedOut.png"/ alt="CheckedOut"></span>
			<span class="label label-danger" style="cursor:pointer;" onclick="findInLibrary('{$holdingsSummary.recordId|escape:"url"}',false,'150px','570px','auto')">Checked Out</span>
		</div>
	{/if}
	<div class="holdableCopiesSummary">
		<span class="label label-default" style="margin-left:22px">{if $holdingsSummary.holdQueueLength > 0}
			{$holdingsSummary.holdQueueLength} {if $holdingsSummary.holdQueueLength == 1}person {else}people {/if} on waitlist for 
		{/if}
		{$holdingsSummary.numCopies} total {if $holdingsSummary.numCopies == 1}copy{else}copies{/if}{if $holdingsSummary.availableCopies}, {$holdingsSummary.availableCopies} available. {/if}</label>
	</div>
			
	{if $showOtherEditionsPopup}
		<div class="otherEditions">
			<a style="cursor:pointer" onclick="loadOtherEditionSummaries('{$holdingsSummary.recordId}', false)">Other Formats and Languages</a>
		</div>
	{/if}
 </div>