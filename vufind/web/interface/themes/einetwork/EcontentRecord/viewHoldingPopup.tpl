<script type="text/javascript" src="{$url}/js/overdrive.js"></script>
<div onmouseup="this.style.cursor='default';" id="popupboxHeader" class="popupHeader">
	{translate text='Holding'}
	<span><img src="/interface/themes/einetwork/images/closeHUDButton.png" style="float:right" onclick="hideLightbox()"/></span>
</div>
<div id="popupboxContent" class="popupContent" style="margin-top:10px">
{if count($holdings) > 0}
    <div style="overflow-y:auto;height:auto;max-height:4000px;margin-left:8px">
	{if $lockedFormat == '' }
	<div><span>You may select one format.</span></div>
	{/if}
	<table>
	<thead>
		<tr><th style="width:110px">Type</th><th style="width:80px">Source</th>{if $showEContentNotes}<th>Notes</th>{/if}<th style="padding-left:10px">&nbsp;</th>
	</thead>
	<tbody>
	{foreach from=$holdings item=eContentItem key=index}
		{if $eContentItem->item_type == 'overdrive'}
			{if $eContentItem->externalFormatId != 'ebook-overdrive' && $eContentItem->externalFormatId != 'audiobook-overdrive' }
			<tr id="itemRow{$index}" style="height:30px">
				<td>{$eContentItem->externalFormat}</td>
				<td>OverDrive</td>
				<td>
					{if ($lockedFormat == 'undefined' || $eContentItem->externalFormatId == $lockedFormat) && $eContentItem->externalFormatId != 'ebook-overdrive'}
						<a href="#" onclick="downloadOverDriveItem('{$overDriveId}', '{$eContentItem->externalFormatId}')" class="button" style="background-color:rgb(244,213,56);width:95px;height:20px;padding-top:0px;padding-bottom:0px;text-align:center;">Download Now</a>
					{/if}
				</td>
			</tr>
			{/if}
			
		{else}
			<tr id="itemRow{$eContentItem->id} style="height:30px"">
				<td>{$eContentItem->item_type}</td>
				<td>{$eContentItem->source}</td>
				<td>{if $eContentItem->getAccessType() == 'free'}No Usage Restrictions{elseif $eContentItem->getAccessType() == 'acs' || $eContentItem->getAccessType() == 'singleUse'}Must be checked out to read{/if}</td>
				{if $showEContentNotes}<td>{$eContentItem->notes}</td>{/if}
				<td>
					{* Options for the user to view online or download *}
					{foreach from=$eContentItem->links item=link}
						<a href="{if $link.url}{$link.url}{else}#{/if}" {if $link.onclick}onclick="{$link.onclick}"{/if} class="button" style="background-color:rgb(244,213,56);width:95px;height:20px;padding-top:0px;padding-bottom:0px;text-align:center;" >{$link.text}</a>
					{/foreach}
					{if $user && $user->hasRole('epubAdmin')}
						<a href="#" onclick="return editItem('{$id}', '{$eContentItem->id}')" style="background-color:rgb(244,213,56);width:95px;height:20px;padding-top:0px;padding-bottom:0px;text-align:center;" class="button">Edit</a>
						<a href="#" onclick="return deleteItem('{$id}', '{$eContentItem->id}')" class="button" style="background-color:rgb(244,213,56);width:95px;height:20px;padding-top:0px;padding-bottom:0px;text-align:center;">Delete</a>
					{/if}
				</td>
			</tr>
		{/if}
	{/foreach}
	</tbody>
	</table>
    </div>
{else}
	No Copies Found
{/if}

{assign var=firstItem value=$holdings.0}
{if strcasecmp($source, 'OverDrive') == 0}
	<div id='overdriveMediaConsoleInfo' style="margin-left:8px">
		{if $firstItem->externalFormatId == 'periodicals-nook'}
			<img src="{$path}/images/overdrive.png" width="125" height="42" alt="Powered by Overdrive" class="alignleft"/>
			<p>This issue will be sent to your free <a href="https://nook.barnesandnoble.com/my_library/">NOOK account</a>.  If you do not already
			have one, you will be prompted to create it during the download process.  If this is your first time downloading a NOOK periodical, 
			you will need to grant access to your NOOK account to tie it to your catalog account.</p>
			<div class="clearer">&nbsp;</div> 
			<p>After the issue has been added to your NOOK account, you can view it using a compatible NOOK tablet or the free 
			<a href="http://nook.barnesandnoble.com/u/nook-mobile-app/379003593">NOOK Reading App</a> for 
			Android phone/tablet, Apple iPhone/iPad/iPod touch, or Windows 8+ computer/tablet.</p>
		{else}
			<img src="{$path}/images/overdrive.png" width="125" height="42" alt="Powered by Overdrive" class="alignleft"/>
			<p>This title requires the <a href="http://www.overdrive.com/software/omc/">OverDrive&reg; Media Console&trade;</a> to use the title.  
			If you do not already have the OverDrive Media Console, you may download it <a href="http://www.overdrive.com/software/omc/">here</a>.</p>
			<div class="clearer">&nbsp;</div> 
			<p>Need help transferring a title to your device or want to know whether or not your device is compatible with a particular format?
			Click <a href="http://help.overdrive.com">here</a> for more information. 
			</p>
		{/if}		 
	</div>
{/if}
</div>

