<div class="row">
    <div class="col-lg-12">
        <div class="accordion-group">
            <div class="accordion-heading">
                <div class="row">
                    <div class="col-lg-1">
                        <a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}"><!-- --></a>
                    </div>
                    <div class="col-lg-9 book-results-title">
                        <ul>
                            <li><a href="{$url}/Record/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title" title="{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""}{/if}">{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:50:"..."|highlight:$lookfor}{/if}</a></li>
                            <li class="book-results-author"><span>
                                {if $summAuthor}
                                    {translate text=''}
                                    {if is_array($summAuthor)}
                                        {foreach from=$summAuthor item=author}
                                        <a href="{$url}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
                                        {/foreach}
                                    {else}
                                        <a href="{$url}/Author/Home?author={$summAuthor|escape:"url"}">{$summAuthor|highlight:$lookfor}</a>
                                    {/if}
                                {/if}
                                {if $summCorpAuthor}
                                    {translate text=''}
                                    {if is_array($summCorpAuthor)}
                                        {foreach from=$summCorpAuthor item=corpAuthor}
                                        <a href="{$url}/Author/Home?author={$corpAuthor|escape:"url"}">{$corpAuthor|highlight:$lookfor}</a>
                                        {/foreach}
                                    {else}
                                        <a href="{$url}/Author/Home?author={$summCorpAuthor|escape:"url"}">{$summCorpAuthor|highlight:$lookfor}</a>
                                    {/if}
                                {/if}
                            </span></li>
                        </ul>
                    </div>
                    <div class="col-lg-2">
                        <div class="btn-group btn-group-actions">
                            <button type="button" class="btn btn-small btn-info dropdown-toggle" data-toggle="dropdown">
                                Action <span class="caret"></span>
                            </button>
                            {if $pageType eq 'WishList'}
                                <ul class="dropdown-menu">
                                    <li><a class="disable-link" href="" onclick="window.location.href ='{$url}/Record/{$summId|escape:'url'}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</a></li>
                                    <li><a class="disable-link" href="" {if $enableBookCart}onclick="getSaveToBookCart('{$summId|escape:"url"}','VuFind');return false;"{/if}>Move to Cart</a></li>
                                    <li><a class="disable-link" href="" onclick="deleteItemInList('{$summId|escape:"url"}','VuFind')">Remove</a></li>
                                </ul>
                            {elseif $pageType eq 'BookCart'}
                                <ul class="dropdown-menu">
                                    <li><a class="disable-link" href="" onclick="requestItem('{$summId|escape:"url"}','{$wishListID}')">Request Item</a></li>
                                    <li><a class="disable-link" href="" onclick="getSaveToListForm('{$summId|escape:"url"}', 'VuFind'); return false;">Move to Wish List</a></li>
                                    <li><a class="disable-link" href="" onclick="findInLibrary('{$summId|escape:"url"}',false,'150px','570px','auto')">Find in Library</a></li>
                                    <li><a class="disable-link" href=""><a href="" onclick="deleteItemInList('{$summId|escape:"url"}','VuFind')">Remove</a>
                                </ul>
                            {else}
                                <ul class="dropdown-menu">
                                    <li><a class="disable-link" href="" onclick="window.location.href ='{$url}/Record/{$summId|escape:'url'}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</a></li>
                                    <li><a class="disable-link" href="" {if $enableBookCart}onclick="getSaveToBookCart('{$summId|escape:"url"}','VuFind');return false;"{/if}>Add to Cart</a></li>
                                </ul>
                            {/if}
                        </div>
                    </div>
                </div>
                
            </div>
            <div id="collapse{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="accordion-body collapse in">
                <div class="accordion-inner">
                    <div class="row">
                        <div class="col-lg-4 cover-image">
                            {if $user->disableCoverArt != 1}  
                                <div id='descriptionPlaceholder{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}' style='display:none'></div>
                                <a href="{$url}/Record/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
                                    <img src="{$bookCoverUrl}" class="listResultImage" alt="{translate text='Cover Image'}"/>
                                </a>
                            {/if}
                            {* Place hold link *}
                        </div>
                        <div class="col-lg-6 book-results">
                            <ul>
                                {if $summDate}
                                    <li>Year: <span>
                                        {if $summDate}
                                                {$summDate.0|escape}
                                        {/if}
                                    </span></li>
                                {/if}
                                <li>Material Type: <span>{include file="/usr/local/VuFind-Plus/vufind/web/interface/themes/einetwork/ei_tpl/formatType.tpl"}</span></li>
                                <li class="book-results-location">
                                    <div id = "holdingsSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="holdingsSummary">
                                        <div class="statusSummary" id="statusSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
                                            <span class="unknown" style="font-size: 8pt;">{translate text='Loading'}...</span>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-2 book-results-buttons">
                            {if $pageType eq 'WishList'}
                                <a href="" class="btn btn-small btn-info disable-link" onclick="window.location.href ='{$url}/Record/{$summId|escape:'url'}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</a>
                                <a href="" class="btn btn-small btn-info disable-link" {if $enableBookCart}onclick="getSaveToBookCart('{$summId|escape:"url"}','VuFind');return false;"{/if}>Move To Cart</a>
                                <a href="" class="btn btn-small btn-info disable-link" onclick="deleteItemInList('{$summId|escape:"url"}','VuFind')">Remove</a>
                            {elseif $pageType eq 'BookCart'}
                                <a href="" class="btn btn-small btn-info disable-link" onclick="requestItem('{$summId|escape:"url"}','{$wishListID}')">Request Item</a>
                                <a href="" class="btn btn-small btn-info disable-link" onclick="getSaveToListForm('{$summId|escape:"url"}', 'VuFind'); return false;">Move to Wish List</a>
                                <a href="" class="btn btn-small btn-info disable-link" onclick="findInLibrary('{$summId|escape:"url"}',false,'150px','570px','auto')">Find in Library</a>
                                <a href="" class="btn btn-small btn-info disable-link" onclick="deleteItemInList('{$summId|escape:"url"}','VuFind')">Remove</a>
                            {else}
                                <a href="" class="btn btn-small btn-info disable-link" onclick="window.location.href ='{$url}/Record/{$summId|escape:'url'}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</button>
                                <a href="" class="btn btn-small btn-info disable-link" {if $enableBookCart}onclick="getSaveToBookCart('{$summId|escape:"url"}','VuFind');return false;"{/if}>Add To Cart</a>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

    addRatingId('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}');
    addIdToStatusList('{$summId|escape}');
    $(document).ready(function(){literal} { {/literal}
        resultDescription('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}','{$summId}');
    {literal} }); {/literal}
    getItemStatusCart('{$summId|escape}');

</script>