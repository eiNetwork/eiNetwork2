{literal}
<script type="text/javascript">

	$(document).ready(function() {

		$('#placeHoldForm').submit(function(){

			if ($('#campus').val() == ''){
				alert('Please select a pickup location.');
				return false;
			}

		})

	});

</script>
{/literal}
<script type="text/javascript" src="{$path}/services/EcontentRecord/ajax.js"></script>

{* Main Listing *}

<div id="page-content" class="row">

  <div id="main-content" class="col-xs-9 col-md-9">
	<input type="hidden" value="{$wishListID}" id="listId"/>
	<script type="text/javascript" src="/services/List/ajax.js"></script>
	{if $pageType eq 'WishList'}

		<div>
		<form id='goToList' action='/List/Results' method='GET' name='goToList'> 
		<div class="sort pull-right">
			<div class="sortOptions">
				<label>{translate text='View Wish List'}
					<select name="goToListID" id="goToListID" onchange="this.form.submit()"">
						{foreach from=$wishList item = list key=key name = loop}
							<option value="{$list.id}" {if $currentListID && $currentListID == $list.id} selected="selected"{/if}>{$list.title}
						{/foreach}
					</select>
				</label>
			</div>
		</div>
		</form>

		<h2>Wish Lists</h2>
		</div>
		
		<div>
		<div class="pull-right">		
			<div class="btn-group">
				<button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
					New List <span class="caret"></span>
				</button>
				<ul class="dropdown-menu">
<!--					<li><a href="#" id="createWishList" onclick="ajaxLightbox('/List/ListEdit?id=&amp;source=VuFind&amp;lightbox',false,false,'450px',false,'200px');return false;">Create A New Wish List</a></li>
-->					<li><a href="#" id="createWishList" onclick="return false">Create A New Wish List</a></li>
					<li><a href="/List/Import">Import A List from Old Catalog</a></li>
				</ul>
			</div>
			
			<div class="btn-group">
				<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
					Update All <span class="caret"></span>
				</button>
				<ul class="dropdown-menu" role="menu">
					<li><a href="#" id="moveToBookCart" onclick="saveAllToBookCart(); return false;">Move All Physical Items to Book Cart</a></li>
					<li><a href="#" id="deleteWishList" onclick="getDeleteList('{$wishListID}');return false;">Delete This Wish List</a></li>
				</ul>			
			</div>
			<clear />
		</div>

		<h1><span id="wishTitle" class="pull-left"><h3>{$listTitle}</h3></span>&nbsp;<span style="font-size: 14px;">(<span style="color:#256292;cursor: pointer;" onclick="ajaxLightbox('/List/ListEdit?id={$wishListID}&source=VuFind&lightbox&method=editList',false,false,'450px',false,'200px'); return false;">edit</span>)</span></h1>

		<div class=clearfix></div>
		<div>{if $pageLinks.all}<div class="pagination pull-right">{$pageLinks.all}</div>{/if}</div>			
		<div class=clearfix></div>
		<hr />		
		</div>
		
	{/if}

	{if $pageType eq 'BookCart'}
		<div class="resulthead">
			<h2>
			{if count($recordSet)>1}
				Items in your book cart
			{elseif count($recordSet) == 1}
				Item in your book cart
			{else}
				Your book cart is empty
			{/if}
			</h2>
		</div>
	{/if}
	
	
	{if $preferred_message != ''}
		<div class="resulthead preferred-message-container" style="margin-bottom: 25px;">
			<div class="preferred-message">
				<p>{$preferred_message}</p>
			</div>
		</div>
	{/if}

	<div id="searchInfo">
	
		{if $pageType eq 'BookCart'}
			<form name='placeHoldForm' id='placeHoldForm' action="{$url}/MyResearch/HoldMultiple" method="post">
				<div>
			
					<div id="loginFormWrapper">
						{foreach from=$ids item=id}
							<input type="hidden" name="selected[{$id|escape:url}]" value="on" id="selected{$id|escape:url}" class="selected"/>
						{/foreach}
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

						<div id='holdOptions' {if (!isset($profile)) }style='display:none'{/if}>
							<div >
								<div style="margin-top:15px;padding-left:5px;text-align: left;margin-bottom:15px"> <span style="margin-right:15px;font-size:15px">{translate text="Pickup Location"}: </span>
										<select name="campus" id="campus" style="width:260px">
										{if $preferred_count < 1}
											<option value=""></option>
										{/if}
										{if count($pickupLocations) > 0}
											{foreach from=$pickupLocations item=location}
												<option value="{$location->code}" {if $location->selected == "selected"}selected="selected"{/if}>{$location->displayName}</option>
											{/foreach}
										{else} 
											<option>placeholder</option>
										{/if}
										</select>
									<span>
										<input type="button" onclick="requestAllItems('{$wishListID}')" class="btn btn-warning" style="margin-top: 0px;float:right;width:130px;" name="submit" id="requestTitleButton" value="{translate text='Request All'}" {if (!isset($profile))}disabled="disabled"{/if}/>
									</span>
								</div>
							</div>

							<div class=clearfix></div>
							<div>{if $pageLinks.all}<div class="pagination pull-right">{$pageLinks.all}</div>{/if}</div>			
							<div class=clearfix></div>
							<hr />

							{if count($recordSet)>0}
								<div class='loginFormRow'>
									<input type="hidden" name="holdType" value="hold"/>
								</div>
							{/if}
						</div>
					</div>
				</div>
			</form>
		{/if}

		{if $subpage}
			{include file=$subpage}
		{else}
			{$pageContent}
		{/if}
        
		{if $pageLinks.all}<div class="pagination pull-right">{$pageLinks.all}</div>{/if}
		<b class="bbot"><b></b></b>
	</div>
    {* End Main Listing *}
  </div>

  <div class="col-xs-3 col-md-3">
	{*right-bar template*}
	{include file="ei_tpl/right-bar.tpl"}
  </div>
</div>



