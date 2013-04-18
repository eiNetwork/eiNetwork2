{if (isset($title)) }
<script type="text/javascript">
	alert("{$title}");
</script>
{/if}
<script type="text/javascript" src="{$path}/js/holds.js"></script>
<script type="text/javascript" src="{$path}/services/MyResearch/ajax.js"></script>
<script type="text/javascript" src="{$path}/js/tablesorter/jquery.tablesorter.min.js"></script>
<div id="page-content" class="content">
	<div id="left-bar">
		<div class="sort">
			<div id="sortLabel">
			{translate text='Sort by'}
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
			
			<div> 
				<h2>{translate text='Requested Items'}</h2>
				
			</div>
			{if $profile.expireclose == 1}
			<font color="red"><b>Your library card is due to expire within the next 30 days.  Please visit your local library to renew your card to ensure access to all online service.  </a></b></font>
			{elseif $profile.expireclose == -1}
			<font color="red"><b>Your library card is expired.  Please visit your local library to renew your card to ensure access to all online service.  </a></b></font>
			{/if}

			<div style="margin-top: 30px">
				<h3>Physical Requests</h3>
			</div>
			<div id='holdsUpdateBranchSelction' style=";padding-bottom: 10px;width: 660px">
				&nbsp&nbsp&nbsp&nbspChange Pickup Location to: 
				{html_options name="withSelectedLocation" options=$pickupLocations selected=$resource.currentPickupId}
				{*<input type="submit" name="updateSelected" value="Go" onclick="return updateSelectedHolds();"/>*}
			</div>
			{foreach from=$recordList item=recordData key=sectionKey}
				{if is_array($recordList.$sectionKey) && count($recordList.$sectionKey) > 0}
				<div class="checkout">
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
									<div id="{$record.cancelId}" disabled="disabled" name="waitingholdselected[]" class="round-rectangle-button" onclick="freezeSelectedHolds(this)" style="border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px"><span class="resultAction_span">Freeze</span></div>
									<div id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" onclick="cancelSelectedHolds(this)" style="border-radius:0px;border-bottom-width:0px"><span class="resultAction_span">Cancel</span></div>
									<div id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" onclick="updateSeledHold(this)" style="border-top-right-radius:0px;border-top-left-radius:0px"><span class="resultAction_span">Change Pick Up</span></div>
								
								{elseif $record.status eq "Frozen"}
									{if $record.frozen}
									<div id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" onclick="thawSelectedHolds(this)" style="border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px"><span class="resultAction_span">Unfreeze</span></div>
									{else}
									<div id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" onclick="freezeSelectedHolds(this) style="border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px""><span class="resultAction_span">Freeze</span></div>
									{/if}
									<div id="{$record.cancelId}" disabled="disabled" name="waitingholdselected[]" class="round-rectangle-button" onclick="cancelSelectedHolds(this)" style="border-radius:0px;border-bottom-width:0px"><span class="resultAction_span">Cancel</span></div>
									<div id="{$record.cancelId}" disabled="disabled" name="waitingholdselected[]" class="round-rectangle-button" onclick="updateSeledHold(this)" style="border-top-right-radius:0px;border-top-left-radius:0px"><span class="resultAction_span">Change Pick Up</span></div>
								{elseif $record.status eq "In Transit"}
									{*You can't do anything because item is in transit*}
									<input id="{$record.cancelId}" disabled="disabled" name="waitingholdselected[]" class="round-rectangle-button" value="Freeze" onclick="freezeSelectedHolds(this)" style="background-color: rgb(192,192,192);border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px; color: #FFFFFF;"/>
									<input id="{$record.cancelId}" disabled="disabled" name="waitingholdselected[]" class="round-rectangle-button" value="Cancel" onclick="cancelSelectedHolds(this)" style="background-color: rgb(192,192,192);border-radius:0px;border-bottom-width:0px; color: #FFFFFF;"/>
									<input id="{$record.cancelId}" disabled="disabled" name="waitingholdselected[]" class="round-rectangle-button" value="Change Pick Up" onclick="updateSeledHold(this)" style="background-color: rgb(192,192,192);border-top-right-radius:0px;border-top-left-radius:0px; color: #FFFFFF;"/>
								
								{elseif $record.status eq "Ready"}
									{*You can't do anything because item is ready to pick up*}
									<input id="{$record.cancelId}" disabled="disabled" name="waitingholdselected[]" class="round-rectangle-button" value="Freeze" onclick="freezeSelectedHolds(this)" style="background-color: rgb(192,192,192);border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px; color: #FFFFFF;"/>
									<input id="{$record.cancelId}" disabled="disabled" name="waitingholdselected[]" class="round-rectangle-button" value="Cancel" onclick="cancelSelectedHolds(this)" style="background-color: rgb(192,192,192);border-radius:0px;border-bottom-width:0px; color: #FFFFFF;"/>
									<input id="{$record.cancelId}" disabled="disabled" name="waitingholdselected[]" class="round-rectangle-button" value="Change Pick Up" onclick="updateSeledHold(this)" style="background-color: rgb(192,192,192);border-top-right-radius:0px;border-top-left-radius:0px; color: #FFFFFF;"/>
								
								{elseif $record.status eq "Frozen"}
									{*You can't do anything because item is ready to pick up*}
									<input id="{$record.cancelId}" disabled="disabled" name="waitingholdselected[]" class="round-rectangle-button" value="Freeze" onclick="freezeSelectedHolds(this)" style="background-color: rgb(192,192,192);border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px; color: #FFFFFF;"/>
									<input id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" value="Cancel" onclick="cancelSelectedHolds(this)" style="background-color: rgb(192,192,192);border-radius:0px;border-bottom-width:0px; color: #FFFFFF;"/>
									<input id="{$record.cancelId}" disabled="disabled" name="waitingholdselected[]" class="round-rectangle-button" value="Change Pick Up" onclick="updateSeledHold(this)" style="background-color: rgb(192,192,192);color: border-top-right-radius:0px;border-top-left-radius:0px; color: #FFFFFF;"/>
								
								{else}
									<div id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" onclick="freezeSelectedHolds(this)"style="border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px" ><span class="resultAction_span">Freeze</span></div>
									<div id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" onclick="cancelSelectedHolds(this)" style="border-radius:0px;border-bottom-width:0px"><span class="resultAction_span">Cancel</span></div>
									<div id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" onclick="updateSeledHold(this)" style="border-top-right-radius:0px;border-top-left-radius:0px"><span class="resultAction_span">Change Pick Up</span></div>
								{/if}
								
								
							
								{*if $record.frozen}
								<input id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" value="Unfreeze" onclick="thawSelectedHolds(this)" style="border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px; color: #6D6D6D;"/>
								{else}
								<input id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" value="Freeze" onclick="freezeSelectedHolds(this)" style="border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px; color: #6D6D6D;"/>
								{/if}
								<input id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" value="Cancel" onclick="cancelSelectedHolds(this)" style="border-radius:0px;border-bottom-width:0px; color: #6D6D6D;"/>
								<input id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" value="Change Pick Up" onclick="updateSeledHold(this)" style="border-top-right-radius:0px;border-top-left-radius:0px; color: #6D6D6D;"/>
								*}
							</div>
						</div>
					{/foreach}
					
				</div>

				{else}
					{if $sectionKey=='unavailable'}
						<div style="margin-left: 15px">{translate text='You do not have any physical request that are not available yet'}.</div>
					{/if}
				{/if}
			{/foreach}
			
			{*****BEGIN Overdrive Holds******}
			<div style="margin-top: 20px;margin-bottom: 20px"><h3>{translate text='eContent Requests'}</h3></div>
			{if count($overDriveHolds.available) > 0}
				
				<div >&nbsp&nbsp&nbsp&nbspTitles available for checkout</div>
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
			{if count($overDriveHolds.unavailable) > 0}
				<div>&nbsp&nbsp&nbsp&nbspRequested items not yet available</div>
				<div class="checkout">
					{foreach from=$overDriveHolds.unavailable item=record}
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
							<div class="notify_email" style="margin-top:10px;">Email notifcation will be sent to:<br/>{$record.notifyEmail}</div>
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
		
							<div id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" onclick="cancelOverDriveHold('{$record.overDriveId}')" style="border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px"><span class="resultAction_span">Cancel</span></div>
							<div id="{$record.cancelId}" name="waitingholdselected[]" class="round-rectangle-button" onclick="ajaxLightbox('/MyResearch/AJAX?method=editEmailPrompt&overDriveId={$record.overDriveId}', false, false, '300px','400px','auto')" style="border-top-right-radius:0px;border-top-left-radius:0px"><span class="resultAction_span">Edit</span></div>
						</div>
						
						
						
					</div>
				    {/foreach}
				</div>	
			{else}
			<div style="margin-left: 10px">{translate text="You do not have any eContent requests that are not available yet. "}</div>
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