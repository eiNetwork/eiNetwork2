<div id = "holdingsSummary"
	{if $holdingsSummary.status == 'Available from OverDrive'}
		class="holdingsSummary overdriveAvailable"
	{elseif $holdingsSummary.status == 'Checked Out'}
		class="holdingsSummary overdriveCheckedOut"
	{/if}>
	<br/>
	<div class="availability">
		{if $holdingsSummary.status == 'Available from OverDrive'}
			<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Available.png"/ alt="Available"></span>
			<span class="label label-success"><a style="cursor:pointer; color: #fff" class="overdriveAvailable" onclick="checkoutOverDriveItem('{$holdingsSummary.recordId}')">{$holdingsSummary.status}</a></span>
		{elseif $holdingsSummary.status == 'Checked Out'}
			{if $holdingsSummary.totalCopies > 0}
				<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/CheckedOut.png"/ alt="CheckedOut"></span>
				<span class="label label-danger"><a style="cursor:pointer; color: #fff" class="overdriveCheckedOut" onclick="placeOverDriveHold('{$holdingsSummary.recordId}')">{$holdingsSummary.status}</a></span>
			{else}
				<span><img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/CheckedOut.png"/ alt="CheckedOut"></span>
				<span class="label label-danger"><a style="cursor:pointer; color: #fff" class="overdriveCheckedOut">No Copies Available</a></span>		
			{/if}
		{/if}
		
	</div>

	<div class="holdableCopiesSummary">
		{if $holdingsSummary.numHoldings == 0}
			No copies available yet.
			<!--<br/>{$holdingsSummary.wishListSize} {if $holdingsSummary.wishListSize == 1}person has{else}people have{/if} added the record to their wish list.-->
		{else}
			{if strcasecmp($holdingsSummary.source, 'OverDrive') == 0}
				{*Available for use from OverDrive.*}
				{if $holdingsSummary.holdQueueLength > 0}
					{$holdingsSummary.holdQueueLength} {if $holdingsSummary.holdQueueLength == 1}person {else}people {/if} on waitlist for
				{/if}
				{if $holdingsSummary.totalCopies != 999999}{$holdingsSummary.totalCopies} total {if $holdingsSummary.totalCopies == 1}copy{else}copies{/if}{/if}{if $holdingsSummary.availableCopies}, {$holdingsSummary.availableCopies} available. {/if} 
			{elseif $holdingsSummary.source == 'Freegal'}
			        {$holdingsSummary.status}
				Downloadable from Freegal.
			{elseif $holdingsSummary.source == 'OneClick'}
				{$holdsinsSummary.status}
				Downloadable from OneClick
			{elseif $holdingsSummary.accessType == 'free'}
				Available for multiple simultaneous usage.
			{/if}

<!--			<div class="holdableCopiesSummary">
			{if $holdingsSummary.holdQueueLength > 0}
				{$holdingsSummary.holdQueueLength} {if $holdingsSummary.holdQueueLength == 1}person {else}people {/if} on waitlist for
			{/if}
			{if $holdingsSummary.totalCopies != 999999}{$holdingsSummary.totalCopies} total {if $holdingsSummary.totalCopies == 1}copy{else}copies{/if}.{/if}{if $holdingsSummary.availableCopies}, {$holdingsSummary.availableCopies} available. {/if} 
			</div>
-->
		{/if} 
		{if $showOtherEditionsPopup}
		<div class="otherEditions">
			<a style="cursor:pointer" onclick="loadOtherEditionSummaries('{$holdingsSummary.recordId}', true)">Other Formats and Languages</a>
		</div>
		{/if}
	</div>
 </div>