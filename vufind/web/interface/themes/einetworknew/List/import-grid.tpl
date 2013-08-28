{literal}
	<script>
		$(document).ready(function(){
   			$('tr').children().click(function(){
   				if($('input[type=checkbox]',this).size()==0){
   					$('td input[type=checkbox]', $(this).parent()).attr('checked', !$('td input[type=checkbox]', $(this).parent()).attr('checked'));
   				}
   			});
   			$('th input[type=checkbox]').click(function(){toggleAll(this)});
		});
		function toggleAll(x){
			$('td input[type=checkbox]').attr('checked', $(x).is(':checked'));
			$('th input[type=checkbox]').attr('checked', $(x).is(':checked'));
		}
	</script>
{/literal}
<div id="page-content" class="content">
	<div id="main-content" class="col-xs-9 col-md-9">
	{if $wishLists|@count lt 1}
	<div><h3>{translate text="You don't have any wish lists in the old catalog."}</h3></div>
	Search for items to add them to a new wish list.
	{else}
		<div><h2>{translate text="Import a Wish List from the Old Catalog"}</h2></div>
		<form method="post">
			<table class="table" >
					<tr>
						<th style="width:20px;"><input type = "checkbox" /></th>
						<th>Name</th>
						<th>Description</th>
						<th>Date Added</th>
					</tr>
					{*$wishLists|@print_r*}
			{foreach from=$wishLists item=list}
					<tr class="{cycle values="evenrow,oddrow"}">
						<td style="padding-left: 15px;"><input type = "checkbox" value="{$list.id}" name="wishlists[]"/></td>
						<td>{$list.title}</td>
						<td>{$list.description}</td>
						<td >{$list.date}</td>
					</tr>
			{/foreach}
			</table>
			<input type="submit" name="submit" value="Import" class="btn btn-warning" />&nbsp;<input type='button' onclick="window.location.href='/List/Results'" value='Cancel' class="btn btn-warning"/>
		</form>
	{/if}
	</div>

	<div class="col-xs-3 col-md-3">
		{*right-bar template*}
		{include file="ei_tpl/right-bar.tpl"}
	</div>
</div>