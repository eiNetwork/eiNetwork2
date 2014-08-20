{literal}
<script type="text/javascript">

$(document).ready(function() {

	$('.location1').qtip({
	    content: {
	        text: 'Click on the library locations below to limit your search results to the holdings of the selected locations'
	    },
	    style: 'tooltip',
	    classes: {
		content:'eintooltip'
	    }
	    
	});

});

$(document).ready(function() {

	$('.remove1').qtip({
	    content: {
	        text: 'Click on the red icon to remove the filter.'
	    },
	    style: 'tooltip'
	});

});

$(document).ready(function() {

	$('.remove2').qtip({
	    content: {
	        text: 'Click here to remove all fitlers'
	    },
	    style: 'tooltip'
	});

});
$(document).ready(function() {

	$('.mat1').qtip({
	    content: {
	        text: 'Click on the material type below to limit your search results to the selected material types.  For example DVD.  Clicks see all to see all available material types.'
	    },
	    style: 'tooltip'
	});

});

$(document).ready(function() {

	$('.age1').qtip({
	    content: {
	        text: 'Click on one of the four age groups below to limit your search results to only that age group.'
	    },
	    style: 'tooltip'
	});

});

$(document).ready(function() {

	$('.liter1').qtip({
	    content: {
	        text: 'Click on a literary form to limit your search results to the available literary form.  Available Literary forms change based on the search term used.'
	    },
	    style: 'tooltip'
	});

});

$(document).ready(function() {

	$('.subject1').qtip({
	    content: {
	        text: 'Click on a subject to limit your search results to the available subjects.  Available subjects change based on the search term used.'
	    },
	    style: 'tooltip'
	});

});

$(document).ready(function() {

	$('.author1').qtip({
	    content: {
	        text: 'Click on an author to limit your search results to the available authors based on your search term.'
	    },
	    style: 'tooltip'
	});

});

$(document).ready(function() {

	$('.language1').qtip({
	    content: {
	        text: 'Click on a language to limit your search results to the available language.  Available languages change based on the search term used.'
	    },
	    style: 'tooltip'
	});

});
</script>
{/literal}

<div id="page-content" class="content">
    <div id="left-bar">&nbsp;</div>
    <div id="main-content">
        <h1>Facets Demo</h1>
        <br>
<h3><font class="remove1">Remove Filters  </font><a href="/MyResearch/einfacets" class="remove1"><img src="/images/help_icon.png"></a></h3>
    Location: CLP - Main Library<br>
    <font class="remove2">remove all filters</font><br>


<h3><font class="location1">Location  </font><a href="/MyResearch/einfacets" class="location1"><img src="/images/help_icon.png"></a></h3>
    CLP - Main Library	(3888) <br>
    Digital Collection	(1521) <br>
    more ... <br>
    
<h3><font class="mat1">Material Type  </font><a href="/MyResearch/einfacets"><img src="/images/help_icon.png"></a></h3>
    Print Book	(7917) <br>
    Music CD	(926) <br>
    DVD	(910) <br>
    EPUB eBook	(909) <br>
    OverDrive Read	(897) <br>

    See All ... <br>

<h3><font class="age1">Age Group  </font><a href="/MyResearch/einfacets"><img src="/images/help_icon.png"></a></h3>
    General Interest	(5799) <br>
    Children	(5242) <br>
    Pre-Teen	(552) <br>
    Adult	(140) <br>

<h3><font class="liter1">Literary Form  </font><a href="/MyResearch/einfacets"><img src="/images/help_icon.png"></a></h3>
    Fiction	(4823) <br>
    Non Fiction	(3121) <br>
    Short Stories	(35) <br>
    Poetry	(12) <br>
    Mixed Forms	(4) <br>
    more ... <br>

<h3><font class="subject1">Subject </font><a href="/MyResearch/einfacets"><img src="/images/help_icon.png"></a></h3>
    Cats	(5031) <br>
    Dogs	(675) <br>
    Animals	(621) <br>
    Fiction	(523) <br>
    Stories in rhyme	(373) <br>
    more ... <br>

<h3><font class="author1">Author </font><a href="/MyResearch/einfacets"><img src="/images/help_icon.png"></a></h3>
    Adamson, Lydia	(24) <br>
    Alderton, David, 1956-	(12) <br>
    Alexander McCall Smith	(9) <br>
    Alexander, Lloyd	(16) <br>
    Amory, Cleveland	(9) <br>
    more ... 

<h3><font class="language1">Language </font><a href="/MyResearch/einfacets"><img src="/images/help_icon.png"></a></h3>
    English	(12330) <br>
    Spanish	(275) <br>
    French	(221) <br>
    Music	(170) <br>
    Japanese	(38) <br>
    more ... <br>
 
    </div>
    <div id="right-bar">
    {include file="MyResearch/menu.tpl"}
    {include file="Admin/menu.tpl"}
    </div>
</div>