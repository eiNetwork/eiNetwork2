{if (isset($title)) }
<script type="text/javascript">
	alert("{$title}");
</script>
{/if}
<script type="text/javascript" src="{$path}/js/holds.js"></script>
<script type="text/javascript" src="{$path}/services/MyResearch/ajax.js"></script>
<script type="text/javascript" src="{$path}/js/tablesorter/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="{$path}/js/jquery.selectric.js"></script>
{literal}
<script type="text/javascript">

	$(function(){
		$('.location_dropdown').selectric();
	});

</script>
<style>
{/literal}

{php}

$bold_count = $this->get_template_vars('preferred_count');

$i=0;
while ($i < $bold_count){

	$i++;

	if ($i < $bold_count){
		echo '.selectricItems li:nth-child(' . $i . '),';
	} else {
		echo '.selectricItems li:nth-child(' . $i . ')';
	}

	
}
{/php}
{literal}
{
	font-size:14px;
	font-weight: bolder;
}

</style>

{/literal}
<link rel="stylesheet" type="text/css" href="{$path}/interface/themes/einetwork/css/selectric.css">
<div id="page-content" class="content">
	<div id="left-bar">
		<div class="sort">
			<div id="sortLabel">
			{translate text='Sort by'}<span><img class="qtip-sort-by-request help-icon" style="vertical-align: middle" src="/images/help_icon.png" /></span>
			</div>
			<div class="sortOptions">
				<select name="accountSort" id="sort{$sectionKey}" onchange="changeAccountSort($(this).val());">
					{foreach from=$sortOptions item=sortDesc key=sortVal}
					<option value="{$sortVal}"{if $defaultSortOption == $sortVal} selected="selected"{/if}>{translate text=$sortDesc}</option>
					{/foreach}
				</select>
			</div>
		</div>
	</div>
	
	
	<div id="main-content">
		{if $user->cat_username}
			{if $showStrands && $user->disableRecommendations == 0}
				{assign var="scrollerName" value="Recommended"}
				{assign var="wrapperId" value="recommended"}
				{assign var="scrollerVariable" value="recommendedScroller"}
				{assign var="scrollerTitle" value="Recommended for you"}
				{include file=titleScroller.tpl}

				<script type="text/javascript">
					var recommendedScroller;
					recommendedScroller = new TitleScroller('titleScrollerRecommended', 'Recommended', 'recommended');
					recommendedScroller.loadTitlesFrom('{$url}/Search/AJAX?method=GetListTitles&id=strands:HOME-3&scrollerName=Recommended', false);
				</script>
			{/if}
			
			<div class="new-alert-box-container">
                <p style="color:orange; font-weight:bold;">A new mobile-friendly design is coming soon.  <a href="https://librarycatalog.einetwork.net/MyResearch/ComingSoon">Check it out!</a></p>
			
				<h2>{translate text='Requested Items'}</h2>
				<ul class="new-alert-box">
					<li>For items that you recently requested, it may take one minute for them to appear below.</li>
				</ul>
			</div>
			
			<div class="hold-buttons">
				<div class="requested-items-button">
					{if $freezeButton eq 'freeze'}
						<a class="freeze-all-btn button" href="#">Freeze All</a>
					{else}
						<a class="unfreeze-all-btn button" href="#">Unfreeze All</a>
					{/if}
					<img class="qtip-freeze" src="/images/help_icon.png" />
				</div>
				<div class="requested-items-button">
					<a class="update-selected-btn button" href="#">Update Selected</a><img class="qtip-request-update" src="/images/help_icon.png" />
				</div>
			</div>

			<div style="margin-top: 30px">
				<h3>Physical Requests</h3>
			</div>
			
			{foreach from=$recordList item=recordData key=sectionKey}
			
				{if is_array($recordList.$sectionKey) && count($recordList.$sectionKey) > 0}
				
				
				<div class="checkout">
				
				<form id="items-hold">
					{foreach from=$recordList.$sectionKey item=record name="recordLoop"}
						<div id="record{$record.recordId|escape}" class="item_list  record{$smarty.foreach.recordLoop.iteration}">
						
							<div class="item_image">
								{if $user->disableCoverArt != 1}
									<a href="{$url}/Record/{$record.recordId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{$record.recordId|escape:"url"}">
										<img src="{$coverUrl}/bookcover.php?id={$record.recordId}&amp;isn={$record.isbn|@formatISBN}&amp;size=small&amp;upc={$record.upc}&amp;category={$record.format_category.0|escape:"url"}" class="listResultImage" alt="{translate text='Cover Image'}"/>
									</a>
								{/if}
							</div>
							
							<div class="item_detail">
								<div class="item_subject">
									<a href="{$url}/Record/{$record.recordId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title">
										{if !$record.title|regex_replace:"/(\/|:)$/":""}
										{translate text='Title not available'}
										{else}
										{$record.title|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}
										{/if}
									</a>
									{if $record.title2}
										<div class="searchResultSectionInfo">
											{$record.title2|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}
										</div>
									{/if}
								</div>
								
								<div class="item_author">
									{if $record.author}
										{if is_array($record.author)}
											{foreach from=$summAuthor item=author}
												<a href="{$url}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
											{/foreach}
										{else}
											<a href="{$url}/Author/Home?author={$record.author|escape:"url"}">{$record.author|highlight:$lookfor}</a>
										{/if}
									{/if}	 
									{if $record.publicationDate}{translate text='Published'} {$record.publicationDate|escape}{/if}
								</div>
								
								<div>Pickup Location: {$record.location}</div>
								<div>
									Status: {$record.status}
									{if $record.expire}
									for pick up by {$record.expire|date_format:"%b %d, %Y"}
									{/if}
								</div>
								
								<div class="item_type">
									{if is_array($record.format)}
									{assign var=imagePath value='/interface/themes/einetwork/images/Art/Materialicons'}
									    {foreach from=$record.format item=format}
										{if $format eq "Print Book"} 
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Book.png"/ alt="Print Book"></span>
										{elseif $format eq "Audio Book Download"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Audio Book Download"></span>
										{elseif $format eq "Blu-Ray"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BluRay.png" alt="Blu Ray"></span>
										{elseif $format eq "Large Print"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Book_largePrint.png" alt="Large Print"></span>
										{elseif $format eq "Book on CD"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnCD.png" alt="Book on CD"></span>
										{elseif $format eq "Book on MP3 Disc"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnMp3CD.png" alt="Book on MP3 Disc"></span>
										{elseif $format eq "Book on Tape"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnTape.png" alt="Book on Tape"></span>
										{elseif $format eq "CD-ROM"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/CDROM.png" alt="CD-ROM"></span>
										{elseif $format eq "Electronic Resource"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Electronic Resource"></span>    
										{elseif $format eq "Discussion Kit"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/DiscussionKit.png" alt="Discussion Kit"></span>
										{elseif $format eq "DVD"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/DVD.png" alt="DVD"></span>
										{elseif $format eq "Ebook Download"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png" alt="Ebook Download"></span>
										{elseif $format eq "Electronic Equipment"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/ElectronicEquipment.png" alt="Electronic Equipment"></span>
										{elseif $format eq "Print Image"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Image.png" alt="Print Image"></span>
										{elseif $format eq "Digital Image"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Image_digital.png" alt="Digital Image"></span>
										{elseif $format eq "Music LP/Cassette"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/LP.png" alt="Music LP/Cassette"></span>
										{elseif $format eq "Magazine"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Magazine.png" alt="Magazine"></span>
										{elseif $format eq "Online Periodical"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Magazine_online.png" alt="Online Periodical"></span>
										{elseif $format eq "Music CD"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicCD.png" alt="Music CD"></span>
										{elseif $format eq "Music Download"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png" alt="Music Download"></span>
										{elseif $format eq "Music Score"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicScore.png" alt="Music Score"></span>
										{elseif $format eq "Online Book"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png" alt="Online Book"></span>
										{elseif $format eq "Other Kits"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OtherKit.png" alt="Other Kits"></span>
										{elseif $format eq "Puppet"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Puppet.png" alt="Puppet"></span>
										{elseif $format eq "Puzzle"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Puzzle.png" alt="Puzzle"></span>
										{elseif $format eq "Video Cassette"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VHS.png" alt="VHS"></span>
										{elseif $format eq "Video Download"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Video Download"></span>
										{/if}
										    <span class="iconlabel" >{translate text=$format}</span>&nbsp;
									    {/foreach}
									{else}
									    {if $record.format eq "Print Book"} 
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Book.png" alt="Print Book"></span>
										{elseif $format eq "Audio Book Download"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Audio Book Download"></span>
										{elseif $format eq "Blu-Ray"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BluRay.png"/ alt="Blu Ray"></span>
										{elseif $format eq "Large Print"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Book_largePrint.png"/ alt="Large Print"></span>
										{elseif $format eq "Book on CD"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnCD.png"/ alt="Book on CD"></span>
										{elseif $format eq "Book on MP3 Disc"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnMp3CD.png"/ alt="Book on MP3 Disc"></span>
										{elseif $format eq "Book on Tape"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnTape.png"/ alt="Book on Tape"></span>
										{elseif $format eq "CD-ROM"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/CDROM.png"/ alt="CD-ROM"></span>
										{elseif $format eq "Electronic Resource"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Electronic Resource"></span>
										{elseif $format eq "Discussion Kit"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/DiscussionKit.png"/ alt="Discussion Kit"></span>
										{elseif $format eq "DVD"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/DVD.png"/ alt="DVD"></span>
										{elseif $format eq "Ebook Download"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
										{elseif $format eq "Electronic Equipment"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/ElectronicEquipment.png"/ alt="Electronic Equipment"></span>
										{elseif $format eq "Print Image"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Image.png"/ alt="Print Image"></span>
										{elseif $format eq "Digital Image"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Image_digital.png"/ alt="Digital Image"></span>
										{elseif $format eq "Music LP/Cassette"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/LP.png"/ alt="Music LP/Cassette"></span>
										{elseif $format eq "Magazine"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Magazine.png"/ alt="Magazine"></span>
										{elseif $format eq "Online Periodical"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Magazine_online.png"/ alt="Online Periodical"></span>
										{elseif $format eq "Music CD"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicCD.png"/ alt="Music CD"></span>
										{elseif $format eq "Music Download"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png"/ alt="Music Download"></span>
										{elseif $format eq "Music Score"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicScore.png"/ alt="Music Score"></span>
										{elseif $format eq "Online Book"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Online Book"></span>
										{elseif $format eq "Other Kits"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OtherKit.png"/ alt="Other Kits"></span>
										{elseif $format eq "Puppet"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Puppet.png"/ alt="Puppet"></span>
										{elseif $format eq "Puzzle"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Puzzle.png"/ alt="Puzzle"></span>
										{elseif $format eq "Video Cassette"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VHS.png"/ alt="VHS"></span>
										{elseif $format eq "Video Download"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Video Download"></span>
									    {/if}
										<span class="iconlabel" >{translate text=$record.format}</span>
									{/if}
								    </div>
							</div>
							
							
							<div class="item_status">
								{*****Freeze********************}
								{*****Unfreeze******************}
								{*****Cancel********************}
								{****Change Pick Up Location****}
								
								{if $record.status eq "Available"}
								
									<div class="requested_update_check">
								
										<input class="physical_items cancel_checkboxes" type="checkbox" name="data[{$record.cancelId}][cancel]" /> Cancel
										
									</div>
									
									<div class='holdsUpdateBranchSelection-Large'>
										Change Pickup Location to:<br />
										
										<select name="data[{$record.cancelId}][location]" class="physical_items update_all location_dropdown">
										   {html_options options=$pickupLocations selected=$record.currentPickupId}
										</select>
										
									</div>
									
								{elseif $record.status eq "Frozen"}
								
									<div class="requested_update_check">
								
										{if $record.frozen}
											<input id="frozen_state_on" class="physical_items freeze_checkboxes update_all" type="checkbox" name="data[{$record.cancelId}][freeze]" /> Unfreeze<br />
										{else}
											<input id="frozen_state_off" class="physical_items freeze_checkboxes update_all" type="checkbox" name="data[{$record.cancelId}][freeze]" /> Freeze<br />
										{/if}
									
										<input class="physical_items cancel_checkboxes" type="checkbox" name="data[{$record.cancelId}][cancel]" /> Cancel
									
									</div>
										
									<div class='holdsUpdateBranchSelection'>
										Change Pickup Location to:<br />
										
										<select name="data[{$record.cancelId}][location]" class="physical_items update_all location_dropdown">
										   {html_options options=$pickupLocations selected=$record.currentPickupId}
										</select>
										
									</div>
								
								{elseif $record.status eq "In Transit"}
								
									
								
								{elseif $record.status eq "Ready"}
								
								
								{else}
								
									<div class="requested_update_check">
								
										<input id="frozen_state_off" class="physical_items freeze_checkboxes update_all" type="checkbox" name="data[{$record.cancelId}][freeze]" /> Freeze<br />
										<input class="physical_items cancel_checkboxes" type="checkbox" name="data[{$record.cancelId}][cancel]" /> Cancel
								
									</div>
									
									<div class='holdsUpdateBranchSelection'>
										Change Pickup Location to:<br />
								
											<select name="data[{$record.cancelId}][location]" class="physical_items update_all location_dropdown">
											   {html_options options=$pickupLocations selected=$record.currentPickupId}
											</select>
											
									</div>
								
								{/if}
								
							</div>
						</div>
					{/foreach}
					
				</form>
					
				</div>

				{else}
					{if $sectionKey=='unavailable'}
						<div style="margin-left: 15px">{translate text='You do not have any outstanding physical requests.'}.</div>
					{/if}
				{/if}
			{/foreach}
			<br>
			<div class="hold-buttons">
				<div class="requested-items-button">
					{if $freezeButton eq 'freeze'}
						<a class="freeze-all-btn button" href="#">Freeze All</a>
					{else}
						<a class="unfreeze-all-btn button" href="#">Unfreeze All</a>
					{/if}
					<img class="qtip-freeze" src="/images/help_icon.png" />
				</div>
				<div class="requested-items-button">
					<a class="update-selected-btn button" href="#">Update Selected</a><img class="qtip-request-update" src="/images/help_icon.png" />
				</div>
			</div>
			
			{*****BEGIN Overdrive Holds******}
			<div style="margin-top: 20px;margin-bottom: 20px"><h3>{translate text='eContent Requests'}</h3></div>
			{if count($overDriveHolds.available) > 0}
				
				<div >&nbsp;&nbsp;&nbsp;&nbsp;Titles available for checkout</div>
				<div class="checkout">
					{foreach from=$overDriveHolds.available item=record}
					<div id="overdrive-request-available{$record.recordId}" class="record overdrive-available">
						<div class="item_image">
							<img src="{$record.imageUrl}">
						</div>
						<div class="item_detail">
							<div class="item_subject">
								{if $record.recordId != -1}
									<a href="{$path}/EcontentRecord/{$record.recordId}/Home">
								{/if}
								{$record.title}
								{if $record.recordId != -1}
									</a>
								{/if}
								{if $record.subTitle}<br/>{$record.subTitle}{/if}
							</div>
							<div class="item_author">
								{if strlen($record.author) > 0}<br/> {$record.author}{/if}
							</div>
						<!--	<div class="notify_email">Email notifcation will be sent to:<br/>{$record.notifyEmail}</div> -->
						</div>
						
						<div class="item_status" style="height: auto;min-height: 105px">
							
							<div>
								<input class="button yellow" type="button"  onclick="checkoutOverDriveItem('{$record.recordId}', 'Holds')"  value="Checkout"  style="padding-left: 0px;padding-right: 0px;color: #6D6D6D;" />

							</div>
							
						</div>
						

						
					</div>
					{/foreach}
				</div>
			
			{/if}
			{if count($overDriveHolds.holds.unavailable) > 0}
				<div>&nbsp&nbsp&nbsp&nbspRequested items not yet available</div>
				<div class="checkout">
					{foreach from=$overDriveHolds.holds.unavailable item=record}
					<div id="overdrive-request-unavailable{$record.recordId}" class="record overdrive-unavailable">
						<div class="item_image">
							<img src="{$record.imageUrl}">
						</div>
						<div class="item_detail">
							<div class="item_subject">
								{if $record.recordId != -1}
								<a href="{$path}/EcontentRecord/{$record.recordId}/Home">
								{/if}
								{$record.title}
								{if $record.recordId != -1}</a>
								{/if}
								{if $record.subTitle}<br/>{$record.subTitle}{/if}
							</div>
							<div class="item_author">
								{if strlen($record.author) > 0}<br/>{$record.author}{/if}
							</div>
							<div class="notify_email" style="margin-top:10px;">Email notification will be sent to:<br/>{$record.notifyEmail}</div>
						<!--	<div class="item_type">
								{$record.format}
								{if is_array($record.format)}
									{assign var=imagePath value='/interface/themes/einetwork/images/Art/Materialicons'}
									    {foreach from=$record.format item=format}
										{if $format eq "Print Book"} 
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Book.png"/ alt="Print Book"></span>
										{elseif $format eq "Audio Book Download"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Audio Book Download"></span>
										{elseif $format eq "Blu-Ray"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BluRay.png" alt="Blu Ray"></span>
										{elseif $format eq "Large Print"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Book_largePrint.png" alt="Large Print"></span>
										{elseif $format eq "Book on CD"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnCD.png" alt="Book on CD"></span>
										{elseif $format eq "Book on MP3 Disc"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnMp3CD.png" alt="Book on MP3 Disc"></span>
										{elseif $format eq "Book on Tape"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnTape.png" alt="Book on Tape"></span>
										{elseif $format eq "CD-ROM"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/CDROM.png" alt="Video Download"></span>
										{elseif $format eq "Discussion Kit"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/DiscussionKit.png" alt="Discussion Kit"></span>
										{elseif $format eq "DVD"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/DVD.png" alt="DVD"></span>
										{elseif $format eq "Ebook Download"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png" alt="Ebook Download"></span>
										{elseif $format eq "Electronic Equipment"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/ElectronicEquipment.png" alt="Electronic Equipment"></span>
										{elseif $format eq "Print Image"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Image.png" alt="Print Image"></span>
										{elseif $format eq "Digital Image"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Image_digital.png" alt="Digital Image"></span>
										{elseif $format eq "Music LP/Cassette"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/LP.png" alt="Music LP/Cassette"></span>
										{elseif $format eq "Magazine"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Magazine.png" alt="Magazine"></span>
										{elseif $format eq "Online Periodical"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Magazine_online.png" alt="Online Periodical"></span>
										{elseif $format eq "Music CD"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicCD.png" alt="Music CD"></span>
										{elseif $format eq "Music Download"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png" alt="Music Download"></span>
										{elseif $format eq "Music Score"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicScore.png" alt="Music Score"></span>
										{elseif $format eq "Online Book"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png" alt="Online Book"></span>
										{elseif $format eq "Other Kits"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OtherKit.png" alt="Other Kits"></span>
										{elseif $format eq "Puppet"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Puppet.png" alt="Puppet"></span>
										{elseif $format eq "Puzzle"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Puzzle.png" alt="Puzzle"></span>
										{elseif $format eq "Video Cassette"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VHS.png" alt="VHS"></span>
										{elseif $format eq "Video Download"}
										    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Video Download"></span>
										{/if}
										    <span class="iconlabel" >{translate text=$format}</span>&nbsp;
									    {/foreach}
									{else}
									    {if $record.format eq "Print Book"} 
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Book.png" alt="Print Book"></span>
										{elseif $format eq "Audio Book Download"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Audio Book Download"></span>
										{elseif $format eq "Blu-Ray"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BluRay.png"/ alt="Blu Ray"></span>
										{elseif $format eq "Large Print"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Book_largePrint.png"/ alt="Large Print"></span>
										{elseif $format eq "Book on CD"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnCD.png"/ alt="Book on CD"></span>
										{elseif $format eq "Book on MP3 Disc"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnMp3CD.png"/ alt="Book on MP3 Disc"></span>
										{elseif $format eq "Book on Tape"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/BookOnTape.png"/ alt="Book on Tape"></span>
										{elseif $format eq "CD-ROM"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/CDROM.png"/ alt="Video Download"></span>
										{elseif $format eq "Discussion Kit"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/DiscussionKit.png"/ alt="Discussion Kit"></span>
										{elseif $format eq "DVD"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/DVD.png"/ alt="DVD"></span>
										{elseif $format eq "Ebook Download"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
										{elseif $format eq "Electronic Equipment"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/ElectronicEquipment.png"/ alt="Electronic Equipment"></span>
										{elseif $format eq "Print Image"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Image.png"/ alt="Print Image"></span>
										{elseif $format eq "Digital Image"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Image_digital.png"/ alt="Digital Image"></span>
										{elseif $format eq "Music LP/Cassette"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/LP.png"/ alt="Music LP/Cassette"></span>
										{elseif $format eq "Magazine"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Magazine.png"/ alt="Magazine"></span>
										{elseif $format eq "Online Periodical"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Magazine_online.png"/ alt="Online Periodical"></span>
										{elseif $format eq "Music CD"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicCD.png"/ alt="Music CD"></span>
										{elseif $format eq "Music Download"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png"/ alt="Music Download"></span>
										{elseif $format eq "Music Score"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicScore.png"/ alt="Music Score"></span>
										{elseif $format eq "Online Book"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Online Book"></span>
										{elseif $format eq "Other Kits"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OtherKit.png"/ alt="Other Kits"></span>
										{elseif $format eq "Puppet"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Puppet.png"/ alt="Puppet"></span>
										{elseif $format eq "Puzzle"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Puzzle.png"/ alt="Puzzle"></span>
										{elseif $format eq "Video Cassette"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VHS.png"/ alt="VHS"></span>
										{elseif $format eq "Video Download"}
										<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Video Download"></span>
									    {/if}
										<span class="iconlabel" >{translate text=$record.format}</span>
									{/if}
							</div> -->
						</div>
						
						<div class="item_status" >
							<!--<div style="text-align: center"><span id="item_status{$record.recordId}" style="text-align: center">Total {$record.holdQueueLength} {if $record.holdQueueLength == 1}copy{else}copies{/if}</span></div>-->
		
							<div class="requested_update_check_econtent" style="width:100px;margin:20px 0 20px 44px;">
								
								<input class="econtent_items econtent_cancel_checkboxes" type="checkbox" name="{$record.overDriveId}" /> Cancel
							
							</div>

							<div id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" onclick="ajaxLightbox('/MyResearch/AJAX?method=editEmailPrompt&overDriveId={$record.overDriveId}', false, false, '300px','400px','auto')" style="padding-top:10px;"><span class="resultAction_span">Edit Email Address</span></div>

						</div>
						
					</div>
				    {/foreach}
				</div>	
			{else}
			<div style="margin-left: 10px">{translate text="You do not have any outstanding eContent requests. "}</div>
			{/if}
			{*****END Overdrive Holds*****}
			
		{else} {* Check to see if user is logged in *}
			You must login to view this information. Click <a href="{$path}/MyResearch/Login">here</a> to login.
		{/if}
	</div>
	<div id="right-bar">
		{include file="MyResearch/menu.tpl"}
		{include file="Admin/menu.tpl"}
	</div>
</div>
{literal}
<script type="text/javascript">
	
</script>
{/literal}
