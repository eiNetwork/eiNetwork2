<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html lang="{$userLang}">
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
  {css filename="styles.css"}
  {css filename="basicHtml.css"}
  <link rel="stylesheet" href="{$path}/js/jqueryui/flick/jquery-ui-1.8.8.custom.css" type="text/css" >
  
  <script type="text/javascript">
    path = '{$path}';
  </script>
    
  {* Link in jquery first *}
  <script type="text/javascript" src="{$path}/js/jquery-1.4.4.min.js"></script>
  <script type="text/javascript" src="{$path}/js/jqueryui/jquery-ui-1.8.8.custom.min.js"></script>
  
  {css filename="title-scroller.css"}
  {css filename="jquery.tooltip.css"}
  {css filename="tooltip.css"}
  <script type="text/javascript" src="{$path}/js/jquery.waitforimages.js"></script>
  
  {* Code for description pop-up and other tooltips.*}
  <script type="text/javascript" src="{$path}/js/description.js"></script>
  <script type="text/javascript" src="{$path}/js/tooltip/lib/jquery.bgiframe.js"></script>
  <script type="text/javascript" src="{$path}/js/tooltip/jquery.tooltip.js"></script>
      
  <script type="text/javascript" src="{$path}/js/title-scroller.js"></script>
  {if $widget->customCss}
  	<link rel="stylesheet" type="text/css" href="{$widget->customCss}" />
  {/if}
  
  <base target="_parent">
</head>

<body>
  {include file='API/listWidgetTabs.tpl'}
  
</body>
</html>