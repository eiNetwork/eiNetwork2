<script type="text/javascript" src="{$path}/services/EcontentRecord/ajax.js"></script>
{* Main Listing *}
{if (isset($title)) }
<script type="text/javascript">
	alert("{$title}");
</script>
{/if}
{literal}
<script type="text/javascript">

	$(document).ready(function(){

		var expanded = true;

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

			if (expanded == true){
				$('.accordion-body').collapse('hide');
				$('#show-all-button').val('Full View');
				expanded = false;
			} else {
				$('.accordion-body').collapse('show');
				$('#show-all-button').val('Brief View');
				expanded = true;
			}

		})

	});

</script>
{/literal}

<div class="row">

	<div class="col-xs-9 col-md-9">

		<input type="hidden" value="{$wishListID}" id="listId"/>
		<script type="text/javascript" src="/services/List/ajax.js"></script>
		
		{if $pageType eq 'WishList'}

			<form id='goToList' action='/List/Results' method='GET' name='goToList'> 
			
				<div class="sort pull-right wishlist-view-dropdown">
					<div class="sortOptions">
						<label>{translate text='View Wish List'}
							<select name="goToListID" id="goToListID" onchange="this.form.submit()">
								{foreach from=$wishList item = list key=key name = loop}
									<option value="{$list.id}" {if $currentListID && $currentListID == $list.id} selected="selected"{/if}>{$list.title}
								{/foreach}
							</select>
						</label>
					</div>
				</div>

			</form>
			
			<h2 style="margin:0 0 0 0">Wish Lists</h2>
			
			<h3>{$listTitle}&nbsp;<span style="font-size: 14px;">(<span style="color:#256292;cursor: pointer;" onclick="ajaxLightbox('/List/ListEdit?id={$wishListID}&source=VuFind&lightbox&method=editList',false,false,'450px',false,'200px'); return false;">edit</span>)</span></h3>

			<div class="row list-header">
				<div class="col-xs-2 col-md-2">
					<div class="input-group show-all-button">
						<input type="button" id="show-all-button" class="btn btn-small btn-default form-control" value="Brief View" />
						<span class="input-group-addon">
							Save <input type="checkbox">
						</span>
					</div>
				</div>
				<div class="col-xs-10 col-md-10 btn-renew-all">
					<div class="wishlist-batch-actions">		
						<div class="btn-group">
							<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
								New List <span class="caret"></span>
							</button>
							<ul class="dropdown-menu" role="menu">
								<li><a class="disable-link" href="#" onclick="ajaxLightbox('/List/ListEdit?id=&amp;source=VuFind&amp;lightbox',false,false,'450px',false,'200px'); return false;">Create A New Wish List</a></li>
								<li><a class="disable-link" href="#" onclick="window.location = '/List/Import';">Import A List from Old Catalog</a></li>
							</ul>
						</div>
						
						<div class="btn-group">
							<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
								Update All <span class="caret"></span>
							</button>
							<ul class="dropdown-menu" role="menu">
								<li><a class="disable-link" href="#" onclick="saveAllToBookCart()">Move All Physical Items to Book Cart</a></li>
								<li><a class="disable-link" href="#" onclick="ajaxLightbox('/List/ListEdit?id=786&source=VuFind&lightbox&method=editList',false,false,'450px',false,'200px'); return false;">Delete This Wish List</a></li>
							</ul>			
						</div>
					</div>
				</div>
			</div>

		{/if}

		{if $pageType eq 'BookCart'}

			<h2 style="margin:0 0 0 0">Book Cart</h2>

			<div class="row">
				<div class="col-xs-12 book-cart-copy">
					<p>{if count($recordSet)>1}
						You have items in your book cart
					{elseif count($recordSet) == 1}
						You have an item in your book cart
					{else}
						Your book cart is empty
					{/if}</p>
				</div>
			</div>

			<form name='placeHoldForm' id='placeHoldForm' action="{$url}/MyResearch/HoldMultiple" method="post">

				{foreach from=$ids item=id}
					<input type="hidden" name="selected[{$id|escape:url}]" value="on" id="selected{$id|escape:url}" class="selected"/>
				{/foreach}

				{if $preferred_message != ''}
					<div class="resulthead preferred-message-container" style="margin-bottom: 25px;">
						<div class="preferred-message">
							<p>{$preferred_message}</p>
						</div>
					</div>
				{/if}

				<div class="row">
					<div class="col-xs-12">
						{if $holdDisclaimer}<p>{$holdDisclaimer}</p>{/if}

						{if (!isset($profile)) }
							<div id ='loginUsernameRow' class='loginFormRow'>
								<div class='loginLabel'>{translate text='Username'}: </div>
								<div class='loginField'><input type="text" name="username" id="username" value="{$username|escape}" size="15"/></div>
							</div>

							<div id ='loginPasswordRow' class='loginFormRow'>
								<div class='loginLabel'>{translate text='Password'}: </div>
								<div class='loginField'><input type="password" name="password" id="password" size="15"/></div>
							</div>

							<div id='loginSubmitButtonRow' class='loginFormRow'>
								<input id="loginButton" type="button" onclick="GetPreferredBranches('{$id|escape}');" value="Login"/>
							</div>
						{/if}

							{if count($recordSet)>0}
								<div class='loginFormRow'>
									<input type="hidden" name="holdType" value="hold"/>
								</div>
							{/if}
					</div>
				</div>

			</form>

			<div class="row">
				<div class="col-xs-2 col-md-2">
					<div class="input-group show-all-button">
						<input type="button" id="show-all-button" class="btn btn-small btn-default form-control" value="Brief View" />
						<span class="input-group-addon">
							Save <input type="checkbox">
						</span>
					</div>
				</div>
				<div class="col-xs-7 col-md-7 col-md-offset-1">
					{if (isset($profile)) }
						<form class="form-horizontal" role="form">
							<div class="col-xs-5 col-md-5"><label class="pull-right">Pickup Location:</label></div>
							<div class="col-xs-7 col-md-7">
								<select name="campus" class="form-control">
									{if count($pickupLocations) > 0}
										{foreach from=$pickupLocations item=location}
											<option value="{$location->code}" {if $location->selected == "selected"}selected="selected"{/if}>{$location->displayName}</option>
										{/foreach}
									{else} 
										<option>placeholder</option>
									{/if}
								</select>
							</div>
						</form>

						{if $showHoldCancelDate == 1}
							<div id='cancelHoldDate'><b>{translate text="Automatically cancel this hold if not filled by"}:</b>
								<input type="text" name="canceldate" id="canceldate" size="10">
								<br /><i>If this date is reached, the hold will automatically be cancelled for you.  This is a great way to handle time sensitive materials for term papers, etc. If not set, the cancel date will automatically be set 6 months from today.</i>
							</div>
						{/if}
					{/if}
				</div>
				<div class="col-xs-2 col-md-2">
					<button type="button" style="margin-right:20px" onclick="requestAllItems('{$wishListID}')" class="btn btn-warning pull-right" name="submit" id="requestTitleButton" {if (!isset($profile))}disabled="disabled"{/if}>{translate text='Request All'}</button>
				</div>
			</div>

		{/if}

		<div class="row">
			<div class="col-xs-6 col-md-6 col-md-offset-6">
				{if $pageLinks.all}<div class="pagination pagination-sm pull-right" style="margin-right:20px">{$pageLinks.all}</div>{/if}
			</div>
		</div>

		{if $subpage}
			{include file=$subpage}
		{else}
			{$pageContent}
		{/if}
	    
		<div class="row">
			<div class="col-xs-6 col-md-6 col-md-offset-6">
				{if $pageLinks.all}<div class="pagination pagination-sm pull-right" style="margin-right:20px">{$pageLinks.all}</div>{/if}
			</div>
		</div>

		{* End Main Listing *}
	</div>

	<div class="col-xs-3 col-md-3">
		{*right-bar template*}
		{include file="ei_tpl/right-bar.tpl"}
	</div>
</div>



