{if $pageType eq 'WishList' || $pageType eq 'BookCart'}

<div class="row">
    <div class="col-xs-12 col-md-12 search-results">
        <a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{$summShortId|escape}"></a>
        <div class="accordion-group">
            <div class="accordion-heading">

            </div>
            <div class="results-header clearfix">
                <div class="row results-title-header">
                    <div class="col-xs-9 col-md-9 results-title">
                        <a href="{$url}/Record/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title" title="{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""}{/if}">{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:50:"..."|highlight:$lookfor}{/if}</a>
                        | <span class="author">
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
                            </span>

                    </div>
                    <div class="col-xs-3 col-md-3">
                        <div class="btn-group wishlist-dropdown-actions pull-right">
                            <button type="button" class="btn btn-small btn-default dropdown-toggle" data-toggle="dropdown">
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
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
            <div id="collapse{$summShortId|escape}" class="accordion-body collapse in">
                <div class="accordion-inner requested-results-striped clearfix">

                    <div class="col-xs-2 col-md-2 col-lg-2 cover-image">
                        {if $user->disableCoverArt != 1}  
                                <div id='descriptionPlaceholder{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}' style='display:none'></div>
                            <a class="thumbnail" href="{$url}/Record/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
                                <img src="{$bookCoverUrl}" class="listResultImage" alt="{translate text='Cover Image'}"/>
                            </a>
                        {/if}
                        {* Place hold link *}
                    </div>
                    <div class="col-xs-10 col-md-10">

                        <div class="row">
                            <div class="col-xs-9 col-md-9">
                                <ul class="search-results-list">
                                    <li class"results-title">
                                            <a href="{$url}/Record/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title" title="{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""}{/if}">{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:50:"..."|highlight:$lookfor}{/if}</a>
                                        </a>
                                    </li>
                                    <li>
                                        <span class="author">
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
                                        </span>
                                    </li>
                                    <li class="requested-results-format">
                                        {include file="/usr/local/VuFind-Plus/vufind/web/interface/themes/einetwork/ei_tpl/formatType.tpl"}
                                    </li>
                                    <li class="book-results-location">
                                        <div id = "holdingsSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="holdingsSummary">
                                            <div class="statusSummary" id="statusSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
                                                <span class="unknown" style="font-size: 8pt;">{translate text='Loading'}...</span>
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                            <div class="col-xs-3 col-md-3 search-results-actions">
                                {if $pageType eq 'WishList'}
                                    <div class="btn-group-vertical pull-right">
                                        <button type="button" class="btn btn-default" onclick="window.location.href ='{$url}/Record/{$summId|escape:'url'}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</button>
                                        <button type="button" class="btn btn-default" {if $enableBookCart}onclick="getSaveToBookCart('{$summId|escape:"url"}','VuFind');return false;"{/if}>Move To Cart</button>
                                        <button type="button" class="btn btn-default" onclick="deleteItemInList('{$summId|escape:"url"}','VuFind')">Remove</button>
                                    </div>
                                {elseif $pageType eq 'BookCart'}
                                    <div class="btn-group-vertical pull-right">
                                        <button type="button" class="btn btn-default" onclick="requestItem('{$summId|escape:"url"}','{$wishListID}')">Request Item</button>
                                        <button type="button" class="btn btn-default" onclick="getSaveToListForm('{$summId|escape:"url"}', 'VuFind'); return false;">Move to Wish List</button>
                                        <button type="button" class="btn btn-default" onclick="findInLibrary('{$summId|escape:"url"}',false,'150px','570px','auto')">Find in Library</button>
                                        <button type="button" class="btn btn-default" onclick="deleteItemInList('{$summId|escape:"url"}','VuFind')">Remove</button>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div><!-- /accordion-inner -->
            </div><!-- /collapsed -->
        </div><!-- /accordion-group -->
    </div>
</div><!-- /resuts row -->

{else}

<div class="row">
    <div class="col-xs-12 col-md-12 search-results">
        <div class="row">

            <div class="col-xs-3 col-md-3 cover-image">
               {if $user->disableCoverArt != 1}  
                <a class="thumbnail" href="{$url}/Record/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
                    <img src="{$bookCoverUrl}" class="listResultImage" alt="{translate text='Cover Image'}"/>
                </a>
            {/if}
            {* Place hold link *}
            </div>
            <div class="col-xs-9 col-md-9">
                <div class="row">
                    <div class="col-xs-8 col-md-8">
                        <ul class="requested-results">
                            <li class"results-title">
                                <a href="{$url}/Record/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title" title="{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""}{/if}">{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:50:"..."|highlight:$lookfor}{/if}</a>    
                            </li>
                            <li>
                                <span class="author">
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
                                </span>
                            </li>
                        </ul>
                    </div>
                    <div class="col-xs-4 col-md-4">
                        <div class="btn-group-vertical">
                            <button type="button" class="btn btn-default" onclick="window.location.href ='{$url}/Record/{$summId|escape:'url'}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</button>
                            <button type="button" class="btn btn-default" {if $enableBookCart}onclick="getSaveToBookCart('{$summId|escape:"url"}','VuFind');return false;"{/if}>Add To Cart</button>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xs-12 col-md-12">
                        <ul class="search-results-list">
                            <li class="requested-results-format">
                                {include file="/usr/local/VuFind-Plus/vufind/web/interface/themes/einetwork/ei_tpl/formatType.tpl"}
                            </li>
                            <li class="book-results-location">
                                <div id = "holdingsSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="holdingsSummary">
                                    <div class="statusSummary" id="statusSummary{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}">
                                        <span class="label label-warning">{translate text='Loading'}...</span>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div><!-- /resuts row -->

{/if}

<script type="text/javascript">

    addRatingId('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}');
    addIdToStatusList('{$summId|escape}');
    $(document).ready(function(){literal} { {/literal}
        resultDescription('{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}','{$summId}');
    {literal} }); {/literal}
    getItemStatusCart('{$summId|escape}');

</script>