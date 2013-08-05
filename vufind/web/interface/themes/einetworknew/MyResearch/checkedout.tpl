<script type="text/javascript" src="{$url}/services/MyResearch/ajax.js"></script>
<script type="text/javascript" src="{$url}/services/EcontentRecord/ajax.js"></script>
<script type="text/javascript" src="{$path}/js/checkedout.js"></script>
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

		{if $user->cat_username}
			{if $transList}
			<div>
			    <h2>Checked Out Items</h2>
				<p class="notification">We are receiving reports about some users not receiving email notices for upcoming due dates, hold pickups, or overdue items.  You may wish to check My Account or contact your local library for this information.   Please contact your email provider if you believe you are not receiving these notices.</p>
			</div>

			{if $profile.expireclose == 1}
			    <font color="red"><b>Your library card is due to expire within the next 30 days.  Please visit your local library to renew your card to ensure access to all online service.  </a></b></font>
			{/if}

			<h3>{translate text='Physical Checked Out Items'}</h3>
			{if $patronCanRenew}
				<div class="item_renew" style="text-align:right; padding-right:25px; padding-bottom:10px;" >
				<a href="#" onclick="return renewSelectedTitles();" class="btn btn-info"> Renew Selected Items</a>
				</div>
			{else}
			    <font color="red"><b>Our apologies, you cannot renew items because {$renewalBlockReason}.  Please visit your local library to ensure access to all online service.  </a></b></font>
			{/if}

			<form id="renewForm" action="{$path}/MyResearch/CheckedOut">

			{foreach from=$transList item=record name="recordLoop" }

			<div class="row">
			    <div class="col-lg-12">
			        <div class="accordion-group">
			            <div class="accordion-heading">
			                <div class="row">
			                    <div class="col-lg-1">
			                        <a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{if $record.id}{$record.id|escape}{/if}"><!-- --></a>
			                    </div>
			                    <div class="col-lg-8 book-results-title">
			                    	<ul>
			                            <li><a href="{$url}/Record/{$record.id|escape:"url"}" class="title">{if !$record.title|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$record.title|regex_replace:"/(\/|:)$/":""|truncate:100:"..."|highlight:$lookfor}{/if}</a></li>
			                            <li class="book-results-author"><span>
			                                {if $record.author}
												{if is_array($record.author)}
													{foreach from=$record.author item=author}
														<a href="{$path}/Author/Home?author={$author|escape:"url"}">{$author|highlight:$lookfor}</a>
													{/foreach}
												{else}
													<a href="{$path}/Author/Home?author={$summAuthor|escape:"url"}">{$record.author|highlight:$lookfor}</a>
												{/if}
											{/if}
			                            </span></li>
			                        </ul>
			                    </div>
			                    <div class="col-lg-3">
			                        <!-- collapsed actions -->
			                    </div>
		                  	</div>
		                </div>
			            <div id="collapse{if $record.id}{$record.id|escape}{/if}" class="accordion-body collapse in">
			                <div class="accordion-inner">
			                    <div class="row">
			                        <div class="col-lg-2 cover-image">
										{if $user->disableCoverArt != 1}
											{if $record.id}	
												<div id='descriptionPlaceholder{$record.id|escape}' style='display:none'></div>
												<a href="{$url}/Record/{$record.id|escape:"url"}" id="descriptionTrigger{$record.id|escape:"url"}">
												<img src="{$coverUrl}/bookcover.php?id={$record.id}&amp;isn={$record.isbn|@formatISBN}&amp;size=small&amp;upc={$record.upc}&amp;category={$record.format_category.0|escape:"url"}" class="listResultImage" alt="{translate text='Cover Image'}"/>
												</a>
											{/if}
										{/if}
			                        </div>
			                        <div class="col-lg-6 book-results">
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
			                            </ul>
			                        </div>
			                        <div class="col-lg-4 book-results-buttons">
		                            	<!-- expanded actions -->
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
			   
		<h3>{translate text='eContent Checked Out Items'}</h3>
	</div>
	<div class="col-lg-3">
		{include file="MyResearch/menu.tpl"}
		{include file="Admin/menu.tpl"}
	</div>
</div>