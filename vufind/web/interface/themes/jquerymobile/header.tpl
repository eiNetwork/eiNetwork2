<div data-role="header" data-theme="a">
  <div><h1 style="text-align: center;font-size: inherit">{$pageTitle|trim:':/'|escape}</h1></div>
 
  {if $mainAuthor}
  <h2>{$mainAuthor}</h2>
  {else if $corporateAuthor}
  <h2>{$corporateAuthor}</h2>
  {/if}
    <div class="survey" style="width:100%">
      	<div  onclick='window.location.href="http://www.surveymonkey.com/s/NewLibraryCatalog"' >
	     <p style="margin-bottom:10px;vertical-align:middle;text-align: center"><span style="vertical-align:middle">A Quick Survey</span></p>
	</div>	
    </div>
  {* display the search button everywhere except /Search/Home *}
  {if !($module == 'Search' && $pageTemplate == 'home.tpl') }
    <a rel="external" href="{$path}/Search/Home" data-icon="search"  class="ui-btn-right">
    {translate text="Search"}
    </a>
  {/if}
  {* if a module has header-navbar.tpl, then use it *}
  {assign var=header_navbar value="$module/header-navbar.tpl"|template_full_path}
  {if !empty($header_navbar)}
    {include file=$header_navbar}
  {/if}
</div>
