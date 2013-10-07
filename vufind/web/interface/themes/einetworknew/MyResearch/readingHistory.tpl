<script type="text/javascript" src="{$path}/js/toggles.min.js"></script>
{literal}
<script type="text/javascript">

	$(document).ready(function(){

		var collapsed = {/literal}{$readinghistory_collapse}{literal};

		if (collapsed == 1){
			$('.toggle').toggles({
				clicker: $('.clickme'),
				text: {
			      on: 'Brief', // text for the ON position
			      off: 'Full' // and off
			    },
				on: true
			});
		} else {
			$('.toggle').toggles({
				clicker: $('.clickme'),
				text: {
			      on: 'Brief', // text for the ON position
			      off: 'Full' // and off
			    }
			});
		}

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

			if ($('#show-all-button').val() == 'Full View'){
				$('.save-expand-collapse').prop('checked', false)
				$('.pref-saved').hide();
				$('.accordion-body').collapse('show');
				$('#show-all-button').val('Brief View');
				collapsed  = 0;
			} else if ($('#show-all-button').val() == 'Brief View'){
				$('.save-expand-collapse').prop('checked', false)
				$('.pref-saved').hide();
				$('.accordion-body').collapse('hide');
				$('#show-all-button').val('Full View');
				collapsed  = 1;
			}

		})

		$('.toggle').on('toggle', function (e, active) {
		    if (active) {
		        readinghistory_collapse = 1;
		    } else {
		        readinghistory_collapse = 0;
		    }

		    var url = path + "/MyResearch/AJAX?method=saveExpandCollapseState";
			
			$.ajax({
				url : url,
				data : {
					'readinghistory_collapse': readinghistory_collapse,
				},
				success: function(){
					
				},
				dataType : 'text',
				type : 'get'
			});

		});

		// save expand collapse
		if (collapsed == 1){
			$('#show-all-button').trigger('click')
		}

	});

</script>
{/literal}
{if (isset($title)) }
<script type="text/javascript">
	alert("{$title}");
</script>
{/if}
<script type="text/javascript" src="{$path}/js/readingHistory.js" ></script>
<script type="text/javascript" src="{$path}/services/MyResearch/ajax.js" ></script>
<script type="text/javascript" src="{$path}/js/tablesorter/jquery.tablesorter.min.js"></script>

<div id="page-content" class="row">
  
	<div id="main-content" class="col-xs-9 col-md-9">
		<div>
		{if $transList}		
			<div class="pull-right myaccount-sort-container">
				<label class="myaccount-sort-label">Sort by&nbsp;</label>
				<select name="sort" class="form-control myaccount-sort-select" onchange="document.location.href = '/MyResearch/ReadingHistory?page={$page|escape}&accountSort='+this.options[this.selectedIndex].value;">
					{foreach from=$sortOptions item=sortLabel key=sortData}
						<option value="{$sortData|escape}"{if $sortData == $defaultSortOption} selected="selected"{/if}>{translate text=$sortLabel}</option>
					{/foreach}
				</select>
			</div>	
		{/if}

		{if $user->cat_username}
		
		<h2>{translate text='Reading History'} {if $historyActive == true} <span class="readingListWhatsThis">(<a id='readingListWhatsThis' class="disable-link" onclick="$('#readingListDisclaimer').toggle();">What's This?</a>)</span>{/if}</h2></div>
		{if $userNoticeFile}
			{include file=$userNoticeFile}
		{/if}

		<div id='readingListDisclaimer' {if $historyActive == true}style='display: none'{/if}>
		The library takes seriously the privacy of your library records. Therefore, we do not keep track of what you borrow after you return it. 
		However, our automated system has a feature called "My Reading History" that allows you to track items you check out. 
		Participation in the feature is entirely voluntary. You may start or stop using it, as well as delete all entries in "My Reading History" at any time. 
		If you choose to start recording "My Reading History", you agree to allow our automated system to store this data. 
		The library staff does not have access to your "My Reading History", however, it is subject to all applicable local, state, and federal laws, and under those laws, could be examined by law enforcement authorities without your permission. 
		If this is of concern to you, you should not use the "My Reading History" feature.
		</div>
          
				<div class="page">
					<form id='readingListForm' action ="{$fullPath}">
						<div>
							<input name='readingHistoryAction' id='readingHistoryAction' value='' type='hidden' />
						

							<div class="row list-header">
								<div class="col-xs-3 col-md-3">
									<p style="font-size:13px;float:left; margin:6px 10px 0 0">Switch to</p><input type="button" id="show-all-button" class="btn btn-sm btn-default" value="Brief View" />
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="clickme" style="margin:6px 0 0 0;"><span style="font-size:13px; float: left">My Preferred View </span><div style="float:left; margin-left:10px" rel="clickme" class="toggle toggle-light"></div></div>
								</div>
								<div class="col-xs-5 col-md-5 btn-renew-all">
									{if $historyActive == true}
										{if $transList}
	<!--										<input class="button" onclick='return deletedMarkedAction()' value="Delete Marked">
	-->										<input class="btn btn-warning" type="button" onclick='return deleteAllAction()' value="Delete All">
										{/if}
										<input class="btn btn-warning" type="button" onclick='return optOutAction({if $transList}true{else}false{/if})' value="Stop Recording">
									{else}
										<input class="btn btn-warning" type="button" onclick='return optInAction()' value="Start Recording My Reading History">
									{/if}
								</div>
							</div>

							{if $transList}
								<div class="clearfix"></div>
								<div>{if $pageLinks.all}<div class="pagination pagination-sm pull-right">{$pageLinks.all}</div>{/if}</div>			
								<div class=clearfix></div>
							{/if}
							
							{if $transList}

								<div class="row clearfix">
									<div class="col-xs-12 col-md-12">

										<table class="table">
											<tr>
												<th class="col-xs-6 col-md-6" style="text-align: center">{translate text='Title'}</th>
												<th class="col-xs-2 col-md-2" style="text-align: center">{translate text='Format'}</th>
												<th class="col-xs-2 col-md-2" style="text-align: center">{translate text='Out'}</th>
												<th class="col-xs-2 col-md-2" style="text-align: center">{translate text=''}</th>
											</tr>
										</table>

									</div>
								</div>

								{php}

      								$i=0;

      							{/php}
      								
      							{foreach from=$transList item=record name="recordLoop" key=recordKey }

      							{php}

      								$i++;

      							{/php}

      								<div class="row">
									    <div class="col-xs-12 col-md-12">
									    	<a class="accordion-toggle accordion-toggle-collapse" data-toggle="collapse" data-parent="#accordion2" href="#collapse{php}echo $i{/php}"></a>
									        <div class="accordion-group">
									        	<div class="accordion-heading">

									        	</div>
									        	<div class="results-header clearfix ">
					 				            	<div class="row results-title-header">
									            		<div class="col-xs-12 col-md-12">
									            			
										        		</div>
										        	</div>
										        	<div class="row">
										        		<div class="col-xs-6 col-md-6 col-lg-6">
															<ul class="requested-results requested-results-collapse">
																<li class"results-title">
																	<a href="{$url}/Record/{$record.recordId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title">{if !$record.title|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$record.title|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}{/if}</a>
																	{if $record.title2}
																	<div class="searchResultSectionInfo">
																	{$record.title2|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}
																	</div>
																	{/if}
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
																	{/if}
																	{if $record.publicationDate}{translate text='Published'} {$record.publicationDate|escape}{/if}
																	</span>
																</li>
															</ul>
														</div>
														<div class="col-xs-2 col-md-2" style="text-align: center">
															{if is_array($record.format)}
															{foreach from=$record.format item=format}
																{translate text=$format}
															{/foreach}
															{else}
															{translate text=$record.format}
															{/if}
														</div>
														<div class="col-xs-2 col-md-2" style="text-align: center">{$record.checkout|escape}{if $record.lastCheckout} to {$record.lastCheckout|escape}{/if}</div>
														{if $record.recordId != -1}
															<script type="text/javascript">
															  $(document).ready(function(){literal} { {/literal}
															      resultDescription('{$record.recordId}','{$record.recordId}');
															  {literal} }); {/literal}
															</script>
														{/if}
														<div class="col-xs-2 col-md-2"><input class="btn btn-warning" type="button" value="Delete" onclick="deleteOne('{$record.rsh|escape:"url"}')" /></div>
								                    </div>
								                </div>
									            <div id="collapse{php}echo $i{/php}" class="accordion-body collapse in">
									                <div class="accordion-inner requested-results-striped clearfix">
									                	<div class="col-xs-2 col-md-2 col-lg-2 cover-image">
									                		{if $user->disableCoverArt != 1}
																<div class="imageColumn cover-image">	  
																<a class="thumbnail" href="{$url}/Record/{$record.recordId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" id="descriptionTrigger{$record.recordId|escape:"url"}">
																<img src="{$path}/bookcover.php?id={$record.recordId}&amp;isn={$record.isbn|@formatISBN}&amp;size=small&amp;upc={$record.upc}&amp;category={$record.format_category|escape:"url"}" class="listResultImage" alt="{translate text='Cover Image'}"/>
																</a>
																<div id='descriptionPlaceholder{$record.recordId|escape}' style='display:none'></div>
																</div>
															{/if}
										        		</div>
									                	<div class="col-xs-4 col-md-4 col-lg-4">

									                		<ul class="requested-results">
																<li class"results-title">
																	<a href="{$url}/Record/{$record.recordId|escape:"url"}?searchId={$searchId}&amp;recordIndex={$recordIndex}&amp;page={$page}" class="title">{if !$record.title|regex_replace:"/(\/|:)$/":""}{translate text='Title not available'}{else}{$record.title|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}{/if}</a>
																	{if $record.title2}
																	<div class="searchResultSectionInfo">
																	{$record.title2|regex_replace:"/(\/|:)$/":""|truncate:180:"..."|highlight:$lookfor}
																	</div>
																	{/if}
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
																	{/if}
																	{if $record.publicationDate}{translate text='Published'} {$record.publicationDate|escape}{/if}
																	</span>
																</li>
															</ul>
														</div>
														<div class="col-xs-2 col-md-2" style="text-align: center">
															{if is_array($record.format)}
															{foreach from=$record.format item=format}
																{translate text=$format}
															{/foreach}
															{else}
															{translate text=$record.format}
															{/if}
														</div>
														<div class="col-xs-2 col-md-2" style="text-align: center">{$record.checkout|escape}{if $record.lastCheckout} to {$record.lastCheckout|escape}{/if}</div>
														{if $record.recordId != -1}
															<script type="text/javascript">
															  $(document).ready(function(){literal} { {/literal}
															      resultDescription('{$record.recordId}','{$record.recordId}');
															  {literal} }); {/literal}
															</script>
														{/if}
														<div class="col-xs-2 col-md-2"><input class="btn btn-warning" type="button" value="Delete" onclick="deleteOne('{$record.rsh|escape:"url"}')" /></div>
									                </div><!-- /accordion-inner -->
									            </div><!-- /collapsed -->
									        </div><!-- /accordion-group -->
									    </div>
									</div><!-- /resuts row -->
									
								{/foreach}          
							    
			<script type="text/javascript">
				$(document).ready(function() {literal} { {/literal}
					doGetRatings();
					{literal} }); {/literal}
			</script>
				{else if $historyActive == true}
				  {* No Items in the history, but the history is active *}
				  You do not have any items in your reading list.  It may take up to 3 hours for your reading history to be updated after you start recording your history.
				  <div class=clearfix></div>				  
				{/if}
				{if $transList} {* Don't double the actions if we don't have any items *}
					<div id="readingListActionsBottom" class="pull-right">
					{if $historyActive == true}
						{if $transList}
<!--						<input class="button" onclick="return deletedMarkedAction()" value="Delete Marked">
-->						<input class="btn btn-warning" type="button" onclick="return deletedAllAction()" value="Delete All">
						{/if}
						<input class="btn btn-warning" type="button" onclick='return optOutAction({if $transList}true{else}false{/if})' value="Stop Recording">
						{else}
						<input class="btn btn-warning" type="button" onclick="return optInAction()" value="Start Recording My Reading History">
						{/if}
					</div>
				{/if}
				{if $transList}
					<div class=clearfix></div>
					<div>{if $pageLinks.all}<div class="pagination pagination-sm pull-right">{$pageLinks.all}</div>{/if}</div>			
					<div class=clearfix></div>
				{/if}
		</div>
	</form>
	</div>{else}
	<div class="page">
	You must login to view this information. Click <a href="{$path}/MyResearch/Login">here</a> to login.
	</div>
	{/if}
	</div>

  <div class="col-xs-3 col-md-3">
	{*right-bar template*}
	{include file="ei_tpl/right-bar.tpl"}
  </div>
</div>