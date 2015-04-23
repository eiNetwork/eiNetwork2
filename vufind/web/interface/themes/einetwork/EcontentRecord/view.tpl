<script type="text/javascript" src="{$path}/services/EcontentRecord/ajax.js"></script>
{if !empty($addThis)}
<script type="text/javascript" src="https://s7.addthis.com/js/250/addthis_widget.js?pub={$addThis|escape:"url"}"></script>
{/if}
<script type="text/javascript">
{literal}$(document).ready(function(){{/literal}
	GetEContentHoldingsInfo('{$id|escape:"url"}');
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
	  //alert("{$title}");
	{/if}
{literal}});{/literal}
function redrawSaveStatus() {literal}{{/literal}
    getSaveStatus('{$id|escape:"javascript"}', 'saveLink');
{literal}}{/literal}
</script>
<div id="page-content" class="content">
  {if $error}<p class="error">{$error}</p>{/if}
  {include file = "EcontentRecord/left-bar-record.tpl"}
  
  <div id="main-content" class="full-result-content">
	    <div id="inner-main-content">
		  	<div id="record_record">
			<div id="record_record_up">
			      <div class="recordcoverWrapper">
				    <a href="{$bookCoverUrl}">              
				      <img alt="{translate text='Book Cover'}" class="recordcover" src="{$bookCoverUrl}" />
				    </a>
				     <div id="goDeeperLink" class="godeeper" style="display: none">
					  <a href="{$path}/EcontentRecord/{$id|escape:"url"}/GoDeeper" onclick="ajaxLightbox('{$path}/EcontentRecord/{$id|escape}/GoDeeper?lightbox', false,false, '700px', '110px', '70%'); return false;">
					  <img alt="{translate text='Go Deeper'}" src="{$path}/images/deeper.png" /></a>
				    </div>
			      </div>
			      <div id="record_record_up_middle">
						<div id='recordTitle'>{$eContentRecord->full_title|regex_replace:"/(\/|:)$/":""|escape}
						{if $user && $user->hasRole('epubAdmin')}
						{if $eContentRecord->status != 'active'}<span id="eContentStatus">({$eContentRecord->status})</span>{/if}
						<span id="editEContentLink"><a href='{$path}/EcontentRecord/{$id}/Edit'>(edit)</a></span>
						{if $eContentRecord->status != 'archived' && $eContentRecord->status != 'deleted'}
							<span id="archiveEContentLink"><a href='{$path}/EcontentRecord/{$id}/Archive' onclick="return confirm('Are you sure you want to archive this record?  The record should not have any holds or checkouts when it is archived.')">(archive)</a></span>
						{/if}
						{if $eContentRecord->status != 'deleted'}
							<span id="deleteEContentLink"><a href='{$path}/EcontentRecord/{$id}/Delete' onclick="return confirm('Are you sure you want to delete this record?  The record should not have any holds or checkouts when it is deleted.')">(delete)</a></span>
						{/if}
						{/if}
						</div>
						{* Display more information about the title*}
						{if $eContentRecord->author}
						      <div class="recordAuthor">
							    <span class="resultLabel">by</span>
							    <span class="resultValue"><a href="{$path}/Author/Home?author={$eContentRecord->author|escape:"url"}">{$eContentRecord->author|escape}</a></span>
						      </div>
						{/if}
						{if $corporateAuthor}
							<div class="recordAuthor">
								<span class="resultLabel">{translate text='Corporate Author'}:</span>
								<span class="resultValue"><a href="{$path}/Author/Home?author={$corporateAuthor|escape:"url"}">{$corporateAuthor|escape}</a></span>
							</div>
						{/if}
						{if $eContentRecord->publishDate && $eContentRecord->publishDate != '01/01/0001'}
							<div>
								{$eContentRecord->publishDate}
							</div>
						{/if}
						{if $showOtherEditionsPopup}
						<div id="otherEditionCopies">
						</div>
						{/if}
				</div>

            <div id="record_action_button">
<!--	    <div class="round-rectangle-button" id="add-to-cart" {if $enableBookCart}onclick="getSaveToBookCart('{$id|escape:"url"}','eContent');return false;"{/if}>
		  <span class="action-img-span"><img id="add-to-cart-img" alt="add to cart" class="action-img" src="/interface/themes/einetwork/images/Art/ActionIcons/AddToCart.png" /></span>
		  <span class="action-lable-span">add to cart</span>
	    </div>
-->	    {if $eContentRecord->source == 'OverDrive'}
		  {if $holdingsSummary.status == 'Checked out in OverDrive'}
			<div class="round-rectangle-button" id="request-now" onclick="placeOverDriveHold('{$record.overDriveId}', '{$format.formatId}')" >
			<span class="action-img-span"><img id="request-now-img" alt="request now" class="action-img" src="/interface/themes/einetwork/images/Art/ActionIcons/RequestNow.png" alt="request now"/></span>
			<span class="action-lable-span">Request Now</span>
			</div>
		  {elseif $holdingsSummary.status == 'Available from OverDrive'}
			<div class="round-rectangle-button" id="checkout-now" onclick="checkoutOverDriveItem('{$format.overDriveId}','{$format.formatId}')" style="border-radius:8px,8px,0px,0px">
			<span class="action-img-span"><img id="request-now-img" alt="checkout now" class="action-img" src="/interface/themes/einetwork/images/Art/ActionIcons/RequestNow.png" alt="checkout now"/></span>
			<span class="action-lable-span">Checkout Now</span>
			</div>
		  {else}
		  	{if $eContentRecord->sourceUrl  }
			
			      <div class="round-rectangle-button" id="access-online" onclick="window.open('{$eContentRecord->sourceUrl}')" style="border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px">
			      <span class="action-img-span"><img id="find-in-library-img" alt="access online" class="action-img" src="/interface/themes/einetwork/images/Art/ActionIcons/MoreLikeThis.png" alt="Access Online"/></span>
			      <span class="action-lable-span">Access Online</span>
			</div>
			
			{else}
				 <div class="round-rectangle-button" id="access-online"  style="border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px">
			      <span class="action-img-span"><img id="find-in-library-img" alt="Loading..." class="action-img" src="/interface/themes/einetwork/images/Art/ActionIcons/MoreLikeThis.png" alt="Loading..."/></span>
			      <span class="action-lable-span">Loading...</span>
			      </div>
			{/if}	  
		  {/if}	
	    {else}
		  {if $eContentRecord->sourceUrl && $eContentRecord->sourceUrl != "" }
		  <div class="round-rectangle-button" id="access-online" onclick="window.open('{$eContentRecord->sourceUrl}')" style="border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px">
			<span class="action-img-span"><img id="find-in-library-img" alt="access online" class="action-img" src="/interface/themes/einetwork/images/Art/ActionIcons/MoreLikeThis.png" alt="Access Online"/></span>
			<span class="action-lable-span">Access Online</span>
		  </div>
		  {else}
		  <div class="round-rectangle-button" id="access-online" onclick="window.location.href='#links'" style="border-bottom-width:0px;border-bottom-left-radius:0px;border-bottom-right-radius:0px">
		  <span class="action-img-span"><img id="find-in-library-img" alt="access online" class="action-img" src="/interface/themes/einetwork/images/Art/ActionIcons/MoreLikeThis.png" alt="Access Online"/></span>
		  <span class="action-lable-span">Access Online</span>
		  </div>	
		  {/if}	    
	    {/if}

	    <div class="round-rectangle-button" id="add-to-wish-list" onclick="getSaveToListForm('{$id|escape}', 'eContent'); return false;" style="border-top-width:1px;border-bottom-left-radius:8px;border-bottom-right-radius:8px;">
		  <span class="action-img-span"><img id="add-to-wish-list-img" alt="add to list" class="action-img" src="/interface/themes/einetwork/images/Art/ActionIcons/AddToWishList.png" /></span>
		  <span class="action-lable-span">Add To List</span>
	    </div>
     
      {* Place hold link *}
<!--	  <div class='requestThisLink' id="placeHold{$id|escape:"url"}" style="display:none">
	    <a href="{$path}/EcontentRecord/{$id|escape:"url"}/Hold"><img src="{$path}/interface/themes/default/images/place_hold.png" alt="Place Hold"/></a>
	  </div>
-->	  
	  {* Checkout link *}
	  <div class='checkoutLink' id="checkout{$id|escape:"url"}" style="display:none">
	    <a href="{$path}/EcontentRecord/{$id|escape:"url"}/Checkout"><img src="{$path}/interface/themes/default/images/checkout.png" alt="Checkout"/></a>
	  </div>
<!--	  
	  {* Access online link *}
	  <div class='accessOnlineLink' id="accessOnline{$id|escape:"url"}" style="display:none">
	    <a href="{$path}/EcontentRecord/{$id|escape:"url"}/Home?detail=holdingstab#detailsTab"><img src="{$path}/interface/themes/default/images/access_online.png" alt="Access Online"/></a>
	  </div>
-->	  
	  {* Add to Wish List *}
	  <div class='addToWishListLink' id="addToWishList{$id|escape:"url"}" style="display:none">
	    <a href="{$path}/EcontentRecord/{$id|escape:"url"}/AddToWishList"><img src="{$path}/interface/themes/default/images/add_to_wishlist.png" alt="Add To List"/></a>
	  </div>
	  
			</div>
	    </div>
     
    <div id="record-details-column">
	    <div id="record-details-header">
	{if $eContentRecord->source != "OverDrive"}
		<div id="availableOnline">
			<span>
			<br/>
			<img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Available.png" alt="Available"/>
			</span>
			{if $eContentRecord->sourceUrl }
			<a style="cursor:pointer" class="overdriveAvailable" onclick="window.location.href='{$eContentRecord->sourceUrl}'">Available Online</a>
			{else}
			<a style="cursor:pointer" class="overdriveAvailable" onclick="window.location.href='#links'">Available Online</a>
			{/if}
		</div>
	{/if}		  
	    <div id="holdingsSummaryPlaceholder" class="holdingsSummaryRecord">Loading...</div>
	      {if $enableProspectorIntegration == 1}
	      <div id="prospectorHoldingsPlaceholder"></div>
	      {/if}

      <div id="record_record_down">	   
	    {if is_array($eContentRecord->format())}
		  {foreach from=$eContentRecord->format() item=displayFormat name=loop}
		  <div>
		  {if $displayFormat eq "Video Download"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Video Download"></span>
		  {elseif $format eq "Audio Book Download"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Audio Book Download"></span>
		  {elseif $displayFormat eq "Adobe EPUB eBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "Adobe PDF"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "Adobe PDF eBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "EPUB eBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "Kindle Book"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "Kindle USB Book"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "Kindle"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "External Link"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "Interactive Book"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "Internet Link"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "Open EPUB eBook "}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "Open PDF eBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "Plucker"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "MP3"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "MP3 AudioBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "MP3 AudioBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "MP3 Audiobook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "WMA Audiobook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "WMA Music"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "WMA Video"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "OverDrive MP3 Audiobook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "OverDrive Music"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "OverDrive WMA Audiobook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "OverDrive Video"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "Streaming Video"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Ebook Download"></span>
		  {elseif $displayFormat eq "OverDrive Read"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {/if}		  
			<span class="iconlabel {$displayFormat|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$displayFormat}</span></div>
		  {/foreach}
	    {else}
		  <div>
		  {if $eContentRecord->format eq "Video Download"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Video Download"></span>
		  {elseif $format eq "Audio Book Download"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Audio Book Download"></span>
		  {elseif $eContentRecord->format eq "Adobe EPUB eBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "Adobe PDF"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "Adobe PDF eBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "EPUB eBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "Kindle Book"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "Kindle USB Book"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "Kindle"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "External Link"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "Interactive Book"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "Internet Link"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/OnlineBook.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "Open EPUB eBook "}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "Open PDF eBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "Plucker"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "MP3"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "MP3 AudioBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "MP3 AudioBook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "MP3 Audiobook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "WMA Audiobook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "WMA Music"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "WMA Video"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "OverDrive MP3 Audiobook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "OverDrive Music"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/MusicDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "OverDrive WMA Audiobook"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/AudioBookDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "OverDrive Video"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "Streaming Video"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/VideoDownload.png"/ alt="Ebook Download"></span>
		  {elseif $eContentRecord->format eq "OverDrive Read"}
		  <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
		  {/if}	
			<span class="iconlabel {$eContentRecord->format()|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$eContentRecord->format}</span></div>
	    {/if}
      </div>
    </div>
	      
      {if $eContentRecord->description}
	    <div class="resultInformation">
		  <div class="resultInformationLabel">{translate text='Description'}</div>
		  <div class="recordDescription">
			{if strlen($eContentRecord->description) > 300}
				<span id="shortDesc">
					{$eContentRecord->description|strip_tags|truncate:300}
					<a href='#' onclick='$("#shortDesc").slideUp();$("#fullDesc").slideDown()'>More</a>
				</span>
				<span id="fullDesc" style="display:none">
					{$eContentRecord->description|strip_tags}
					<a href='#' onclick='$("#shortDesc").slideDown();$("#fullDesc").slideUp()'>Less</a>
				</span>
			{/if}
		  </div>
	    </div>
      {/if}
		  {if $summary}
			<div class="resultInformation">
				<div class="resultInformationLabel">{translate text='Summary'}</div>
				<div class="recordDescription">
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
				</div>
			</div>
			<hr />
			{/if}
			{if $eContentRecord->contents}
			<div class="resultInformation">
				<div class="resultInformationLabel">{translate text='Contents'}</div>
				<div class="recordDescription">
					{if strlen($eContentRecord->contents) > 300}
						<span id="shortTOC">
						{$eContentRecord->contents|truncate:300}
						<a href='#' onclick='$("#shortTOC").slideUp();$("#fullTOC").slideDown()'>More</a>
						</span>
						<span id="fullTOC" style="display:none">
						{$eContentRecord->contents}
						<a href='#' onclick='$("#shortTOC").slideDown();$("#fullTOC").slideUp()'>Less</a>
						</span>
					{else}
						{$eContentRecord->contents}
					{/if}
				</div>
			</div>

			{/if}
			<div class="resultInformation">
				<div class="resultInformationLabel">{translate text='Published Reviews'}</div>
				<div class="recordSubjects">
					{if $showAmazonReviews || $showStandardReviews}
						<div id='reviewPlaceholder'></div>
					{/if}
				</div>
			</div>
{**
			<div class="resultInformation">
				<div class="resultInformationLabel">{translate text='Community Reviews'}</div>
				<div class="recordSubjects">
					<div id = "staffReviewtab" >
						{*include file="$module/view-staff-reviews.tpl"*}
{**
						<div class="ltfl_reviews"></div>
					</div>
				</div>
			</div>
{**}
			<div class="resultInformation">
				<div class="resultInformationLabel">Details</div>
				<div class="recordSubjects">
					<table>
					{if $eContentRecord->publisher}
					<tr>
						<td class="details_lable">Publisher</td>
						<td>
							<table>
								<tr><td>{$eContentRecord->publishLocation|escape}{$eContentRecord->publisher|escape} {if $eContentRecord->publishDate && $eContentRecord->publishDate != '01/01/0001'}{$eContentRecord->publishDate|escape}{/if}</td></tr>
								
							</table>
						</td>
					</tr>
					{/if}
					
					{if $eContentRecord->edition}
					<tr>
						<td class="details_lable">Edition</td>
						<td>
							<table>
							{foreach from=$eContentRecord->edition item=edition name=loop}
								<tr><td>{$eContentRecord->edition|escape}</td></tr>
							{/foreach}
							</table>
						</td>
					</tr>
					{/if}
					
					{if $targetNotes}
					<tr>
						<td class="details_lable">Audience</td>
						<td>
							<table>
								{foreach from=$targetNotes item=target name=loop}
									<tr><td>{$target|escape|trim}</td></tr>
								{/foreach}
							</table>
						</td>
					</tr>
					{/if}
					
					{if $eContentRecord->language}
						<tr>
							<td class="details_lable">{translate text='Language'}</td>
							<td>
								<table>
									<tr><td>{$eContentRecord->language|escape}</td></tr>
								</table>
							</td>
						</tr>
					{/if}
					<!--{if $corporateAuthor}
					<tr>
					<td class="details_lable">Addit Author</td>
					<td>
						<table>
							<tr>
								<a href="{$path}/Author/Home?author={$corporateAuthor|trim|escape:"url"}">{$corporateAuthor|escape}</a>
							</tr>
						</table>
					</td>
					</tr>
					{/if}-->

					{if $additionalAuthorsList}
					<tr>
						<td class="details_lable">{translate text='Contributors'}</td>
						<td>
							<table>
							{foreach from=$additionalAuthorsList item=additionalAuthors name=loop}
							<tr><td><a href="{$path}/Author/Home?author={$additionalAuthors|trim|escape:"url"}">{$additionalAuthors|escape|trim}</a></td></tr>
							{/foreach}
							</table>
						</td>
					</tr>
					{/if}
					
					{if $eContentRecord->notes}
					<tr>
					<td class="details_lable">Notes</td>
					<td>
						<table>
								<tr><td>{$eContentRecord->notes}</td></tr>

						</table>
					</td>
					</tr>
					{/if}
					
					{if $eContentRecord->physicalDescription}
					<tr>
						<td class="details_lable">Description</td>
						<td>
							<table>
								<tr><td>{$eContentRecord->physicalDescription|escape}</td></tr>
								
							</table>
						</td>
					</tr>
					{/if}
					
					{if $eContentRecord->isbn}
					<tr>
						<td class="details_lable">ISBN</td>
						<td>
							<table>
							{foreach from=$eContentRecord->getIsbn() item=tmpIsbn name=loop}
								<tr><td>{$tmpIsbn|escape}</td></tr>
							{/foreach}
							</table>
						</td>
					</tr>
					{/if}
					{if $issn}
						<tr>
						<td class="details_lable">{translate text='ISSN'}</td>
						
						<td>{$issn}</td>
						</tr>
						{if $goldRushLink}
						<tr>
							<td></td>
							<td><a href='{$goldRushLink}' target='_blank'>Check for online articles</a></td>
						</tr>
						{/if}
					{/if}
					{if !$eContentRecord->sourceUrl}
						{if $marcLinks}
							{foreach from=$marcLinks key=myId item=marcLink}
								{if $marcLink.link}
									<tr>
										<td class="details_lable" id="links">{if $myId == 0}Links{/if}</td>
										<td><a href="{$marcLink.link}" target="_blank">{$marcLink.linkText}</a></td>
									</tr>
								{/if}
							{/foreach}
						{else}
							{foreach from=$eContentRecord->getItems() item=eRec name=links}
								{if $eRec->link}
									<tr>
										<td class="details_lable" id="links">{if $smarty.foreach.links.index == 0}Links{/if}</td>
										<td><a href="{$eRec->link}" target="_blank">{if $eRec->notes}{$eRec->notes}{else}{$eRec->link}{/if}</a></td>
									</tr>
								{/if}
							{/foreach}
						{/if}
					{/if}
					{foreach from=$eContentRecord->getItems() item=eRec}
						{if $eRec->sampleName_1}
							<tr>
								<td class="details_lable">Supplemental Links</td>
								<td><a href="{$eRec->sampleUrl_1}" target="_blank">{$eRec->sampleName_1}</a></td>
							</tr>
						{/if}
						{if $eRec->sampleName_2}
							<tr>
								<td class="details_lable"></td>
								<td><a href="{$eRec->sampleUrl_2}" target="_blank">{$eRec->sampleName_2}</a></td>
							</tr>
						{/if}
					{/foreach}
					</table>
				</div>
			</div>
		</div>
  </div>
</div>
</div>
	<div id="right-bar">
            {include file="ei_tpl/right-bar.tpl"}
        </div>
</div>
     