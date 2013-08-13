{if (isset($title)) }
<script type="text/javascript">
	alert("{$title}");
</script>
{/if}
<script type="text/javascript" src="{$path}/js/holds.js"></script>
<script type="text/javascript" src="{$path}/services/MyResearch/ajax.js"></script>
<script type="text/javascript" src="{$path}/js/tablesorter/jquery.tablesorter.min.js"></script>


<div class="row">
	<div class="col-lg-9">
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
				<p style="font-size:80%;color:red">We are receiving reports about some users not receiving email notices for upcoming due dates, hold pickups, or overdue items.  You may wish to check My Account or contact your local library for this information.   Please contact your email provider if you believe you are not receiving these notices.</p>
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
				<div class="col-lg-2">

					<div class="input-group show-all-button">
						<input type="button" id="show-all-button" class="btn btn-small btn-default form-control" value="Hide All" />
						<span class="input-group-addon">
							Save <input type="checkbox">
						</span>
					</div>

				</div>
				<div class="col-lg-10 btn-renew-all">
					{if $freezeButton eq 'freeze'}
						<button type="button" class="btn btn-info" id="freeze-all-btn">Freeze All</button>
					{else}
						<button type="button" class="btn btn-info" id="unfreeze-all-btn" href="#">Unfreeze All</button>
					{/if}
					<button type="button" class="btn btn-info" id="update-selected-btn">Update Seleceted</button>
				</div>
			</div>

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
											<a href="{$url}/Record/{$record.id|escape:"url"}" class="title">The cuckoo's calling</a>
			                            </li>
			                            <li>
			                            	<ul class="list-header-second-line">
	                            				<li class="book-results-author"><span>Galbraith, Robert,</span></li>
	                            				<li class="due-date"></li>
			                            	</ul>
		                            	</li>
			                        </ul>
			                    </div>
			                    <div class="col-lg-2 renew-checkboxes">
			                    	
		                        </div>
		                  	</div>
		                </div>
			            <div id="collapse{$record.shortId|escape}" class="accordion-body collapse in">
			                <div class="accordion-inner">
			                    <div class="row">
			                        <div class="col-lg-2 cover-image">
										<a href="http://vufindplus.einetwork.net/Record/.b32083294?searchId=&recordIndex=&page=">
										    <img src="http://vufindplus.einetwork.net/bookcover.php?id=.b32083294&isn=0316206849&size=small&upc=&category=" class="listResultImage" alt="Cover Image"/>
										</a>
									</div>
			                        <div class="col-lg-2 book-results">
			                            <ul>
			                            	<li class="pickup-location">Pickup Location: CLP - Main Library</li>
			                            	<li class="status">Status: Pending</li>
			                                <li class="format-type">
	                                			<span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/Book.png"/ alt="Print Book"></span> <span class="iconlabel">Print Book</span>
			                                </li>
			                            </ul>
			                        </div>
			                        <div class="col-lg-2">
			                        	<label>
											<input type="checkbox" class="titleSelect" name="selected[{$record.renewIndicator}]" id="selected{$record.itemid}" /> <span>Freeze</span>
										</label>
			                        </div>
			                        <div class="col-lg-2">
			                        	<label>
											<input type="checkbox" class="titleSelect" name="selected[{$record.renewIndicator}]" id="selected{$record.itemid}" /> <span>Cancel</span>
										</label>
			                        </div>
		                        	<div class="col-lg-4">
										<div class="btn-group">
											<button type="button" class="btn btn-default">Pickup Location</button>
											<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
												<span class="caret"></span>
											</button>
											<ul class="dropdown-menu">
												<li><a href="#">Baldwin Borough Library</a>
												<li><a href="#">Andrew Bayne Memorial Library</a>
												<li><a href="#">Andrew Carnegie Free Library</a>
												<li><a href="#">Avalon Public Library</a>
												<li><a href="#">Bethel Park Public Library</a>
												<li><a href="#">Braddock Carnegie Library</a>
												<li><a href="#">Braddock Carnegie Library - Turtle Creek</a>
												<li><a href="#">Brentwood Library</a>
												<li><a href="#">Bridgeville Public Library</a>
												<li class="divider"></li>
												<li><a href="#">C.C. Mellor Memorial Library</a>
												<li><a href="#">C.C. Mellor Memorial Library - Forest Hills</a>
												<li class="divider"></li>
												<li><a href="#">CLP - Allegheny Regional</a>
												<li><a href="#">CLP - Beechview</a>
												<li><a href="#">CLP - Brookline</a>
												<li><a href="#">CLP - Carrick</a>
												<li><a href="#">CLP - Downtown and Business</a>
												<li><a href="#">CLP - East Liberty</a>
												<li><a href="#">CLP - Hazelwood</a>
												<li><a href="#">CLP - Hill District</a>
												<li><a href="#">CLP - Homewood</a>
												<li><a href="#">CLP - Knoxville</a>
												<li><a href="#">CLP - LYNCS - Public Market (Strip District)</a>
												<li><a href="#">CLP - Lawrenceville</a>
												<li><a href="#">CLP - Library for the Blind</a>
												<li><a href="#">CLP - Main Library</a>
												<li><a href="#">CLP - Mt. Washington</a>
												<li><a href="#">CLP - Sheraden</a>
												<li><a href="#">CLP - South Side</a>
												<li><a href="#">CLP - Squirrel Hill</a>
												<li><a href="#">CLP - West End</a>
												<li><a href="#">CLP - Woods Run</a>
												<li class="divider"></li>
												<li><a href="#">Carnegie Free Library of Swissvale</a>
												<li><a href="#">Carnegie Library of Homestead</a>
												<li><a href="#">Carnegie Library of McKeesport</a>
												<li><a href="#">Carnegie Library of McKeesport - Duquesne</a>
												<li><a href="#">Carnegie Library of McKeesport - Elizabeth Forward</a>
												<li><a href="#">Carnegie Library of McKeesport - White Oak</a>
												<li class="divider"></li>
												<li><a href="#">Clairton Public Library</a>
												<li class="divider"></li>
												<li><a href="#">Community Library of Allegheny Valley - Harrison</a>
												<li><a href="#">Community Library of Allegheny Valley - Tarentum</a>
												<li><a href="#">Community Library of Castle Shannon</a>
												<li class="divider"></li>
												<li><a href="#">Cooper-Siegel Community Library</a>
												<li><a href="#">Cooper-Siegel Community Library - Sharpsburg</a>
												<li><a href="#">Coraopolis Memorial Library</a>
												<li><a href="#">Crafton Public Library</a>
												<li><a href="#">Dormont Public Library</a>
												<li><a href="#">F.O.R. Sto-Rox Library</a>
												<li><a href="#">Green Tree Public Library</a>
												<li><a href="#">Hampton Community Library</a>
												<li><a href="#">Jefferson Hills Public Library</a>
												<li><a href="#">Monroeville Public Library</a>
												<li><a href="#">Moon Township Public Library</a>
												<li><a href="#">Mt. Lebanon Public Library</a>
												<li><a href="#">North Versailles Public Library</a>
												<li class="divider"></li>
												<li><a href="#">Northern Tier Regional Library</a>
												<li><a href="#">Northern Tier Regional Library - Pine Center</a>
												<li class="divider"></li>
												<li><a href="#">Northland Public Library</a>
												<li><a href="#">Oakmont Carnegie Library</a>
												<li><a href="#">Penn Hills Library - Lincoln Park</a>
												<li><a href="#">Pittsburgh Mills</a>
												<li><a href="#">Pleasant Hills Public Library</a>
												<li><a href="#">Plum Community Library</a>
												<li><a href="#">Robinson Township</a>
												<li><a href="#">Scott Township Library</a>
												<li><a href="#">Sewickley Public Library</a>
												<li><a href="#">Shaler North Hills Library</a>
												<li><a href="#">South Fayette Township Library</a>
												<li><a href="#">South Park Library</a>
												<li><a href="#">Springdale Free Public Library</a>
												<li><a href="#">Upper St. Clair Township Library</a>
												<li><a href="#">Western Allegheny Community Library</a>
												<li><a href="#">Whitehall Public Library</a>
												<li class="divider"></li>
												<li><a href="#">Wilkinsburg Public Library</a>
												<li><a href="#">Wilkinsburg Public Library - Eastridge</a>
												<li class="divider"></li>
												<li><a href="#">zBookmobile Stop Arrowood</a>
												<li><a href="#">zBookmobile Stop Atria S Hills</a>
												<li><a href="#">zBookmobile Stop Beatty Pointe</a>
												<li><a href="#">zBookmobile Stop Ben Avon</a>
												<li><a href="#">zBookmobile Stop Benedictine Ctr</a>
												<li><a href="#">zBookmobile Stop Brinton</a>
												<li><a href="#">zBookmobile Stop Broadview Mnr</a>
												<li><a href="#">zBookmobile Stop Carnegie Res</a>
												<li><a href="#">zBookmobile Stop Carver Hall</a>
												<li><a href="#">zBookmobile Stop Chartiers Asst</a>
												<li><a href="#">zBookmobile Stop Chartiers Manor</a>
												<li><a href="#">zBookmobile Stop Cloverleaf Est</a>
												<li><a href="#">zBookmobile Stop Country Meadows</a>
												<li><a href="#">zBookmobile Stop Crafton Plaza</a>
												<li><a href="#">zBookmobile Stop Crafton Twr</a>
												<li><a href="#">zBookmobile Stop General Special</a>
												<li><a href="#">zBookmobile Stop HRC Manor Care</a>
												<li><a href="#">zBookmobile Stop Holy Family Mnr</a>
												<li><a href="#">zBookmobile Stop Homestead Apts</a>
												<li><a href="#">zBookmobile Stop Honus Wagner</a>
												<li><a href="#">zBookmobile Stop Kane Glen Haz</a>
												<li><a href="#">zBookmobile Stop Kane Sct Twp</a>
												<li><a href="#">zBookmobile Stop Kenmawr</a>
												<li><a href="#">zBookmobile Stop Leetsdale</a>
												<li><a href="#">zBookmobile Stop Lemington</a>
												<li><a href="#">zBookmobile Stop Little Sisters</a>
												<li><a href="#">zBookmobile Stop Locust Grove</a>
												<li><a href="#">zBookmobile Stop Marsh Middle Sc</a>
												<li><a href="#">zBookmobile Stop Mt Alvernia</a>
												<li><a href="#">zBookmobile Stop N Hills Village</a>
												<li><a href="#">zBookmobile Stop Ohio View Twr</a>
												<li><a href="#">zBookmobile Stop Paramount</a>
												<li><a href="#">zBookmobile Stop Parkview Tower</a>
												<li><a href="#">zBookmobile Stop United Hands</a>
											</ul>
										</div>
			                        </div>
			                    </div>
			                </div>
			            </div>
			        </div>
			    </div>
			</div>
			
			{*****BEGIN Overdrive Holds******}
			<div style="margin-top: 20px;margin-bottom: 20px"><h3>{translate text='eContent Requests'}</h3></div>
			{if count($overDriveHolds.available) > 0}
				
				<div>&nbsp&nbsp&nbsp&nbspTitles available for checkout</div>
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
			<div style="margin-left: 10px">{translate text="You do not have any eContent requests that are not available yet. "}</div>
			{/if}
			{*****END Overdrive Holds*****}
			
		{else} {* Check to see if user is logged in *}
			You must login to view this information. Click <a href="{$path}/MyResearch/Login">here</a> to login.
		{/if}
	</div>
	<div class="col-lg-3">
		{include file="MyResearch/menu.tpl"}
		{include file="Admin/menu.tpl"}
	</div>
</div>