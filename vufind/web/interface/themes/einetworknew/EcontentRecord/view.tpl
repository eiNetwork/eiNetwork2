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

{if $error}<p class="error">{$error}</p>{/if}

<div class="row">

    <div class="col-xs-3 col-md-3">
        {include file = "EcontentRecord/left-bar-record.tpl"}
    </div>
    <div class="col-xs-6 col-md-6 details-panel">
        <div class="row">
            <div class="col-xs-3 col-md-3">
                <a class="thumbnail" href="{$bookCoverUrl}">                            
                    <img alt="{translate text='Book Cover'}" class="recordcover" src="{$bookCoverUrl}" />
                </a>
                <div id="goDeeperLink" class="godeeper" style="display: none">
                    <a href="{$path}/EcontentRecord/{$id|escape:"url"}/GoDeeper" onclick="ajaxLightbox('{$path}/EcontentRecord/{$id|escape}/GoDeeper?lightbox', false,false, '700px', '110px', '70%'); return false;">
                        <img alt="{translate text='Go Deeper'}" src="{$path}/images/deeper.png" />
                    </a>
                </div>
            </div>
            <div class="col-xs-6 col-md-6">
                <div id='recordTitle'>{$eContentRecord->title|regex_replace:"/(\/|:)$/":""|escape}
                    {if $user && $user->hasRole('epubAdmin')}
                        {if $eContentRecord->status != 'active'}
                            <span id="eContentStatus">({$eContentRecord->status})</span>{/if}
                            <span id="editEContentLink"><a href='{$path}/EcontentRecord/{$id}/Edit'>(edit)</a></span>
                        {if $eContentRecord->status != 'archived' && $eContentRecord->status != 'deleted'}
                            <span id="archiveEContentLink"><a href='{$path}/EcontentRecord/{$id}/Archive' onclick="return confirm('Are you sure you want to archive this record?  The record should not have any holds or checkouts when it is archived.')">(archive)</a></span>
                        {/if}
                        {if $eContentRecord->status != 'deleted'}
                            <span id="deleteEContentLink"><a href='{$path}/EcontentRecord/{$id}/Delete' onclick="return confirm('Are you sure you want to delete this record?  The record should not have any holds or checkouts when it is deleted.')">(delete)</a></span>
                        {/if}
                    {/if}
                </div>
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
                    <div id="otherEditionCopies"></div>
                {/if}

            </div>
            <div class="col-xs-2 col-md-2">
                <div class="btn-group-vertical">
                    {if $eContentRecord->source == 'OverDrive'}
                        {if $holdingsSummary.status == 'Checked out in OverDrive'}
                            <button type="button" class="btn btn-default btn-sm" onclick="placeOverDriveHold('{$record.overDriveId}', '{$format.formatId}')">Request Now</button>
                        {elseif $holdingsSummary.status == 'Available from OverDrive'}
                            <button type="button" class="btn btn-default btn-sm" onclick="checkoutOverDriveItem('{$format.overDriveId}','{$format.formatId}')">Checkout Now</button>
                        {else}
                            {if $eContentRecord->sourceUrl  }
                                <button type="button" class="btn btn-default btn-sm" onclick="window.location.href='{$eContentRecord->sourceUrl}'">Access Online</button>
                            {else}
                                <button type="button" class="btn btn-default btn-sm" onclick="findInLibrary('{$id|escape:"url"}',false,'150px','570px','auto')" id="access-online">Loading...</button>
                            {/if}
                        {/if}
                    {else}
                        {if $eContentRecord->sourceUrl && $eContentRecord->sourceUrl != "" }
                            <button type="button" class="btn btn-default btn-sm" onclick="window.location.href='{$eContentRecord->sourceUrl}'">Access Online</button>
                        {else}
                            <button type="button" class="btn btn-default btn-sm" onclick="window.location.href='#links'">Access Online</button>
                        {/if}
                    {/if}
                    <button type="button" class="btn btn-default btn-sm" onclick="getSaveToListForm('{$id|escape}', 'eContent'); return false;">Add To Wish List</button>

                </div>
            </div>
        </div>

        
        <div class="row">
            <div class="col-xs-12 col-md-12">
                <ul class="search-results-list">
                    {if $eContentRecord->source != "OverDrive"}
                        <li>
                            <div id="availableOnline">
                                <img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Available.png" alt="Available"/>
                                {if $eContentRecord->sourceUrl }
                                <a style="cursor:pointer" class="overdriveAvailable" onclick="window.location.href='{$eContentRecord->sourceUrl}'">Available Online</a>
                                {else}
                                <a style="cursor:pointer" class="overdriveAvailable" onclick="window.location.href='#links'">Available Online</a>
                                {/if}
                            </div>
                        </li>
                    {/if}
                    <li>
                        <div id="holdingsSummaryPlaceholder" class="holdingsSummaryRecord">Loading...</div>
                    </li>
                    <li>
                        {if $enableProspectorIntegration == 1}
                            <div id="prospectorHoldingsPlaceholder"></div>
                        {/if}
                    </li>
                    {if is_array($eContentRecord->format())}
                        <li>
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
                              {elseif $eContentRecord->format eq "OverDrive Read"}
                              <span><img class="format_img" src="/interface/themes/einetwork/images/Art/Materialicons/EbookDownload.png"/ alt="Ebook Download"></span>
                              {/if} 
                                <span class="iconlabel {$eContentRecord->format()|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$eContentRecord->format}</span></div>
                        </li>
                    {/if}
                </ul>
            </div>
        </div>

        <div class="row">
            <div class="col-xs-12 col-md-12">
                <ul class="search-results-list">
                    {if $eContentRecord->description}
                        <li class="details-page-header">
                            {translate text='Description'}
                            <ul>
                                <li>
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
                                </li>
                            </ul>
                        </li>
                    {/if}

                    {if $summary}
                        <li class="details-page-header">
                            {translate text='Summary'}
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

                    {if $eContentRecord->contents}
                        <li class="details-page-header">
                            {translate text='Contents'}
                            <ul>
                                <li>
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
                                </li>
                            </ul>
                        </li>
                    {/if}

                    {if $showAmazonReviews || $showStandardReviews}
                        <li class="details-page-header">
                            {translate text='Published Reviews'}
                            <ul>
                                <li>
                                    <div id='reviewPlaceholder'></div>
                                </li>
                            </ul>
                        </li>
                    {/if}

                    <li class="details-page-header">
                        {translate text='Community Reviews'}
                        <ul>
                            <li>
                                <div id = "staffReviewtab" >
                                    {*include file="$module/view-staff-reviews.tpl"*}
                                    <div class="ltfl_reviews"></div>
                                </div>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>

        <div class="row">
            <div class="col-xs-12 col-md-12 details-info">

                <table class="table">
                    {if $eContentRecord->publisher}
                        <tr>
                            <th>{translate text='Publisher'}</th>
                            <td>
                                <table class="table-noborder">
                                    <tr>
                                        <td>
                                            {$eContentRecord->publishLocation|escape}
                                            {$eContentRecord->publisher|escape} 
                                            {if $eContentRecord->publishDate && $eContentRecord->publishDate != '01/01/0001'}
                                                {$eContentRecord->publishDate|escape}
                                            {/if}
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    {/if}

                    {if $eContentRecord->edition}
                        <tr>
                            <th>{translate text='Edition'}</th>
                            <td>
                                <table class="table-noborder">
                                    {foreach from=$eContentRecord->edition item=edition name=loop}
                                        <tr>
                                            <td>{$eContentRecord->edition|escape}</td>
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

                    {if $eContentRecord->language}
                        <tr>
                            <th>{translate text='Language'}</th>
                            <td>
                                <table class="table-noborder">
                                    <tr>
                                        <td>{$eContentRecord->language|escape}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    {/if}

                    {if $additionalAuthorsList}
                        <tr>
                            <th>{translate text='Contributors'}</th>
                            <td>
                                <table class="table-noborder">
                                    {foreach from=$additionalAuthorsList item=additionalAuthors name=loop}
                                        <tr>
                                            <td><a href="{$path}/Author/Home?author={$additionalAuthors|trim|escape:"url"}">{$additionalAuthors|escape|trim}</a></td>
                                        </tr>
                                    {/foreach}
                                </table>
                            </td>
                        </tr>
                    {/if}

                    {if $eContentRecord->notes}
                        <tr>
                            <th>{translate text='Notes'}</th>
                            <td>
                                <table class="table-noborder">
                                    <tr>
                                        <td>{$eContentRecord->notes}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    {/if}

                    {if $eContentRecord->physicalDescription}
                        <tr>
                            <th>{translate text='Description'}</th>
                            <td>
                                <table class="table-noborder">
                                    <tr>
                                        <td>{$eContentRecord->physicalDescription|escape}</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    {/if}

                    {if $eContentRecord->isbn}
                        <tr>
                            <th>ISBN</th>
                            <td>
                                <table class="table-noborder">
                                    {foreach from=$eContentRecord->getIsbn() item=tmpIsbn name=loop}
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
                            <td>
                                <table class="table-noborder">
                                    <tr>
                                        <td>{$issn}</td>
                                    </tr>
                                    {if $goldRushLink}
                                        <tr>
                                            <td><a href='{$goldRushLink}' target='_blank'>Check for online articles</a></td>
                                        </tr>
                                    {/if}
                                </table>
                            </td>
                        </tr>
                    {/if}

                    {if !$eContentRecord->sourceUrl}
                        {foreach from=$eContentRecord->getItems() item=eRec name=links}
                            {if $eRec->link}
                                <tr>
                                    <th>{if $smarty.foreach.links.index == 0}Links{/if}</th>
                                    <td>
                                        <table class="table-noborder">
                                            <tr>
                                                <td><a href="{$eRec->link}" target="_blank">{if $eRec->notes}{$eRec->notes}{else}{$eRec->link}{/if}</a></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            {/if}
                        {/foreach}
                    {/if}

                    {foreach from=$eContentRecord->getItems() item=eRec}
                        <tr>
                            <th>{translate text='Supplemental Links'}</th>
                            <td>
                                <table class="table-noborder">
                                    {if $eRec->sampleName_1}
                                        <tr>
                                            <td><a href="{$eRec->sampleUrl_1}" target="_blank">{$eRec->sampleName_1}</a></td>
                                        </tr>
                                    {/if}
                                    {if $eRec->sampleName_2}
                                        <tr>
                                            <td><a href="{$eRec->sampleUrl_1}" target="_blank">{$eRec->sampleName_2}</a></td>
                                        </tr>
                                    {/if}
                                </table>
                            </td>
                        </tr>
                    {/foreach}
                </table>
            </div>
        </div>
    </div>
    <div class="col-xs-3 col-md-3">
        {include file="ei_tpl/right-bar.tpl"}
    </div>

</div>

{if $showStrands}   
{* Strands Tracking *}{literal}
<!-- Event definition to be included in the body before the Strands js library -->
<script type="text/javascript">
if (typeof StrandsTrack=="undefined"){StrandsTrack=[];}
StrandsTrack.push({
   event:"visited",
   item: "{/literal}econtentRecord{$id|escape}{literal}"
});
</script>
{/literal}
{/if}
     