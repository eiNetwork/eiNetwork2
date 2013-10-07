{if !empty($addThis)}
<script type="text/javascript" src="https://s7.addthis.com/js/250/addthis_widget.js?pub={$addThis|escape:"url"}"></script>
{/if}
<script type="text/javascript">
{literal}$(document).ready(function(){{/literal}
	GetHoldingsInfo('{$id|escape:"url"}');
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
		alert("{$title}");
	{/if}
{literal}});{/literal}
function redrawSaveStatus() {literal}{{/literal}
		getSaveStatus('{$id|escape:"javascript"}', 'saveLink');
{literal}}{/literal}
</script>

{if $error}<p class="error">{$error}</p>{/if}

<div class="row">
	<div class="col-xs-3 col-md-3">
		{include file="ei_tpl/Record/left-bar-record.tpl"}
	</div>
	<div class="col-xs-6 col-md-6 details-panel">

		<div class="row">
			<div class="col-xs-3 col-md-3 col-lg-3">
				<a href="{$bookCoverUrl}">							
					<img style="width:100px" alt="{translate text='Book Cover'}" class="recordcover" src="{$bookCoverUrl}" />
				</a>
				<div id="goDeeperLink" class="godeeper" style="display:none">
					<a href="{$path}/Record/{$id|escape:"url"}/GoDeeper" onclick="ajaxLightbox('{$path}/Record/{$id|escape}/GoDeeper?lightbox', false,false, '700px', '110px', '70%'); return false;">
					<img class="godeeper-arrow" alt="{translate text='Go Deeper'}" src="{$path}/images/deeper.png" /></a>
				</div>
			</div>
			<div class="col-xs-5 col-md-5">
				<div id='recordTitle' class="details-page-header">{$recordTitleSubtitle|regex_replace:"/(\/|:)$/":""|escape} </div>
				{* Display more information about the title*}
				{if $mainAuthor}
					<div class="recordAuthor">
						<span class="resultLabel"></span>
						<span class="resultValue"><a href="{$path}/Author/Home?author={$mainAuthor|escape:"url"}">{$mainAuthor|escape}</a></span>
					</div>
				{/if}
					
				{if $corporateAuthor}
					<div class="recordAuthor">
						<span class="resultLabel">{translate text='Corporate Author'}:</span>
						<span class="resultValue"><a href="{$path}/Author/Home?author={$corporateAuthor|escape:"url"}">{$corporateAuthor|escape}</a></span>
					</div>
				{/if}
				{if $pubdate}
					<div>
						{$pubdate}
					</div>
				{/if}
				{*}
				{if $showOtherEditionsPopup}
				<div id="otherEditionCopies">
					<div style="font-weight:bold"><a href="#" onclick="loadOtherEditionSummaries('{$id}', false)">{translate text="Other Formats and Languages"}</a></div>
				</div>
				{/if}
				{*}
			</div>
			<div class="col-xs-4 col-md-4">
				<div class="btn-group-vertical">
					{if !isset($noRequest)}
						<button class="btn btn-xs btn-default btn-search-results" id="add-to-cart{$short_id|escape:'url'}" {if $enableBookCart}onclick="getSaveToBookCart('{$id|escape:"url"}','VuFind');return false;"{/if}><span class="glyphicon glyphicon-plus glyphicon-ein-color"></span>&nbsp;&nbsp;Add to Cart</button>
					{/if}
					<button class="btn btn-xs btn-default btn-search-results" {if isset($noRequest)}disabled="disabled"{/if} {if !isset($noRequest)}onclick="getToRequest('{$path}/Record/{$id|escape:'url'}/Hold')"{/if}><span class="glyphicon glyphicon-import glyphicon-ein-color"></span>&nbsp;&nbsp;Request Now</button>
					<button class="btn btn-xs btn-default btn-search-results" onclick="getSaveToListForm('{$id|escape}', 'VuFind'); return false;"><span class="glyphicon glyphicon-th-list glyphicon-ein-color"></span>&nbsp;&nbsp;Add To Wish List</button>
					<button class="btn btn-xs btn-default btn-search-results" onclick="findInLibrary('{$id|escape:"url"}',false,'150px','570px','auto')"><span class="glyphicon glyphicon-search glyphicon-ein-color"></span>&nbsp;&nbsp;Find in Library</button>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="col-xs-12 col-md-12">
				<ul class="search-results-list">
					<li>{include file="Record/formatType.tpl"}</li>
					<li><div id="holdingsSummaryPlaceholder" class="holdingsSummaryRecord"></div></li>
				</ul>
			</div>
		</div>
		
		<div class="row">
			<div class="col-xs-12 col-md-12">
				<ul class="search-results-list">
					{if $summary}
						<li class="details-summary">
							<span class="details-page-header">{translate text='Summary'}</span>
							<ul>
								<li>
									{if strlen($summary) > 300}
										<span id="shortSummary">
											{$summary|stripTags:'<b><p><i><em><strong><ul><li><ol>'|truncate:300}{*Leave unescaped because some syndetics reviews have html in them *}
											<a href='#' onclick='$("#shortSummary").slideUp();$("#fullSummary").slideDown()'>More</a>
										</span>
										<span id="fullSummary" style="display:none">
											{$summary|stripTags:'<b><p><i><em><strong><ul><li><ol>'}{*Leave unescaped because some syndetics reviews have html in them *}
											<a href='#' onclick='$("#shortSummary").slideDown();$("#fullSummary").slideUp()'>Less</a>
										</span>
									{else}
										{$summary|stripTags:'<b><p><i><em><strong><ul><li><ol>'}{*Leave unescaped because some syndetics reviews have html in them *}
									{/if}
								</li>
							</ul>
						</li>
					{/if}
					{if $toc}
						{assign var="con" value=""}
						<li class="details-summary">
							<span class="details-page-header">{translate text='Contents'}</span>
							<ul>
								<li>
									{foreach from=$toc item=line name=loop}
										{if $line.code =="g"}
											{assign var="con" value="`$con``$line.content`<br>"}
										{else}
											{assign var="con" value="`$con``$line.content`"}
										{/if}
									{/foreach}
									{if strlen($con) > 300}
										<span id="shortTOC">
											{$con|truncate:300}
											<a href='#' onclick='$("#shortTOC").slideUp();$("#fullTOC").slideDown()'>More</a>
										</span>
										<span id="fullTOC" style="display:none">
											{$con}
											<a href='#' onclick='$("#shortTOC").slideDown();$("#fullTOC").slideUp()'>Less</a>
										</span>
									{else}
										{$con}
									{/if}
								</li>
							</ul>
						</li>
					{/if}
					<li class="details-summary">
						<span class="details-page-header">{translate text='Published Reviews'}</span>
						<ul>
							<li>
								{if $showAmazonReviews || $showStandardReviews}
									<div id='reviewPlaceholder'>No published reviews available</div>
								{/if}
							</li>
						</ul>
					</li>
					<li class="details-summary">
						<span class="details-page-header">{translate text='Community Reviews test'}</span>
						<ul>
							<li>
								{*include file="$module/view-comments.tpl"*}
								<div class="ltfl_reviews"></div>
							</li>
						</ul>
					</li>
					<li class="details-summary">
						<span class="details-page-header">{translate text='Staff Reviews'}</span>
						<ul>
							<li>{include file="$module/view-staff-reviews.tpl"}</li>
						</ul>
					</li>
				</ul>
			</div>
		</div>

		<div class="row">
			<div class="col-xs-12 col-md-12 details-info">

				<table class="table">
					{if $published}
						<tr>
							<th>{translate text='Publisher'}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$published item=publish name=loop}
										<tr>
											<td>{$publish|escape|trim}</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $editionsThis}
						<tr>
							<th>{translate text='Edition'}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$editionsThis item=editions name=loop}
										<tr>
											<td>{$editions|escape}</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $altTitle}
						<tr>
							<th>{translate text='Other Titles'}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$altTitle item=title key=k name=loop}	
										<tr>
											<td><a href="{$path}/Union/Search?basicType=Title&lookfor={$title|trim|escape:"url"}">{$title|escape|trim}</a></td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $withNotes}
						<tr>
							<th>{translate text='Also Includes'}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$withNotes item=with name=loop}
										<tr>
											<td>{$with|escape|trim}</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $contributors || $corporates || $meetings }
						<tr>
							<th>{translate text='Contributors'}</th>
							<td>
								<table class="table-noborder">
									{if $contributors}
										{foreach from=$contributors item=contributor name=loop}
											<tr><td><a href="{$path}/Author/Home?author={$contributor.author|trim|escape:"url"}">{$contributor.author|escape|trim}</a>
											{$contributor.authorSub}
											{if $contributor.title}
												<a href="{$path}/Union/Search?basicType=Title&lookfor={$contributor.title|trim|escape:"url"}">{$contributor.title|escape|trim}</a>
											{/if}
											</td></tr>
										{/foreach}
									{/if}
									{if $corporates}
										{foreach from=$corporates item=corporate name=loop}
											<tr><td><a href="{$path}/Author/Home?author={$corporate.author|trim|escape:"url"}">{$corporate.author|escape|trim}</a>
											{$corporate.authorSub}							
											{if $corporate.title}
												<a href="{$path}/Union/Search?basicType=Title&lookfor={$corporate.title|trim|escape:"url"}">{$corporate.title|escape|trim}</a>
											{/if}
											</td></tr>
										{/foreach}
									{/if}
									{if $meetings}
										{foreach from=$meetings item=meeting name=loop}
											<tr><td><a href="{$path}/Author/Home?author={$meeting.author|trim|escape:"url"}">{$meeting.author|escape|trim}</a>
											{$meeting.authorSub}								
											{if $meeting.title}
												<a href="{$path}/Union/Search?basicType=Title&lookfor={$meeting.title|trim|escape:"url"}">{$meeting.title|escape|trim}</a>
											{/if}
											</td></tr>
										{/foreach}
									{/if}
								</table>
							</td>
						</tr>
					{/if}

					{if $performerNotes}
						<tr>
							<th>{translate text='Participants'}/{translate text='Performers'}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$performerNotes item=perform name=loop}
										<tr>
											<td>{$perform|escape|trim}</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $productionNotes}
						<tr>
							<th>{translate text='Other Contributors'}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$productionNotes item=produce name=loop}
										<tr>
											<td>{$produce|escape|trim}</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $targetNotes}
						<tr>
							<th>{translate text='Audience'}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$targetNotes item=target name=loop}
										<tr>
											<td>{$target|escape|trim}</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $recordLanguage}
						<tr>
							<th>{translate text='Language'}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$recordLanguage item=lang}
										<tr>
											<td>{$lang|escape|trim}</td>
										</tr>
									{/foreach}

									{if $languageNotes}
										{foreach from=$languageNotes item=languagenote name=loop}
											<tr>
												<td>{$languagenote|escape|trim}</td>
											</tr>
										{/foreach}
									{/if}
								</table>
							</td>
						</tr>
					{/if}

					{if $notes}
						{foreach from=$notes item=note key=k name=loop}
							<tr>
								<th>{$k}</th>
								<td>
									<table class="table-noborder">
										{foreach from=$targetNotes item=target name=loop}
											<tr>
												<td>
													{if strlen($note) > 300}
														<span id="shortNote{$smarty.foreach.loop.iteration}">
															{$note|truncate:300}
															<a onclick='$("#shortNote{$smarty.foreach.loop.iteration}").slideUp();$("#fullNote{$smarty.foreach.loop.iteration}").slideDown()'>More</a>
														</span>
														<span id="fullNote{$smarty.foreach.loop.iteration}" style="display:none">
															{$note}
															<a  onclick='$("#shortNote{$smarty.foreach.loop.iteration}").slideDown();$("#fullNote{$smarty.foreach.loop.iteration}").slideUp()'>Less</a>
														</span>
													{else}
														{$note}
													{/if}
												</td>
											</tr>
										{/foreach}
									</table>
								</td>
							</tr>
						{/foreach}
					{/if}

					{if $physicalDescriptions}
						<tr>
							<th>{translate text='Description'}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$physicalDescriptions item=physicalDescription name=loop}
										<tr>
											<td>{$physicalDescription|escape|trim}</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $biblioNotes}
						<tr>
							<th>{translate text='Bibliography Notes'}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$biblioNotes item=biblio name=loop}
										<tr>
											<td>{$biblio|escape|trim}</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $uniform}
						<tr>
							<th>{translate text='Uniform Title'}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$uniform item=uni}
										<tr>
											<td>{$uni|escape|trim}</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $isbns}
						<tr>
							<th>ISBN</th>
							<td>
								<table class="table-noborder">
									{foreach from=$isbns item=tmpIsbn name=loop}
										<tr>
											<td>{$tmpIsbn|escape}</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $issn}
						<tr>
							<th>ISSN</th>
							<td>{$issn}</td>
						</tr>

						{if $goldRushLink}

							<tr>
								<td></td>
								<td><a href='{$goldRushLink}' target='_blank'>Check for online articles</a></td>
							</tr>

						{/if}
					{/if}

					{if $internetLinks}
						<tr>
							<th>{translate text="Links"}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$internetLinks item=internetLink}
										<tr>
											<td>
												{if $proxy}
													<a href="{$proxy}/login?url={$internetLink.link|escape:"url"}">{$internetLink.linkText|escape}</a>
												{else}
													<a href="{$internetLink.link|escape}">{$internetLink.linkText|escape}</a>
												{/if}
											</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}

					{if $supLinks}
						<tr>
							<th>{translate text="Supplemental Links"}</th>
							<td>
								<table class="table-noborder">
									{foreach from=$supLinks item=internetLink}
										<tr>
											<td>
												{if $proxy}
													<a href="{$proxy}/login?url={$internetLink.link|escape:"url"}">{$internetLink.linkText|escape}</a>
												{else}
													<a href="{$internetLink.link|escape}">{$internetLink.linkText|escape}</a>
												{/if}
											</td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					{/if}
				</table>

			</div>
		</div>

		{* tabs for series, similar titles, and people who viewed also viewed *}
		{if $showStrands}

			<div class="row">
				<div class="col-xs-12 col-md-12">

					<div id="relatedTitleInfo" class="ui-tabs">
						<ul>
							<li><a href="#list-similar-titles">Similar Titles</a></li>
							<li><a href="#list-also-viewed">People who viewed this also viewed</a></li>
							<li><a id="list-series-tab" href="#list-series" style="display:none">Also in this series</a></li>
						</ul>
						
						{assign var="scrollerName" value="SimilarTitles"}
						{assign var="wrapperId" value="similar-titles"}
						{assign var="scrollerVariable" value="similarTitleScroller"}
						{include file=titleScroller.tpl}
						
						{assign var="scrollerName" value="AlsoViewed"}
						{assign var="wrapperId" value="also-viewed"}
						{assign var="scrollerVariable" value="alsoViewedScroller"}
						{include file=titleScroller.tpl}
						
					
						{assign var="scrollerName" value="Series"}
						{assign var="wrapperId" value="series"}
						{assign var="scrollerVariable" value="seriesScroller"}
						{assign var="fullListLink" value="$path/Record/$id/Series"}
						{include file=titleScroller.tpl}
						
					</div>

					{literal}
					<script type="text/javascript">
						var similarTitleScroller;
						var alsoViewedScroller;
						
						$(function() {
							$("#relatedTitleInfo").tabs();
							$("#moredetails-tabs").tabs();
							
							{/literal}
							{if $defaultDetailsTab}
								$("#moredetails-tabs").tabs('select', '{$defaultDetailsTab}');
							{/if}
							
							similarTitleScroller = new TitleScroller('titleScrollerSimilarTitles', 'SimilarTitles', 'similar-titles');
							similarTitleScroller.loadTitlesFrom('{$url}/Search/AJAX?method=GetListTitles&id=strands:PROD-2&recordId={$id}&scrollerName=SimilarTitles', false);
				
							{literal}
							$('#relatedTitleInfo').bind('tabsshow', function(event, ui) {
								if (ui.index == 0) {
									similarTitleScroller.activateCurrentTitle();
								}else if (ui.index == 1) { 
									if (alsoViewedScroller == null){
										{/literal}
										alsoViewedScroller = new TitleScroller('titleScrollerAlsoViewed', 'AlsoViewed', 'also-viewed');
										alsoViewedScroller.loadTitlesFrom('{$url}/Search/AJAX?method=GetListTitles&id=strands:PROD-1&recordId={$id}&scrollerName=AlsoViewed', false);
									{literal}
									}else{
										alsoViewedScroller.activateCurrentTitle();
									}
								}
							});
						});
					</script>
					{/literal}

				</div>
			</div>

		{elseif $showSimilarTitles}

			<div class="row">
				<div class="col-xs-12 col-md-12">
					<div id="relatedTitleInfo" class="ui-tabs">
						<ul>
							<li><a href="#list-similar-titles">Similar Titles</a></li>
							<li><a id="list-series-tab" href="#list-series" style="display:none">Also in this series</a></li>
						</ul>
						
						{assign var="scrollerName" value="SimilarTitlesVuFind"}
						{assign var="wrapperId" value="similar-titles-vufind"}
						{assign var="scrollerVariable" value="similarTitleVuFindScroller"}
						{include file=titleScroller.tpl}

						{assign var="scrollerName" value="Series"}
						{assign var="wrapperId" value="series"}
						{assign var="scrollerVariable" value="seriesScroller"}
						{assign var="fullListLink" value="$path/Record/$id/Series"}
						{include file=titleScroller.tpl}
						
					</div>

					{literal}
					<script type="text/javascript">
						var similarTitleScroller;
						var alsoViewedScroller;
						
						$(function() {
							$("#relatedTitleInfo").tabs();
							$("#moredetails-tabs").tabs();
							
							{/literal}
							{if $defaultDetailsTab}
								$("#moredetails-tabs").tabs('select', '{$defaultDetailsTab}');
							{/if}
							
							similarTitleVuFindScroller = new TitleScroller('titleScrollerSimilarTitles', 'SimilarTitles', 'similar-titles');
							similarTitleVuFindScroller.loadTitlesFrom('{$url}/Search/AJAX?method=GetListTitles&id=similarTitles&recordId={$id}&scrollerName=SimilarTitles', false);
				
							{literal}
							$('#relatedTitleInfo').bind('tabsshow', function(event, ui) {
								if (ui.index == 0) {
									similarTitleVuFindScroller.activateCurrentTitle();
								}
							});
						});
					</script>
					{/literal}
				</div>
			</div>

		{else}

			<div class="row">
				<div class="col-xs-12 col-md-12">
					<div id="relatedTitleInfo" style="display:none">
						{assign var="scrollerName" value="Series"}
						{assign var="wrapperId" value="series"}
						{assign var="scrollerVariable" value="seriesScroller"}
						{assign var="fullListLink" value="$path/Record/$id/Series"}
						{include file=titleScroller.tpl}
					</div>
				</div>
			</div>

		{/if}

		

	</div>
	<div class="col-xs-3 col-md-3">
		{include file="ei_tpl/right-bar.tpl"}
	</div>
</div>

<!--{if $showStrands}
{* Strands Tracking *}{literal}
<!-- Event definition to be included in the body before the Strands js library -->
<script type="text/javascript">
if (typeof StrandsTrack=="undefined"){StrandsTrack=[];}
StrandsTrack.push({
	 event:"visited",
	 item: "{/literal}{$id|escape}{literal}"
});
</script>
{/literal}
{/if}-->
<script>getItemStatusCart('{$id|escape}')</script>