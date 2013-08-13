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
	{if $includeAutoLogoutCode == true }
		<script type="text/javascript" src="{$path}/js/autoLogout.js"></script>
	{/if}
	    
	{if isset($theme_css)}
	    <link rel="stylesheet" type="text/css" href="{$theme_css}" />
	{/if}

</head>
 
<body>

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

	<div class="header-back"></div>  

	<div id="wrap">

		<div class="container">

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

			<div class="row header">
				<div class="col-lg-2" style="text-align:center">
					<a class="btn btn-warning survey-btn" href="">A Quick Survey</a>
				</div>

				<form method="get" action="/Union/Search" id="searchForm" class="form-inline" onsubmit='startSearch();'>
					<div class="col-lg-3">
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
					<div class="col-lg-5">
						<div class="input-group">
							<span class="input-group-addon invert-label">for</span>
							<input type="text" class="form-control" name="lookfor">
							<span class="input-group-btn">
								<input type="submit" class="btn btn-info" type="button" value="Go!">
							</span>
						</div><!-- /input-group -->
					</div>
				</form>

				<div class="col-lg-2" style="text-align:center">
					<a class="btn btn-default" href="/MyResearch/Home">My Account</a>
				</div>
			</div>

		</div>


		<div class="container">

			<div class="row main-page">
				<div class="col-lg-12">
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