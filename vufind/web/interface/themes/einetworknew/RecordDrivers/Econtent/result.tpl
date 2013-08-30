{if $pageType eq 'WishList' || $pageType eq 'BookCart'}

<div class="row">
    <div class="col-xs-12 col-md-12 search-results">
        <a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{$record.shortId|escape}"></a>       
        <div class="accordion-group">
            <div class="accordion-heading">
                <div class="row">
                    <div class="col-xs-1 col-md-1">
                        
                    </div>
                    <div class="col-xs-9 col-md-9 book-results-title">
                        <ul>
                            <li><a href="{$path}/EcontentRecord/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title">{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:50:"..."|highlight:$lookfor}{/if}</a></li>
                            <li class="book-results-author"><span>
                                {if $summAuthor}
									{translate text='by'}
									{if is_array($summAuthor)}
										{foreach from=$summAuthor item=author}
											<a href="{$path}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
										{/foreach}
									{else}
										<a href="{$path}/Author/Home?author={$summAuthor|escape:"url"}">{$summAuthor|highlight:$lookfor}</a>
									{/if}
								{/if}
                            </span></li>
                        </ul>
                    </div>
                    <div class="col-xs-2 col-md-2">
                        <div class="btn-group btn-group-actions">
                            <button type="button" class="btn btn-small btn-default dropdown-toggle" data-toggle="dropdown">
                                Action <span class="caret"></span>
                            </button>
                            {if $pageType eq 'WishList'}
                                <ul class="dropdown-menu">
                                    <li><a class="disable-link" href="" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</a></li>
						        	{if sourceUrl}
						        		<li><a class="disable-link RequestWord{$summId|escape:"url"}" href="" onclick="window.location.href='{$sourceUrl}'">Access Online</a></li>
						        	{else}
						        		<li><a class="disable-link RequestWord{$summId|escape:"url"}" href="" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}#links'">Access Online</a></li>
						        	{/if}
						        	<li><a href="" onclick="deleteItemInList('{$summId|escape:"url"}','eContent')">Remove</a></li>
                                </ul>
                            {elseif $pageType eq 'BookCart'}
                                <ul class="dropdown-menu">
                                    <li><a class="disable-link" href="" onclick="requestItem('{$summId|escape:"url"}','{$wishListID}')">Request Now</a></li>
						            <li><a class="disable-link" href="" onclick="getSaveToListForm('{$summId|escape:"url"}', 'VuFind'); return false;">Move to Wish List</a></li>
						        	<li><a class="disable-link" href="" onclick="requestItem('{$summId|escape:"url"}','{$wishListID}')">Find in Library</a></li>
						        	<li><a class="disable-link" href="" onclick="deleteItemInList('{$summId|escape:"url"}','eContent')">Remove</a></li>
                                </ul>
                            {/if}
                        </div>
                    </div>
                </div>
                
            </div>
            <div id="collapse{if $summShortId}{$summShortId}{else}{$summId|escape}{/if}" class="accordion-body collapse in">
                <div class="accordion-inner">
                    <div class="row">
                        <div class="col-xs-4 col-md-4 cover-image">
                            {if !isset($user->disableCoverArt) ||$user->disableCoverArt != 1}	
								<div id='descriptionPlaceholder{$summId|escape}' style='display:none'></div>
								<a class="thumbnail" href="{$path}/EcontentRecord/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{$summId|escape:"url"}">
									<img src="{$bookCoverUrl}" class="listResultImage" alt="{translate text='Cover Image'}"/>
								</a>
							{/if}
                        </div>
                        <div class="col-xs-6 col-md-6 book-results">
                            <ul>
                                {if $summDate}
                                    <li>Year: <span>
                                        {if $summDate.0|escape|count_characters == 4 }
											{$summDate.0|escape}
										{else}
											{* Some Overdrive Items don't have a bib record and will show up as 01/01/0001 - which date_format turns into '1'.  Any year less than 10 gets hidden.*}
											{if $summDate.0|date_format:"%Y"|count_characters > 1 }{$summDate.0|escape|date_format:"%Y"}{/if}
										{/if}
                                    </span></li>
                                {/if}
                                <li><span>{include file="/usr/local/VuFind-Plus/vufind/web/interface/themes/einetwork/ei_tpl/formatType.tpl"}</span></li>
                                <li class="book-results-location">
                                    {if $source != "OverDrive"}
										<div id="availableOnline">
											<span>
											<img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Available.png" alt="Available"/>
											</span>			
											{if $sourceUrl }
											<a style="cursor:pointer" class="overdriveAvailable" onclick="window.location.href='{$sourceUrl}'">Available Online</a>
											{else}
											<a style="cursor:pointer" class="overdriveAvailable" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}#links'">Available Online</a>
											{/if}			
										</div>
									{/if}
									<div id= "holdingsEContentSummary{$summId|escape:"url"}" class="holdingsSummary">
										<div class="statusSummary" id="statusSummary{$summId|escape:"url"}">
											<span class="unknown" style="font-size: 8pt;">{translate text='Loading'}...</span>
										</div>
									</div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-xs-2 col-md-2 book-results-buttons">
                            {if $pageType eq 'WishList'}
                            	<div class="btn-group-vertical">
                                    <button type="button" class="btn btn-default" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</button>
									{if sourceUrl}
										<button type="button" class="btn btn-default" onclick="window.location.href='{$sourceUrl}'">Access Online</button>
									{else}
										<button type="button" class="btn btn-default" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}#links'">Access Online</button>
									{/if}
									<button type="button" class="btn btn-default" onclick="deleteItemInList('{$summId|escape:"url"}','eContent')">Remove</button>
                                </div>
                            {elseif $pageType eq 'BookCart'}
                            	<div class="btn-group-vertical">
                                    <button type="button" class="btn btn-default" onclick="requestItem('{$summId|escape:"url"}','{$wishListID}')">Request Now</button>
                                    <button type="button" class="btn btn-default" onclick="getSaveToListForm('{$summId|escape:"url"}', 'VuFind'); return false;">Move to Wish List</button>
                                    <button type="button" class="btn btn-default" onclick="requestItem('{$summId|escape:"url"}','{$wishListID}')">Find in Library</button>
                                    <button type="button" class="btn btn-default" onclick="deleteItemInList('{$summId|escape:"url"}','eContent')">Remove</button>
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{else}

<div class="row">
    <div class="col-xs-12 col-md-12 search-results">
        <div class="row">

            <div class="col-xs-3 col-md-3 cover-image">
               {if !isset($user->disableCoverArt) ||$user->disableCoverArt != 1}	
					<div id='descriptionPlaceholder{$summId|escape}' style='display:none'></div>
					<a class="thumbnail" href="{$path}/EcontentRecord/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{$summId|escape:"url"}">
						<img src="{$bookCoverUrl}" class="listResultImage" alt="{translate text='Cover Image'}"/>
					</a>
				{/if}
            </div>
            <div class="col-xs-9 col-md-9">
                <div class="row">
                    <div class="col-xs-8 col-md-8">
                        <ul class="search-results-list">
                            <li class"results-title">
                                <a href="{$path}/EcontentRecord/{$summId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title">{if !$summTitle|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$summTitle|regex_replace:"/(\/|:)$/":""|truncate:50:"..."|highlight:$lookfor}{/if}</a>  
                            </li>
                            <li>
                                <span class="author">
                                    {if $summAuthor}
										{translate text='by'}
										{if is_array($summAuthor)}
											{foreach from=$summAuthor item=author}
												<a href="{$path}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
											{/foreach}
										{else}
											<a href="{$path}/Author/Home?author={$summAuthor|escape:"url"}">{$summAuthor|highlight:$lookfor}</a>
										{/if}
									{/if}
                                </span>
                            </li>
                            {if $summDate}
                                <li>Year: <span>
                                    {if $summDate.0|escape|count_characters == 4 }
										{$summDate.0|escape}
									{else}
										{* Some Overdrive Items don't have a bib record and will show up as 01/01/0001 - which date_format turns into '1'.  Any year less than 10 gets hidden.*}
										{if $summDate.0|date_format:"%Y"|count_characters > 1 }{$summDate.0|escape|date_format:"%Y"}{/if}
									{/if}
                                </span></li>
                            {/if}
                            <li><span>{include file="/usr/local/VuFind-Plus/vufind/web/interface/themes/einetwork/ei_tpl/formatType.tpl"}</span></li>
                            <li class="book-results-location">
                                {if $source != "OverDrive"}
									<div id="availableOnline">
										<span>
										<img class="format_img" src="/interface/themes/einetwork/images/Art/AvailabilityIcons/Available.png" alt="Available"/>
										</span>			
										{if $sourceUrl }
										<a style="cursor:pointer" class="overdriveAvailable" onclick="window.location.href='{$sourceUrl}'">Available Online</a>
										{else}
										<a style="cursor:pointer" class="overdriveAvailable" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}#links'">Available Online</a>
										{/if}			
									</div>
								{/if}
								<div id = "holdingsEContentSummary{$summId|escape:"url"}" class="holdingsSummary">
									<div class="statusSummary" id="statusSummary{$summId|escape:"url"}">
										<span class="unknown" style="font-size: 8pt;">{translate text='Loading'}...</span>
									</div>
								</div>
                            </li>
                        </ul>
                    </div>
                    <div class="col-xs-4 col-md-4">
                    	<div class="btn-group-vertical">
	                        <button type="button" class="btn btn-default" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}'">View Details</button>
	                        {if $sourceUrl}
	                        	<button type="button" class="btn btn-default" onclick="window.location.href='{$sourceUrl}'">Access Online</button>
	                        {else}
	                        	<button type="button" class="btn btn-default" onclick="window.location.href='{$url}/EcontentRecord/{$summId|escape:"url"}/Home?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}#links'">Access Online</button>
	                    	{/if}
	                    </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div><!-- /resuts row -->

{/if}

<script type="text/javascript">
	addRatingId('{$summId|escape:"javascript"}', 'eContent');
	addIdToStatusList('{$summId|escape:"javascript"}', {if strcasecmp($source, 'OverDrive') == 0}'OverDrive'{else}'eContent'{/if});
	$(document).ready(function(){literal} { {/literal}
		resultDescription('{$summId}','{$summId}', 'eContent');
	{literal} }); {/literal}
	
</script>