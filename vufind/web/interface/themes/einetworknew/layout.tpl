<!DOCTYPE html>
<html lang="{$userLang}">{strip}
<head>
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=9" />
	<title>{$pageTitle|truncate:64:"..."}</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

	<!-- Start Bootstrap CSS and JS -->
	<link rel="stylesheet" href="/js/bootstrap/css/bootstrap.min.css" type="text/css" />
	<script type="text/javascript" src="/js/bootstrap/js/bootstrap.min.js"></script>
	<!-- End Bootstrap CSS and JS -->

    <link rel="search" type="application/opensearchdescription+xml" title="Library Catalog Search" href="{$url}/Search/OpenSearch?method=describe" />
      
	{css filename="jqueryui.css"}
	<link rel="stylesheet" href="/interface/themes/einetworknew/css/style.css" type="text/css" media="screen" />
		
	<link rel="stylesheet" href="/interface/themes/einetwork/css/SliderThemes/default/default.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="/interface/themes/einetwork/css/SliderThemes/light/light.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="/interface/themes/einetwork/css/SliderThemes/dark/dark.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="/interface/themes/einetwork/css/SliderThemes/bar/bar.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="/interface/themes/einetwork/css/SliderThemes/nivo-slider.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="/interface/themes/einetwork/css/SliderThemes/slider-style.css" type="text/css" media="screen" />
	    
	<script type="text/javascript">
		path = '{$path}';
		loggedIn = {if $user}true{else}false{/if};
	</script>
	    
	{if $consolidateJs}
		
	{else}
		<script type="text/javascript" src="{$path}/js/scripts.js?v2.1"></script>
		<script type="text/javascript" src="{$path}/js/tablesorter/jquery.tablesorter.min.js"></script>
		<script type="text/javascript" src="{$path}/js/ei_js/page.js?v2.1"></script>
		{if $enableBookCart}
		<script type="text/javascript" src="{$path}/js/bookcart/json2.js"></script>
		<script type="text/javascript" src="{$path}/js/bookcart/bookcart.js"></script>
		{/if}

		{* Code for description pop-up and other tooltips.*}
		<script type="text/javascript" src="{$path}/js/title-scroller.js"></script>
		<script type="text/javascript" src="{$path}/services/Search/ajax.js?v2.1"></script>
		<script type="text/javascript" src="{$path}/services/Record/ajax.js?v2.1"></script>
		<script type="text/javascript" src="{$path}/js/ei_js/bookcart.js?v2.1"></script>  
		<script type="text/javascript" src="{$path}/js/overdrive.js?v2.1"></script>
	{/if}
	    
	{* Files that should not be combined *}
	{if $includeAutoLogoutCode == true && $user}
		<script type="text/javascript" src="{$path}/js/autoLogout.js"></script>
	{/if}
	    
	{if isset($theme_css)}
	    <link rel="stylesheet" type="text/css" href="{$theme_css}" />
	{/if}

</head>
 
<body>

	<div class="modal fade" id="eiNetworkModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title">title</h4>
				</div>
				<div class="modal-body">
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->

	{*google analytics*}

	{literal}
	<script type="text/javascript">

	 var _gaq = _gaq || [];
	 _gaq.push(['_setAccount', 'UA-39529152-1']);
	 _gaq.push(['_trackPageview']);

	 (function() {
	   var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	   ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	   var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
	 })();

	</script>
	{/literal}

	{php} if (strpos($_SERVER["REQUEST_URI"],'Union/Search') !== false){ {/php}

	<div class="header-back header-back-search"></div>

	{php} } else { {/php}

	<div class="header-back"></div>

	{php} } {/php}

	<div id="wrap">

		<div class="container">

			<div class="row header">
				<div class="col-xs-2 col-md-2" style="text-align:center">
					<a class="btn btn-warning survey-btn pull-left" href="http://www.surveymonkey.com/s/NewLibraryCatalog" target="_blank">A Quick Survey</a>
				</div>
				<div class="col-xs-10 col-md-10" style="text-align:center">
					<div class="row">
						<form method="get" action="/Union/Search" id="searchForm" class="form-inline" onsubmit='startSearch();'>
							<div class="col-xs-3 col-md-3">
								<div class="input-group">
									<span class="input-group-addon invert-label">Search</span>
									<select name="basicType" class="form-control">
										{foreach from=$basicSearchTypes item=searchDesc key=searchVal}
											<option value="{$searchVal}"{if $searchIndex == $searchVal} selected="selected"{/if}>
											{translate text=$searchDesc}
											</option>
										{/foreach}
									</select>
								</div><!-- /input-group -->
							</div>
							<div class="{if $user}col-xs-6 col-md-6{else}col-xs-7 col-md-7{/if}">
								<div class="input-group">
									<span class="input-group-addon invert-label">for</span>
									<input type="text" class="form-control" name="lookfor" style="border-right:solid #fff 1px;">
									<span class="input-group-btn">
										<input type="submit" class="btn btn-primary" style="border:solid #fff 1px;" type="button" value="Go!">
									</span>
								</div><!-- /input-group -->
							</div>
							<div class="{if $user}col-xs-3 col-md-3{else}col-xs-2 col-md-2{/if}" style="text-align:center">
								<div class="row">

									{if $user}

										<div class="col-xs-6 col-md-6 welcome-user">
												<p>Welcome</p>
												<a href="{$path}/MyResearch/Profile">
											        {if strlen($user->displayName) > 0}{$user->displayName}
											        {else}{*{$user->lastname|capitalize}*}{$user->firstname|capitalize}
											        {/if}
										        </a>
										</div>
										<div class="col-xs-6 col-md-6">
											<a class="btn btn-default pull-right" href="{$path}/MyResearch/Logout">{translate text="Sign Out"}</a>
										</div>

									{else}

										<div class="col-xs-12 col-md-12">
											<a class="btn btn-default pull-right" href="{$path}/MyResearch/Home">{translate text="My Account"}</a>
										</div>

									{/if}

								</div>
								
							</div>
						</form>
					</div>
				</div>

			</div>
			<div class="row">
				<div class="col-xs-2 col-md-2 col-md-offset-5 retain-filters">
					{* Do we have any checkbox filters? *}

					  {assign var="hasCheckboxFilters" value="0"}

					  {if isset($checkboxFilters) && count($checkboxFilters) > 0}
					    {foreach from=$checkboxFilters item=current}
					      {if $current.selected}
								{assign var="hasCheckboxFilters" value="1"}
					      {/if}
					    {/foreach}
					  {/if}

					  {if $filterList || $hasCheckboxFilters}
					      <input type="checkbox" checked="checked" onclick="filterAll(this);" /> {translate text="basic_search_keep_filters"}
					  {/if}
					    
				</div>
				<div class="col-xs-3 col-md-3 retain-filters">
					{php}

				      if (strpos($_SERVER['REQUEST_URI'], 'Union/Search', 0) > 0){
				        echo '<div class="availFilter"><input name="limit_avail" id="limitToAvail" type="checkbox"> Limit to available</div>';
				      }

				    {/php}
				</div>
			</div>

		</div>


		<div class="container">

			<div class="row main-page {php} if (strpos($_SERVER['REQUEST_URI'],'Union/Search') !== false){ {/php}main-page-search{php} } {/php}">
				<div class="col-xs-12 col-md-12">
					{include file="$module/$pageTemplate"}
				</div>
			</div>

		</div>

		{include file="ei_tpl/footer.tpl"}

	</div>


	{if $strandsAPID}
		{literal}
			<!-- Strands Library MUST be included at the end of the HTML Document, before the /body closing tag and JUST ONCE -->
			<script type="text/javascript" src="http://bizsolutions.strands.com/sbsstatic/js/sbsLib-1.0.min.js"></script>
			<script type="text/javascript">
				try{ SBS.Worker.go("vFR4kNOW4b"); } catch (e){};
			</script>
		{/literal}
	{/if}
	
</body>
</html>{/strip}