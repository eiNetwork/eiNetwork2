<script type="text/javascript" src="{$url}/services/MyResearch/ajax.js"></script>
<script type="text/javascript" src="{$url}/services/EcontentRecord/ajax.js"></script>
<script type="text/javascript" src="{$path}/js/checkedout.js"></script>
{literal}
<script type="text/javascript">

	$(document).ready(function(){

		// expand and collapse functions
		$('.collapse').each(function(){
			$(this).on('show.bs.collapse', function() {
				$(this).prev().find('.list-header-second-line .due-date').hide();
				$(this).prev().find('.list-header-second-line .overdue-message').hide();
			})

			$(this).on('hide.bs.collapse', function() {
				$(this).prev().find('.list-header-second-line .due-date').show();
				$(this).prev().find('.list-header-second-line .overdue-message').show();
			})
		})

	});

</script>
{/literal}

{if (isset($title)) }
<script type="text/javascript">

    alert("{$title}");

</script>
{/if}

<div class="row">
	<div class="col-lg-9">
		<div class="sort">
		    <div id="sortLabel">
			{translate text='Sort by'}
		    </div>
		    <div class="sortOptions">
			<select name="accountSort" id="sort" onchange="changeAccountSort($(this).val());">
			    {foreach from=$sortOptions item=sortDesc key=sortVal}
			    <option value="{$sortVal}"{if $defaultSortOption == $sortVal} selected="selected"{/if}>{translate text=$sortDesc}</option>
			    {/foreach}
			</select>
		    </div>
		</div>

			<div>
			    <h2>Checked Out Items</h2>
			</div>

			{if $profile.expireclose == 1}
			    <font color="red"><b>Your library card is due to expire within the next 30 days.  Please visit your local library to renew your card to ensure access to all online service.  </a></b></font>
			{/if}

			<h3>{translate text='Physical Checked Out Items'}</h3>

			<div class="row list-header">
				<div class="col-lg-2">

					<div class="input-group show-all-button">
						<input type="button" id="show-all-button" class="btn btn-small btn-default form-control" value="Hide All" />
						<span class="input-group-addon">
							Save <input type="checkbox">
						</span>
					</div>

				</div>
				<div class="col-lg-10 btn-renew-all">
					<button type="button" class="btn btn-info" onclick="return renewSelectedTitles();">Renew Selected Items</button>
				</div>
			</div>

			<form id="renewForm" action="{$path}/MyResearch/CheckedOut">

				{foreach from=$transList item=record name="recordLoop"}

					<div class="row">
					    <div class="col-lg-12">
					        <div class="accordion-group">
					            <div class="accordion-heading">
					                <div class="row">
					                    <div class="col-lg-1">
					                        <a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{$record.shortId|escape}"><!-- --></a>
					                    </div>
					                    <div class="col-lg-9 book-results-title">
					                    	<ul>
					                            <li>
					                            	{if $record.id}
														<a href="{$url}/Record/{$record.id|escape:"url"}" class="title">
												  	{/if}
													{if !$record.title|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$record.title|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}{/if}
													{if $record.id}
														</a>
													{/if}
					                            </li>
					                            <li>
					                            	<ul class="list-header-second-line">
			                            				<li class="book-results-author"><span>
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
			                            				</span></li>
			                            				<li class="due-date">&nbsp;&nbsp;|&nbsp;&nbsp;Due On&nbsp;{$record.duedate|date_format}
														{if $record.overdue}
														    <span class='overdueLabel'>OVERDUE</span>
														{elseif $record.daysUntilDue == 0}
														    <span class='dueSoonLabel'>(Due today)</span>
														{elseif $record.daysUntilDue == 1}
														    <span class='dueSoonLabel'>(Due tomorrow)</span>
														{elseif $record.daysUntilDue <= 7}
														    <span class='dueSoonLabel'>(Due in {$record.daysUntilDue} days )</span>
														{/if}
														{if $record.renewCount == 1}
														    <span class='dueSoonLabel'>Renewed&nbsp;{$record.renewCount}&nbsp;time</br></span>
														{elseif $record.renewCount > 1}
														    <span class='dueSoonLabel'>Renewed&nbsp;{$record.renewCount}&nbsp;times</br></span>
														{/if}
														{if $record.fine}
														    <span class='overdueLabel'>FINE {$record.fine}</span>
														{/if}</li>
					                            	</ul>
				                            	</li>
					                        </ul>
					                    </div>
					                    <div class="col-lg-2 renew-checkboxes">
					                    	{if $patronCanRenew}
					                    		{assign var=id value=$record.id scope="global"}
											    {assign var=shortId value=$record.shortId scope="global"}
											    {* disable renewals if the item is overdue *}  
											    {if $record.overdue}
											    <!--
											    	<input type="checkbox" disabled="disabled" name="selected[{$record.renewIndicator}]" class="titleSelect" id="selected{$record.itemid}" />&nbsp;&nbsp;Renew&nbsp;			    
												-->			    
												{else}

													<label>
														<input type="checkbox" class="titleSelect" name="selected[{$record.renewIndicator}]" id="selected{$record.itemid}" /> <span>Renew</span>
													</label>

				                        		{/if}
										    {/if}
				                        </div>
				                  	</div>
				                  	{if $record.renewMessage}
				                  	<div class="row renew-message">
				                  		<div class="col-lg-12">
				                  			<div class="alert{if $record.renewResult == true} alert-success{else} alert-danger{/if}">
											  <button type="button" class="close" data-dismiss="alert">&times;</button>
											  {$record.renewMessage|escape}
											</div>
				                  		</div>
				                  	</div>
				                  	 {/if}
				                </div>
					            <div id="collapse{$record.shortId|escape}" class="accordion-body collapse in">
					                <div class="accordion-inner">
					                    <div class="row">
					                        <div class="col-lg-2 cover-image">
					                        	{if $user->disableCoverArt != 1}
												    {if $record.id}
													<a href="{$url}/Record/{$record.id|escape:"url"}" id="descriptionTrigger{$record.id|escape:"url"}">
													    <img src="{$coverUrl}/bookcover.php?id={$record.id}&amp;isn={$record.isbn|@formatISBN}&amp;size=small&amp;upc={$record.upc}&amp;category={$record.format_category.0|escape:"url"}" class="listResultImage" alt="{translate text='Cover Image'}"/>
													</a>
												    {/if}
												{/if}
											</div>
					                        <div class="col-lg-10 book-results">
					                            <ul>
					                            	<li class="due-date">
					                            		Due On&nbsp;{$record.duedate|date_format}
														{if $record.overdue}
														    <span class='overdueLabel'>OVERDUE</span>
														{elseif $record.daysUntilDue == 0}
														    <span class='dueSoonLabel'>(Due today)</span>
														{elseif $record.daysUntilDue == 1}
														    <span class='dueSoonLabel'>(Due tomorrow)</span>
														{elseif $record.daysUntilDue <= 7}
														    <span class='dueSoonLabel'>(Due in {$record.daysUntilDue} days )</span>
														{/if}
														{if $record.renewCount == 1}
														    <span class='dueSoonLabel'>Renewed&nbsp;{$record.renewCount}&nbsp;time</br></span>
														{elseif $record.renewCount > 1}
														    <span class='dueSoonLabel'>Renewed&nbsp;{$record.renewCount}&nbsp;times</br></span>
														{/if}
														{if $record.fine}
														    <span class='overdueLabel'>FINE {$record.fine}</span>
														{/if}
					                            	</li>
					                                <li class="format-type">
			                                			{if is_array($record.format)}
															{foreach from=$record.format item=format}
															    {if $format eq "Print Book"} 
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Book.png"/ alt="Print Book"></span>
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
															    {elseif $format eq "Adobe EPUB eBook"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "Adobe PDF"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "Adobe PDF eBook"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "EPUB eBook"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "Kindle Book"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "Kindle USB Book"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "Kindle"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "External Link"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "Interactive Book"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "Internet Link"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "Open EPUB eBook "}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "Open PDF eBook"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "Plucker"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "MP3"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "MP3 AudioBook"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "MP3 AudioBook"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "MP3 Audiobook"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "WMA Audiobook"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "WMA Music"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "WMA Video"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "OverDrive MP3 Audiobook"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "OverDrive Music"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "OverDrive WMA Audiobook"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															    {elseif $format eq "OverDrive Video"}
															    <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Ebook Download"></span>
															    {/if}
															    <span class="iconlabel" >{translate text=$format}</span>&nbsp;
															{/foreach}
														    {else}
															{if $record.format eq "Print Book"} 
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Book.png"/ alt="Print Book"></span>
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
															{elseif $format eq "Adobe EPUB eBook"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "Adobe PDF"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "Adobe PDF eBook"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "EPUB eBook"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "Kindle Book"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "Kindle USB Book"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "Kindle"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "External Link"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
															{elseif $format eq "Interactive Book"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
															{elseif $format eq "Internet Link"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
															{elseif $format eq "Open EPUB eBook "}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "Open PDF eBook"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "Plucker"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "MP3"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "MP3 AudioBook"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "MP3 AudioBook"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "MP3 Audiobook"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "WMA Audiobook"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "WMA Music"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "WMA Video"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "OverDrive MP3 Audiobook"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "OverDrive Music"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "OverDrive WMA Audiobook"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "OverDrive Video"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Ebook Download"></span>
															{elseif $format eq "OverDrive Read"}
															<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
															{/if}
															<span class="iconlabel" >{translate text=$record.format}</span>
														    {/if}
					                                </li>
					                            </ul>
					                        </div>
					                    </div>
					                </div>
					            </div>
					        </div>
					    </div>
					</div>

				{/foreach}
			
			   
		<h3>{translate text='eContent Checked Out Items'}</h3>


		{if $user}
	    	{if count($overDriveCheckedOutItems) > 0}

	    		{foreach from=$overDriveCheckedOutItems item=record}

	    			<div class="row">
					    <div class="col-lg-12">
					        <div class="accordion-group">
					            <div class="accordion-heading">
					                <div class="row">
					                    <div class="col-lg-1">
					                        <a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{if $record.id}{$record.id|escape}{/if}"><!-- --></a>
					                    </div>
					                    <div class="col-lg-9 book-results-title">
					                    	<ul>
					                            <li><a href="{$url}/Record/{$record.id|escape:"url"}" class="title">{if !$record.title|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$record.title|regex_replace:"/(\/|:)$/":""|truncate:100:"..."|highlight:$lookfor}{/if}</a></li>
					                            <li>
					                            	<ul class="list-header-second-line">
					                    				<li class="book-results-author"><span>
					                    					{if strlen($record.record->author) > 0}{$record.record->author}{/if}
					                    				</span></li>
					                    				<li class="due-date">&nbsp;&nbsp;|&nbsp;&nbsp;{if $record.expiresOn}
														    Expires on&nbsp;{$record.expiresOn|date_format}
														{/if}</li>
					                            	</ul>
					                        	</li>
					                        </ul>
					                    </div>
					                    <div class="col-lg-2">
					                        <div class="btn-group btn-group-actions">
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
					            <div id="collapse{if $record.id}{$record.id|escape}{/if}" class="accordion-body collapse in">
					                <div class="accordion-inner">
					                    <div class="row">
					                        <div class="col-lg-2 cover-image cover-image-econtent">
												<img src="{$record.imageUrl}" class="listResultImage" alt="{translate text='Cover Image'}"/>
					                        </div>
					                        <div class="col-lg-6 book-results">
					                            <ul>
				                                    <li><span>
		                                    			{if $record.expiresOn}
														    Expires on&nbsp;{$record.expiresOn|date_format}
														{/if}
				                                    </span></li>
					                                <li><span>
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
					                                </span></li>
					                                {if $record.earlyReturn == 1}
					                                	<li><a href="" class="btn btn-info disable-link return-btn" onclick="returnOverDriveItem('{$record.overDriveId}', '{$record.transactionId}')"/>Return</a></li>
					                                {/if}
					                            </ul>
					                        </div>
					                        <div class="col-lg-4 book-results-buttons">
				                            	<a href="" class="btn btn-info disable-link" onclick='DownloadCheckedoutOverdrive({$record.recordId},{$record.lockedFormat})'>Download</a>
												{if $record.hasRead == true}
													<a href="" class="btn btn-info disable-link" onclick="downloadOverDriveItem('{$record.overDriveId}','610')">Read</a>
												{/if}
					                        </div>
					                    </div>
					                </div>
					            </div>
					        </div>
					    </div>
					</div>

				{/foreach}
			{/if}
		{/if}


	</div>
	<div class="col-lg-3">
		{include file="MyResearch/menu.tpl"}
		{include file="Admin/menu.tpl"}
	</div>
</div>