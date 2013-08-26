<script type="text/javascript" src="{$url}/services/MyResearch/ajax.js"></script>
<script type="text/javascript" src="{$url}/services/EcontentRecord/ajax.js"></script>
<script type="text/javascript" src="{$path}/js/checkedout.js"></script>
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

	});

</script>
{/literal}

{if (isset($title)) }
<script type="text/javascript">

    alert("{$title}");

</script>
{/if}


{literal}
<script type="text/javascript">

	$(document).ready(function(){

		var renewMessage = 0
		var modal_content = ''

		{/literal}{foreach from=$transList item=record name="recordLoop"}

			{if $record.renewMessage}{literal}

				renewMessage = 1;

				modal_content = modal_content + "<div class='renew-message'><strong>{/literal}{$record.title|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}{literal}</strong><br />" 
				
				if ('{/literal}{$record.renewMessage}{literal}' == 'Your item was successfully renewed'){
					modal_content = modal_content + "<span class='renew-message-success'>{/literal}{$record.renewMessage}{literal}</span></div>"
				} else {
					modal_content = modal_content + "<span class='renew-message-fail'>{/literal}{$record.renewMessage}{literal}</span></div>"
				}

			{/literal}{/if}

		{/foreach}{literal}

		if (renewMessage == 1){
			$('#eiNetworkModal').modal('show');
			$('#eiNetworkModal .modal-title').text('Your Item Renewals');
			$('#eiNetworkModal .modal-body').html(modal_content);
		}

	});

</script>
{/literal}


<div class="row">
	<div class="col-xs-9 col-md-9">
			<div class="sort pull-right">
				<div class="sortOptions">
					<label>{translate text='Sort by'}
						<select name="accountSort" id="sort{$sectionKey}" onchange="changeAccountSort($(this).val());">
							{foreach from=$sortOptions item=sortDesc key=sortVal}
							<option value="{$sortVal}"{if $defaultSortOption == $sortVal} selected="selected"{/if}>{translate text=$sortDesc}</option>
							{/foreach}
						</select>
					</label>
				</div>
			</div>

			<div> 
				<h2 style="margin-top:0px">{translate text='Checked Out Items'}</h2>
			</div>

			{if $profile.expireclose == 1}
			    <font color="red"><b>Your library card is due to expire within the next 30 days.  Please visit your local library to renew your card to ensure access to all online service.  </a></b></font>
			{/if}

			<div style="margin-top: 30px">
				<h3>{translate text='Physical Checked Out Items'}</h3>
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
					<button type="button" class="btn btn-warning" onclick="return renewSelectedTitles();">Renew Selected Items</button>
				</div>
			</div>

			<form id="renewForm" action="{$path}/MyResearch/CheckedOut">

				{foreach from=$transList item=record name="recordLoop"}

					<div class="row">
					    <div class="col-xs-12 col-md-12">
					    	<a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{$record.shortId|escape}"></a>
					        <div class="accordion-group">
					        	<div class="accordion-heading">

					        	</div>
					        	<div class="results-header clearfix">
					            	<div class="row results-title-header">
					            		<div class="col-xs-8 col-md-8 results-title">
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

											<div class="row results-status-header">
						        				<div class="col-xs-12 col-md-12">
						        					<p><span class="label label-info label-requested-results">Due On&nbsp;{$record.duedate|date_format}</span>		
														{if $record.overdue}
														    <span class="label label-danger label-requested-results">OVERDUE</span>
														{elseif $record.daysUntilDue == 0}
														    <span class="label label-danger label-requested-results">Due Today</span>
														{elseif $record.daysUntilDue == 1}
														    <span class="label label-warning label-requested-results">Due Tomorrow</span>
														{elseif $record.daysUntilDue <= 7}
														    <span class="label label-warning label-requested-results">Due in {$record.daysUntilDue} Days</span>
														{/if}


														{if $record.fine}
														    <span class="label label-danger label-requested-results">FINE {$record.fine}</span>
														{/if}

														{if $record.renewCount == 1}
														    <span class="label label-default label-requested-results">Renewed&nbsp;{$record.renewCount}&nbsp;time</span>
														{elseif $record.renewCount > 1}
														    <span class="label label-default label-requested-results">Renewed&nbsp;{$record.renewCount}&nbsp;times</span>
														{/if}
						                        	</p>
						        				</div>
						                    </div>
						        		</div>
						        		<div class="col-xs-4 col-md-4">
				                    		{if $patronCanRenew}
					                    		{assign var=id value=$record.id scope="global"}
											    {assign var=shortId value=$record.shortId scope="global"}
											    {* disable renewals if the item is overdue *}  
											    {if $record.overdue}
											    <!--
											    	<input type="checkbox" disabled="disabled" name="selected[{$record.renewIndicator}]" class="titleSelect" id="selected{$record.itemid}" />&nbsp;&nbsp;Renew&nbsp;			    
												-->			    
												{else}

													<label class="pull-right label-checkedout-results">
														<span class="label label-default label-requested-results">Renew</span><br /><input type="checkbox" class="form-control titleSelect freeze_checkboxes physical_items update_all" name="selected[{$record.renewIndicator}]" id="selected{$record.itemid}" />
													</label>

				                        		{/if}
										    {/if}
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
														{if $patronCanRenew}
								                    		{assign var=id value=$record.id scope="global"}
														    {assign var=shortId value=$record.shortId scope="global"}
														    {* disable renewals if the item is overdue *}  
														    {if $record.overdue}
														    <!--
														    	<input type="checkbox" disabled="disabled" name="selected[{$record.renewIndicator}]" class="titleSelect" id="selected{$record.itemid}" />&nbsp;&nbsp;Renew&nbsp;			    
															-->			    
															{else}

																<label class="pull-right">
																	<span class="label label-default label-requested-results">Renew</span><br /><input type="checkbox" class="form-control titleSelect freeze_checkboxes physical_items update_all" name="selected[{$record.renewIndicator}]" id="selected{$record.itemid}" />
																</label>

							                        		{/if}
													    {/if}
												</div>
											</div>

											<div class="row">
												<div class="col-xs-12 col-md-12">
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
															<p><span class="label label-info label-requested-results">Due On&nbsp;{$record.duedate|date_format}</span>
															
																{if $record.overdue}
																    <span class="label label-danger label-requested-results">OVERDUE</span>
																{elseif $record.daysUntilDue == 0}
																    <span class="label label-danger label-requested-results">Due Today</span>
																{elseif $record.daysUntilDue == 1}
																    <span class="label label-warning label-requested-results">Due Tomorrow</span>
																{elseif $record.daysUntilDue <= 7}
																    <span class="label label-warning label-requested-results">Due in {$record.daysUntilDue} Days</span>
																{/if}


																{if $record.fine}
																    <span class="label label-danger label-requested-results">FINE {$record.fine}</span>
																{/if}

																{if $record.renewCount == 1}
																    <span class="label label-default label-requested-results">Renewed&nbsp;{$record.renewCount}&nbsp;time</span>
																{elseif $record.renewCount > 1}
																    <span class="label label-default label-requested-results">Renewed&nbsp;{$record.renewCount}&nbsp;times</span>
																{/if}
								                        	</p>
						                        		</li>
						                        	</ul>
												</div>
											</div>
										</div>
					                </div><!-- /accordion-inner -->
					            </div><!-- /collapsed -->
					        </div><!-- /accordion-group -->
					    </div>
					</div><!-- /resuts row -->

				{/foreach}
			
			   
		<h3>{translate text='eContent Checked Out Items'}</h3>


		{if $user}
	    	{if count($overDriveCheckedOutItems) > 0}

	    		{foreach from=$overDriveCheckedOutItems item=record}

    				<div class="row">
					    <div class="col-xs-12 col-md-12">
					    	<a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{$record.shortId|escape}"></a>
					        <div class="accordion-group">
					        	<div class="accordion-heading">

					        	</div>
					        	<div class="results-header clearfix">
					            	<div class="row results-title-header">
					            		<div class="col-xs-12 col-md-12 results-title"><a href="{$url}/Record/{$record.id|escape:"url"}" class="title">{if !$record.title|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$record.title|regex_replace:"/(\/|:)$/":""|truncate:100:"..."|highlight:$lookfor}{/if}</a>
											| <span class="author">
													{if strlen($record.record->author) > 0}{$record.record->author}{/if}
												</span>
						        		</div>
						        	</div>
						        	<div class="row results-status-header">
				        				<div class="col-xs-8 col-md-8">
				        					<p><span class="label label-info">{if $record.expiresOn}
														    Expires on&nbsp;{$record.expiresOn|date_format}
														{/if}</span></p>
				        				</div>
					                    <div class="col-xs-4 col-md-4">
				                    		<div class="btn-group btn-group-actions pull-right">
					                            <button type="button" class="btn btn-small btn-info dropdown-toggle" data-toggle="dropdown">
					                                Action <span class="caret"></span>
					                            </button>
				                                <ul class="dropdown-menu">
				                                    <li><a href="" class="disable-link" onclick='DownloadCheckedoutOverdrive({$record.recordId},{$record.lockedFormat})'>Download</a></li>
				                                    {if $record.hasRead == true}
				                                    	<li><a href="" class="disable-link" onclick="downloadOverDriveItem('{$record.overDriveId}','610')">Read</a></li>
				                                    {/if}
				                                    {if $record.earlyReturn == 1}
				                                    	<li><a href="" class="disable-link" onclick="returnOverDriveItem('{$record.overDriveId}', '{$record.transactionId}')"/>Return</a></li>
				                                    {/if}
				                                </ul>
					                        </div>
				                        </div>
				                    </div>
				                </div>
					            <div id="collapse{$record.shortId|escape}" class="accordion-body collapse in">
					                <div class="accordion-inner requested-results-striped clearfix">

					                	<div class="col-xs-2 col-md-2 col-lg-2 cover-image">
											{if $user->disableCoverArt != 1}
												<a class="thumbnail" href="{$url}/Record/{$record.id|escape:"url"}" id="descriptionTrigger{$record.recordId|escape:"url"}">
													<img src="{$record.imageUrl}" class="listResultImage" alt="{translate text='Cover Image'}"/>
												</a>
											{/if}
										</div>
										<div class="col-xs-10 col-md-10">

											<div class="row">
												<div class="col-xs-8 col-md-8">
													<ul class="requested-results">
														<li class"results-title">
															<a href="{$url}/Record/{$record.id|escape:"url"}" class="title">{if !$record.title|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$record.title|regex_replace:"/(\/|:)$/":""|truncate:100:"..."|highlight:$lookfor}{/if}</a>
														</li>
														<li>
															<span class="author">{if strlen($record.record->author) > 0}{$record.record->author}{/if}</span>
														</li>
													</ul>
												</div>
												<div class="col-xs-4 col-md-4">
													<div class="row checkedout-econtent-buttons pull-right">
														<a href="" class="btn btn-info disable-link" onclick='DownloadCheckedoutOverdrive({$record.recordId},{$record.lockedFormat})'>Download</a>
														{if $record.hasRead == true}
															<a href="" class="btn btn-info disable-link" onclick="downloadOverDriveItem('{$record.overDriveId}','610')">Read</a>
														{/if}
							                    	</div>
												</div>
											</div>

											<div class="row">
												<div class="col-xs-12 col-md-12">
													<ul class="requested-results">
														<li class="requested-results-format">
															{if is_array($record.format)}
															    <span></span>
														    {elseif $record.format|rtrim eq "Kindle Book"}
																<span>
																<img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download">
																</span>
														    {elseif $record.format|rtrim eq "Adobe PDF eBook"}
																<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
														    {elseif $record.format|rtrim eq "OverDrive MP3 Audiobook"}
																<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															{/if}
														    {$record.format}
														</li>
														 {if $record.earlyReturn == 1}
						                                	<li class="checkedout-return-btn"><a href="" class="btn btn-info disable-link return-btn" onclick="returnOverDriveItem('{$record.overDriveId}', '{$record.transactionId}')"/>Return</a></li>
						                                {/if}
														<li class="label-requested-results">
															<span class="label label-info">{if $record.expiresOn}
															    Expires on&nbsp;{$record.expiresOn|date_format}
															{/if}</span>
						                        		</li>
						                        	</ul>
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
		{/if}


	</div>
	<div class="col-xs-3 col-md-3">
		{include file="MyResearch/menu.tpl"}
		{include file="Admin/menu.tpl"}
	</div>
</div>