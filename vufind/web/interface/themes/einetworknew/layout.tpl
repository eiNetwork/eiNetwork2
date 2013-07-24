<!DOCTYPE html>
<html lang="{$userLang}">{strip}
<head>
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=9" />
	<title>{$pageTitle|truncate:64:"..."}</title>

	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>

	<!-- Start Bootstrap CSS and JS -->
	<link rel="stylesheet" href="/js/bootstrap/css/bootstrap.min.css" type="text/css" />
	<link rel="stylesheet" href="/js/bootstrap/css/bootstrap-responsive.min.css" type="text/css" />

	<script type="text/javascript" src="/js/bootstrap/js/bootstrap.min.js"></script>
	<!-- End Bootstrap CSS and JS -->

	{css filename="sticky_footer.css"}

    <link rel="search" type="application/opensearchdescription+xml" title="Library Catalog Search" href="{$url}/Search/OpenSearch?method=describe" />
      
	{css filename="jqueryui.css"}
	<link rel="stylesheet" href="/interface/themes/einetworknew/css/style.css" type="text/css" media="screen" />
	{css filename="basicHtml.css"}
	{css filename="top-menu.css"}
	{css filename="ei_css/Record/record.css"}
	<link rel="stylesheet" href="/interface/themes/einetwork/css/ei_css/holdingsSummary.css?v2.1" type="text/css" media="screen" />
	{css filename="/ei_css/center-header.css"}
	{css filename="/ei_css/right-header.css"}
	{css filename="/ei_css/right-bar.css"}
	{*css filename="/ei_css/popup.css"*}
	{css filename="/ei_css/footer.css"}
	{css filename="/ei_css/login.css"}
	{css filename="/ei_css/get-card.css"}
	{css filename="my-account.css"}
	{css filename="ratings.css"}
	{css filename="book-bag.css"}
	{css filename="jquery.tooltip.css"}
	{css filename="tooltip.css"}
	{css filename="suggestions.css"}
	{css filename="reports.css"}
	{css filename="dcl.css"}
		
	{css media="print" filename="print.css"}
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
		<script type="text/javascript" src="{$path}/API/ConsolidatedJs"></script>
	{else}
		<script type="text/javascript" src="{$path}/js/jqueryui/jquery-ui-1.8.18.custom.min.js"></script>
		<script type="text/javascript" src="{$path}/js/jquery.plugins.js"></script>
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
	{if $includeAutoLogoutCode == true }
		<script type="text/javascript" src="{$path}/js/autoLogout.js"></script>
	{/if}
	    
	{if isset($theme_css)}
	    <link rel="stylesheet" type="text/css" href="{$theme_css}" />
	{/if}

</head>
 
<body>

	{*google analytics*}

	<div>
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
    </div>

<div class="header-back"></div>

<div class="wrapper">

		<div class="container-fluid">

			<div class="row-fluid header">
					<div class="span2">
						<a class="btn btn-warning survey-btn" href="">A Quick Survey</a>
					</div>
					<div class="span8 search-box">
						<form method="get" action="/Union/Search" id="searchForm" class="form-inline" onsubmit='startSearch();'>
							<label for="basicType">Search</label>
								<select name="basicType">
									{foreach from=$basicSearchTypes item=searchDesc key=searchVal}
										<option value="{$searchVal}"{if $searchIndex == $searchVal} selected="selected"{/if}>
										{translate text=$searchDesc}
										</option>
									{/foreach}
								</select>
							<label for="search">for</label>
							<input type="text" class="search-txt" name="lookfor">
							<input type="submit" class="btn btn-small search-button" value="Go" />
						</form>
					</div>
					<div class="span2">
						<a class="btn survey-btn" href="">My Account</a>
					</div>
			</div>

			<div class="row-fluid">
				<div class="span12">
					{include file="$module/$pageTemplate"}
				</div>
			</div>

		</div>

		<div class="push"></div>

</div>


{include file="ei_tpl/footer.tpl"}

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