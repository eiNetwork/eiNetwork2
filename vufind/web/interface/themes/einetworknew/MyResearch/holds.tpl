{if (isset($title)) }
<script type="text/javascript">
	alert("{$title}");
</script>
{/if}
<script type="text/javascript" src="{$path}/js/holds.js"></script>
<script type="text/javascript" src="{$path}/services/MyResearch/ajax.js"></script>
<script type="text/javascript" src="{$path}/js/tablesorter/jquery.tablesorter.min.js"></script>
{literal}
<script type="text/javascript">

	$(document).ready(function(){

		var expanded = true;

		// expand and collapse functions
		$('.collapse').each(function(){
			$(this).on('show.bs.collapse', function () {
				$(this).parent().parent().find('.accordion-toggle').removeClass('accordion-toggle-expand').addClass('accordion-toggle-collapse');
				$(this).parent().find('.results-header').hide();
			})

			$(this).on('hide.bs.collapse', function () {
				$(this).parent().parent().find('.accordion-toggle').removeClass('accordion-toggle-collapse').addClass('accordion-toggle-expand');
				$(this).parent().find('.results-header').show();
			})
		})

		$('#show-all-button').click(function(){

			if (expanded == true){
				$('.accordion-body').collapse('hide');
				$('#show-all-button').val('Full View');
				expanded = false;
			} else {
				$('.accordion-body').collapse('show');
				$('#show-all-button').val('Brief View');
				expanded = true;
			}

		})

		var location_id = 0;

		$('.dropdown-pickup-locations-expanded a').click(function(){
			location_id = $(this).data('location');
			$(this).parent().parent().parent().prev().val($(this).text());
			$(this).parent().parent().parent().parent().parent().parent().parent().parent().parent().parent().prev().find('.pickup-location-text').val($(this).text());
			$(this).parent().parent().parent().parent().parent().parent().parent().parent().parent().parent().parent().parent().parent().prev().val(location_id).trigger('change');
		})

		$('.dropdown-pickup-locations-collapsed a').click(function(){
			location_id = $(this).data('location');
			$(this).parent().parent().parent().prev().val($(this).text());
			$(this).parent().parent().parent().parent().parent().parent().parent().next().find('.pickup-location-text').val($(this).text());
			$(this).parent().parent().parent().parent().parent().parent().parent().parent().parent().parent().prev().val(location_id).trigger('change');
		})

		$('.econtent_cancel_checkboxes_expanded').click(function(){

			if ($(this).prop('checked') == true){
				$(this).parent().parent().parent().parent().parent().parent().prev().find('.econtent_cancel_checkboxes').prop('checked', true);
			} else {
				$(this).parent().parent().parent().parent().parent().parent().prev().find('.econtent_cancel_checkboxes').prop('checked', false);
			}

		})

		$('.econtent_cancel_checkboxes_collapsed').click(function(){

			if ($(this).prop('checked') == true){
				$(this).parent().parent().parent().parent().next().find('.econtent_cancel_checkboxes').prop('checked', true);
			} else {
				$(this).parent().parent().parent().parent().next().find('.econtent_cancel_checkboxes').prop('checked', false);
			}

		})


	});

</script>
{/literal}
<div class="row">
	<div class="col-xs-9 col-md-9">

		<div class="sort pull-right" style="width:220px">
			<div class="sortOptions">
				<label class="pull-right">{translate text='Sort by'}
					<select name="accountSort" id="sort{$sectionKey}" onchange="changeAccountSort($(this).val());">
						{foreach from=$sortOptions item=sortDesc key=sortVal}
						<option value="{$sortVal}"{if $defaultSortOption == $sortVal} selected="selected"{/if}>{translate text=$sortDesc}</option>
						{/foreach}
					</select>
				</label>
			</div>
		</div>
	
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
				<h2 style="margin-top:0px">{translate text='Requested Items'}</h2>
			</div>
			
			{if $profile.expireclose == 1}
			<font color="red"><b>Your library card is due to expire within the next 30 days.  Please visit your local library to renew your card to ensure access to all online service.  </a></b></font>
			{elseif $profile.expireclose == -1}
			<font color="red"><b>Your library card is expired.  Please visit your local library to renew your card to ensure access to all online service.  </a></b></font>
			{/if}


			<div style="margin-top: 30px">
				<h3>Physical Requests</h3>
			</div>

			<div class="row list-header">
				<div class="col-xs-2 col-md-2">
					<div class="input-group show-all-button">
						<input type="button" id="show-all-button" class="btn btn-small btn-default form-control" value="Brief View" />
						<span class="input-group-addon">
							Save <input type="checkbox">
						</span>
					</div>
				</div>
				<div class="col-xs-10 col-md-10 btn-renew-all">
					{if $freezeButton eq 'freeze'}
						<button type="button" class="btn btn-warning" id="freeze-all-btn">Freeze All</button>
					{else}
						<button type="button" class="btn btn-warning" id="unfreeze-all-btn" href="#">Unfreeze All</button>
					{/if}
					<button type="button" class="btn btn-warning" id="update-selected-btn">Update Selected</button>
				</div>
			</div>

			{foreach from=$recordList item=recordData key=sectionKey}
			
				{if is_array($recordList.$sectionKey) && count($recordList.$sectionKey) > 0}

					{foreach from=$recordList.$sectionKey item=record name="recordLoop"}

						<!-- 

							The location dropdown is really a custom dropdown using list items and links. When an item is selected it populates 
							this hidden field with the value. Also, because there is two dropdowns (collapsed and expanded), ive placed 
							the hidden field at the start of loop. The javascript can be found for this on top and in holds.js

						-->
	
						{if $record.locationUpdateable}
							<input type="hidden" class="location_dropdown physical_items update_all" name="data[{$record.cancelId}][location]" value="{$record.currentPickupId}">				
						{/if}

						<div class="row">
						    <div class="col-xs-12 col-md-12">
						    	<a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{$record.shortId|escape}"></a>
						        <div class="accordion-group">
						        	<div class="accordion-heading">

						        	</div>
						        	<div class="results-header clearfix">
						            	<div class="row results-title-header">
						            		<div class="col-xs-12 col-md-12 results-title">
							        			<a href="{$url}/Record/{$record.recordId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title">
													{if !$record.title|regex_replace:"/(\/|:)$/":""}
													{translate text='Title not available'}
													{else}
													{$record.title|regex_replace:"/(\/|:)$/":""|truncate:60:"..."|highlight:$lookfor}
													{/if}
												</a>
												| <span class="author">
														{if $record.author}
															{if is_array($record.author)}
																{foreach from=$summAuthor item=author}
																	<a href="{$url}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
																{/foreach}
															{else}
																<a href="{$url}/Author/Home?author={$record.author|escape:"url"}">{$record.author|highlight:$lookfor}</a>
															{/if}
														{/if}
													</span>
							        		</div>
							        	</div>
							        	<div class="row results-status-header">
					        				<div class="col-xs-4 col-md-4">
				        						<p><span class="label {if $record.status == 'Pending' }label-warning{else}label-success{/if} label-requested-results">
					                        		{$record.status}
													{if $record.expire}
														for pick up by {$record.expire|date_format:"%b %d, %Y"}
													{/if}
					                        	</span></p>
					        				</div>
						                    <div class="col-xs-5 col-md-5">
						                    	{if $record.currentPickupId ||  $record.location eq '' || $record.location eq "No location selected"}
						                    		<div class="input-group">
							                    		<input type="text" class="form-control pickup-location-text" placeholder="Change Pickup Location" value="{$record.location}">
															<div class="input-group-btn">
					    										<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
					    										<ul class="dropdown-menu pull-right dropdown-pickup-locations-collapsed">
					    											{foreach from=$pickupLocations key=key item=location}
																		<li><a href="#" class="disable-link" data-location="{$key}">{$location}</a></li>
																	{/foreach}
					    										</ul>
					  										</div><!-- /btn-group -->
													</div><!-- /input-group -->
												{else}
													<div class="well well-sm location-well">{$record.location}</div>
												{/if}
					                        </div><!-- /change pickup -->
					                        <div class="col-xs-3 col-md-3">

					                        	<div class="row">

					                        		{if $record.status eq "Available"}

							                    		 <div class="col-xs-4 col-md-4" style="text-align: center">
								                        	<label>
																<span class="label label-default label-requested-results">Cancel</span><br /><input type="checkbox" class="form-control titleSelect cancel_checkboxes physical_items" name="selected[{$record.renewIndicator}]" id="selected{$record.itemid}" />
															</label>
								                        </div>
							                        
							                        {elseif $record.status eq "Frozen"}

							                    		<div class="col-xs-4 col-md-4" style="text-align: center">
								                        	<label>
																<span class="label label-default label-requested-results">Unfreeze</span><br /><input id="frozen_state_on" type="checkbox" class="form-control titleSelect freeze_checkboxes physical_items update_all" name="data[{$record.cancelId}][freeze]" />
															</label>
								                        </div>
								                        <div class="col-xs-4 col-md-4" style="text-align: center">
								                        	<label>
																<span class="label label-default label-requested-results">Cancel</span><br /><input type="checkbox" class="form-control titleSelect cancel_checkboxes physical_items" name="selected[{$record.renewIndicator}]" id="selected{$record.itemid}" />
															</label>
								                        </div>

							                        {elseif $record.status eq "In Transit"}
								
														<div class="col-xs-4 col-md-4" style="text-align: center">
								                        	<br /><br />
								                        </div>
								
													{elseif $record.status eq "Ready"}

														<div class="col-xs-4 col-md-4" style="text-align: center">
								                        	<br /><br />
								                        </div>
								
													{else}

								                        <div class="col-xs-4 col-md-4 pull-right" style="text-align: center; margin:-21px 45px 0 0">
								                        	<label>
																<span class="label label-default label-requested-results">Cancel</span><br /><input type="checkbox" class="form-control titleSelect cancel_checkboxes physical_items" name="selected[{$record.renewIndicator}]" id="selected{$record.itemid}" />
															</label>
								                        </div>
								                        <div class="col-xs-4 col-md-4 pull-right" style="text-align: center; margin:-21px 5px 0 0">
								                        	<label>
																<span class="label label-default label-requested-results">Freeze</span><br /><input id="frozen_state_off" type="checkbox" class="form-control titleSelect freeze_checkboxes physical_items update_all" name="data[{$record.cancelId}][freeze]" />
															</label>
								                        </div>

							                        {/if}

					                        	</div>
					                        </div>
					                    </div>
					                </div>
						            <div id="collapse{$record.shortId|escape}" class="accordion-body collapse in">
						                <div class="accordion-inner requested-results-striped clearfix">

						                	<div class="col-xs-2 col-md-2 col-lg-2 cover-image">
												{if $user->disableCoverArt != 1}
													<a class="thumbnail" href="{$url}/Record/{$record.recordId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{$record.recordId|escape:"url"}">
														<img src="{$coverUrl}/bookcover.php?id={$record.recordId}&amp;isn={$record.isbn|@formatISBN}&amp;size=small&amp;upc={$record.upc}&amp;category={$record.format_category.0|escape:"url"}" alt="{translate text='Cover Image'}"/>
													</a>
												{/if}
											</div>
											<div class="col-xs-10 col-md-10">

												<div class="row">
													<div class="col-xs-8 col-md-8">
														<ul class="requested-results">
															<li class"results-title">
																	<a href="{$url}/Record/{$record.recordId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title">
																	{if !$record.title|regex_replace:"/(\/|:)$/":""}
																	{translate text='Title not available'}
																	{else}
																	{$record.title|regex_replace:"/(\/|:)$/":""|truncate:60:"..."|highlight:$lookfor}
																	{/if}
																</a>
															</li>
															<li>
																<span class="author">{if $record.author}
																	{if is_array($record.author)}
																		{foreach from=$summAuthor item=author}
																			<a href="{$url}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
																		{/foreach}
																	{else}
																		<a href="{$url}/Author/Home?author={$record.author|escape:"url"}">{$record.author|highlight:$lookfor}</a>
																	{/if}
																{/if}</span>
															</li>
														</ul>
													</div>
													<div class="col-xs-4 col-md-4">
														<div class="row requested-results-actions-checkboxes">

								                    		{if $record.status eq "Available"}

									                    		 <div class="col-xs-4 col-md-4 col-md-offset-8" style="text-align: center">
										                        	<label>
																		<span class="label label-default label-requested-results">Cancel</span><br /><input type="checkbox" class="form-control titleSelect cancel_checkboxes physical_items" name="selected[{$record.renewIndicator}]" id="selected{$record.itemid}" />
																	</label>
										                        </div>
									                        
									                        {elseif $record.status eq "Frozen"}

									                    		<div class="col-xs-4 col-md-4 col-md-offset-4" style="text-align: center">
										                        	<label>
																		<span class="label label-default label-requested-results">Unfreeze</span><br /><input id="frozen_state_on" type="checkbox" class="form-control titleSelect freeze_checkboxes physical_items update_all" name="data[{$record.cancelId}][freeze]" />
																	</label>
										                        </div>
										                        <div class="col-xs-4 col-md-4" style="text-align: center">
										                        	<label>
																		<span class="label label-default label-requested-results">Cancel</span><br /><input type="checkbox" class="form-control titleSelect cancel_checkboxes physical_items" name="selected[{$record.renewIndicator}]" id="selected{$record.itemid}" />
																	</label>
										                        </div>

									                        {elseif $record.status eq "In Transit"}
										
																<div class="col-xs-4 col-md-4 col-md-offset-4" style="text-align: center; height: 48px">
										                        	
										                        </div>
										
															{elseif $record.status eq "Ready"}

																<div class="col-xs-4 col-md-4 col-md-offset-4" style="text-align: center; height: 48px">
										                        	
										                        </div>
										
															{else}

																
										                        <div class="col-xs-4 col-md-4 pull-right" style="text-align: center;  margin:0 25px 0 0">
										                        	<label>
																		<span class="label label-default label-requested-results">Cancel</span><br /><input type="checkbox" class="form-control titleSelect cancel_checkboxes physical_items" name="selected[{$record.renewIndicator}]" id="selected{$record.itemid}" />
																	</label>
										                        </div>
										                        <div class="col-xs-4 col-md-4 pull-right" style="text-align: center;">
										                        	<label>
																		<span class="label label-default label-requested-results">Freeze</span><br /><input id="frozen_state_off" type="checkbox" class="form-control titleSelect freeze_checkboxes physical_items update_all" name="data[{$record.cancelId}][freeze]" />
																	</label>
										                        </div>

									                        {/if}

								                    	</div>
													</div>
												</div>

												<div class="row">
													<div class="col-xs-6 col-md-6">
														<ul class="requested-results">
															<li class="requested-results-format">
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
															</li>
															<li class="label-requested-results">
																<p>
																	<span class="label {if $record.status == 'Pending' }label-warning{elseif $record.status == 'Frozen'}label-info{else}label-success{/if}">
									                        			{$record.status}
																		{if $record.expire}
																			for pick up by {$record.expire|date_format:"%b %d, %Y"}
																		{/if}
										                        	</span>
										                        </p>
							                        		</li>
							                        	</ul>
													</div>
													<div class="col-xs-6 col-md-6 pickup-location-container">
														<div class="row pickup-location-expanded">
								                    		<label>Pickup Location</label>
								                    	</div>
								                    	<div class="row">
								                    		{if $record.currentPickupId ||  $record.location eq '' || $record.location eq "No location selected"}
									                    		<div class="input-group requested-results-actions-location">
										                    		<input type="text" class="form-control pickup-location-text" placeholder="Change Pickup Location" value="{$record.location}">
																		<div class="input-group-btn">
								    										<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
								    										<ul class="dropdown-menu pull-right dropdown-pickup-locations-expanded">
								    											{foreach from=$pickupLocations key=key item=location}
																					<li><a href="#" class="disable-link" data-location="{$key}">{$location}</a></li>
																				{/foreach}
								    										</ul>
								  										</div><!-- /btn-group -->
																</div><!-- /input-group -->
															{else}
																<div class="well well-sm location-well">{if $record.location}{$record.location}{else}No Location Set{/if}</div>
															{/if}
								                    	</div>
													</div>
												</div>
											</div>
						                </div><!-- /accordion-inner -->
						            </div><!-- /collapsed -->
						        </div><!-- /accordion-group -->
						    </div>
						</div><!-- /resuts row -->

					{/foreach}

				{else}
					{if $sectionKey=='unavailable'}
						<div style="margin-left: 15px">{translate text='You do not have any physical request that are not available yet'}.</div>
					{/if}
				{/if}

			{/foreach}


			
			{*****BEGIN Overdrive Holds******}

			<div style="margin-top: 20px;margin-bottom: 20px"><h3>{translate text='eContent Requests'}</h3></div>

			{if count($overDriveHolds.available) > 0}

				<div style="margin-top: 20px;margin-bottom: 20px"><h4>{translate text='Requested items available'}</h4></div>

				{foreach from=$overDriveHolds.available item=record}

					<div class="row">
					    <div class="col-xs-12 col-md-12">
					    	<a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{$record.shortId|escape}"></a>
					        <div class="accordion-group">
					        	<div class="accordion-heading">

					        	</div>
					        	<div class="results-header clearfix">
					            	<div class="row results-title-header">
					            		<div class="col-xs-10 col-md-10 results-title">
						        			{if $record.recordId != -1}
												<a href="{$path}/EcontentRecord/{$record.recordId}/Home">
											{/if}
											{$record.title}
											{if $record.recordId != -1}
												</a>
											{/if}
											| <span class="author">{if strlen($record.author) > 0}{$record.author}{/if}</span>
						        		</div>
						        		<div class="col-xs-2 col-md-2">
				                        	<input class="btn btn-info" type="button" onclick="checkoutOverDriveItem('{$record.recordId}', 'Holds')"  value="Checkout" />
				                        </div>
						        	</div>
				                </div>
					            <div id="collapse{$record.shortId|escape}" class="accordion-body collapse in">
					                <div class="accordion-inner requested-results-striped clearfix">
					                	<div class="col-xs-2 col-md-2 col-lg-2 cover-image">
											<a href="" class="thumbnail disable-link"><img src="{$record.imageUrl}"></a>
										</div>
										<div class="col-xs-10 col-md-10">

											<div class="row">
												<div class="col-xs-6 col-md-6">
													<ul class="requested-results">
														<li class="results-title">
															{if $record.recordId != -1}
																<a href="{$path}/EcontentRecord/{$record.recordId}/Home">
															{/if}
															{$record.title}
															{if $record.recordId != -1}
																</a>
															{/if}
														</li>
														<li>
															<span class="author">{if strlen($record.author) > 0}{$record.author}{/if}</span>
														</li>
													</ul>
												</div>
												<div class="col-xs-6">
													<label class="pull-right" style="text-align: center; margin:0 10px 0 0">
														<input class="btn btn-info" type="button" onclick="checkoutOverDriveItem('{$record.recordId}', 'Holds')"  value="Checkout" />
													</label>
												</div>
											</div>
										</div>
					                </div><!-- /accordion-inner -->
					            </div><!-- /collapsed -->
					        </div><!-- /accordion-group -->
					    </div>
					</div><!-- /resuts row -->

				{/foreach}
			{/if}

			{if count($overDriveHolds.unavailable) > 0}

				<div style="margin-top: 20px;margin-bottom: 20px"><h4>{translate text='Requested items not yet available'}</h4></div>

				{foreach from=$overDriveHolds.unavailable item=record}

					<div class="row">
					    <div class="col-xs-12 col-md-12">
					    	<a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{$record.shortId|escape}"></a>
					        <div class="accordion-group">
					        	<div class="accordion-heading">

					        	</div>
					        	<div class="results-header clearfix">
					            	<div class="row results-title-header">
					            		<div class="col-xs-6 col-md-6 results-title">
						        			{if $record.recordId != -1}
												<a href="{$path}/EcontentRecord/{$record.recordId}/Home">
											{/if}
											{$record.title}
											{if $record.recordId != -1}
												</a>
											{/if}
											| <span class="author">{if strlen($record.author) > 0}{$record.author}{/if}</span>
						        		</div>
						        		<div class="col-xs-4 col-md-4">
				                        	<input class="form-control pull-left" value="{$record.notifyEmail}" type="text" placeholder="Email Address" />
				                        </div>
						        		<div class="col-xs-2 col-md-2">
				                        	<label style="text-align: center; margin:0 0 0 28px">
												<span class="label label-default label-requested-results">Cancel</span><br /><input type="checkbox" class="econtent_items econtent_cancel_checkboxes econtent_cancel_checkboxes_collapsed" name="{$record.overDriveId}" />
											</label>
				                        </div>
						        	</div>
				                </div>
					            <div id="collapse{$record.shortId|escape}" class="accordion-body collapse in">
					                <div class="accordion-inner requested-results-striped clearfix">
					                	<div class="col-xs-2 col-md-2 col-lg-2 cover-image">
											<a href="" class="thumbnail disable-link"><img src="{$record.imageUrl}"></a>
										</div>
										<div class="col-xs-10 col-md-10">

											<div class="row">
												<div class="col-xs-6 col-md-6">
													<ul class="requested-results">
														<li class="results-title">
															{if $record.recordId != -1}
																<a href="{$path}/EcontentRecord/{$record.recordId}/Home">
															{/if}
															{$record.title}
															{if $record.recordId != -1}
																</a>
															{/if}
														</li>
														<li>
															<span class="author">{if strlen($record.author) > 0}{$record.author}{/if}</span>
														</li>
													</ul>
												</div>
												<div class="col-xs-6">
													<label class="pull-right" style="text-align: center; margin:0 10px 0 0">
														<span class="label label-default label-requested-results">Cancel</span><br /><input type="checkbox" class="econtent_items econtent_cancel_checkboxes econtent_cancel_checkboxes_expanded" name="{$record.overDriveId}" />
													</label>
												</div>
											</div>

											<div class="row">
												<div class="col-xs-6 col-md-6">
													<p style="margin:20px 0 0 0">Email notification will be sent to:</p>
												</div>
												<div class="col-xs-6 col-md-6">
													<input class="form-control" type="text" value="{$record.notifyEmail}" placeholder="Edit Email Address" style="margin:10px 10px 0 0" />
												</div>
											</div>

										</div>
					                </div><!-- /accordion-inner -->
					            </div><!-- /collapsed -->
					        </div><!-- /accordion-group -->
					    </div>
					</div><!-- /resuts row -->

				{/foreach}

			{else}
				<div style="margin-left: 10px">{translate text="You do not have any eContent requests that are not available yet. "}</div>
			{/if}
			{*****END Overdrive Holds*****}
				
			
		{else} {* Check to see if user is logged in *}
			You must login to view this information. Click <a href="{$path}/MyResearch/Login">here</a> to login.
		{/if}
	</div>
	<div class="col-xs-3 col-md-3 clearfix">
		{include file="MyResearch/menu.tpl"}
		{include file="Admin/menu.tpl"}
	</div>
</div>