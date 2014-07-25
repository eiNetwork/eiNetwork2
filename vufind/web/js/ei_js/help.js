$( document ).ready(function() {

	$("#dialog").dialog({
			autoOpen: false,
		modal: true,
		width: 620,
		height: 520,
	});

	$('#qtip-link-available_at').live('click', function(e){
	    e.preventDefault();
		$("#dialog").html("");
		$("#dialog").dialog("option", "title", "Loading...").dialog("open");
		$("#dialog").load(this.href, function() {
			$(this).dialog("option", "title", $(this).find("h1").text());
			$(this).find("h1").remove();
		});
	});

	$('#qtip-link-building').live('click', function(e){
	    e.preventDefault();
	    $("#dialog").html("");
		$("#dialog").dialog("option", "title", "Loading...").dialog("open");
		$("#dialog").load(this.href, function() {
			$(this).dialog("option", "title", $(this).find("h1").text());
			$(this).find("h1").remove();
		});
	});

	$('#qtip-link-target_audience_full').live('click', function(e){
	    e.preventDefault();
	    $("#dialog").html("");
		$("#dialog").dialog("option", "title", "Loading...").dialog("open");
		$("#dialog").load(this.href, function() {
			$(this).dialog("option", "title", $(this).find("h1").text());
			$(this).find("h1").remove();
		});
	});

	$('#qtip-link-literary_form_full').live('click', function(e){
	    e.preventDefault();
	    $("#dialog").html("");
		$("#dialog").dialog("option", "title", "Loading...").dialog("open");
		$("#dialog").load(this.href, function() {
			$(this).dialog("option", "title", $(this).find("h1").text());
			$(this).find("h1").remove();
		});
	});

	$('#qtip-link-topic_facet').live('click', function(e){
	    e.preventDefault();
	    $("#dialog").html("");
		$("#dialog").dialog("option", "title", "Loading...").dialog("open");
		$("#dialog").load(this.href, function() {
			$(this).dialog("option", "title", $(this).find("h1").text());
			$(this).find("h1").remove();
		});
	});

	$('#qtip-link-authorStr').live('click', function(e){
	    e.preventDefault();
	    $("#dialog").html("");
		$("#dialog").dialog("option", "title", "Loading...").dialog("open");
		$("#dialog").load(this.href, function() {
			$(this).dialog("option", "title", $(this).find("h1").text());
			$(this).find("h1").remove();
		});
	});
	
	$('#qtip-link-language').live('click', function(e){
	    e.preventDefault();
	    $("#dialog").html("");
		$("#dialog").dialog("option", "title", "Loading...").dialog("open");
		$("#dialog").load(this.href, function() {
			$(this).dialog("option", "title", $(this).find("h1").text());
			$(this).find("h1").remove();
		});
	});

	$('.qtip-retain-filters').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Need Copy'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-limit-avail').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Limits to items that were available at the time of the last nightly update.'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})
	$('.qtip-sort-by').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Orders your search results by Relevance, Newest or Oldest publication year first, Title, or Author.'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-sort-by-checked').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Orders your checked out items by Title, Author, or Format'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})
	
	$('.qtip-sort-by-request').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Orders your requests by by Title, Author, Format, Pickup Location, or Status'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-sort-by-history').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Orders your reading history by Checkout Date, Title, or Author'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})
	
	$('.qtip-available_at').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Click on a <span class="bold">Location</span> below to limit your search results to the holdings of the selected library. <a id="qtip-link-available_at" href="/Help/Home?topic=helppage#Location">Read More...</a>'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})
	$('.qtip-book-cart').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Adding items to your Book Cart allows you to save them for later and place multiple requests at one time. '
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-building').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Click on a <span class="bold">Location</span> below to limit your search results to the holdings of the selected library. <a id="qtip-link-building" href="/Help/Home?topic=helppage#Location">Read More...</a>'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-format').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Material Type(s)</span>, click on those you wish to include.  For example, DVD and Book on CD.  Click "See All" to view all available material types.'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-target_audience_full').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Age Group</span>, click on one of the four options below. <a id="qtip-link-target_audience_full" href="/Help/Home?topic=helppage#AgeGroup">Read More...</a>'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-literary_form_full').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Literary Form</span>, click on an option below. <a id="qtip-link-literary_form_full" href="/Help/Home?topic=helppage#LiteraryForm">Read More...</a>'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-topic_facet').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Subject</span>, click on an option below. <a id="qtip-link-topic_facet" href="/Help/Home?topic=helppage#Subject">Read More...</a>'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})    

	$('.qtip-preferred-libs').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Specifying Preferred Libraries sets your default pickup location for items requested online.'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-authorStr').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Author</span>, click on an author’s name in the list below. <a id="qtip-link-authorStr" href="/Help/Home?topic=helppage#Author">Read More...</a>'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})
	$('.qtip-checked-out').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'From your Checked Out Items page you can renew items and review due dates.  '
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-language').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Language</span>, click on an available language option in the list below. <a id="qtip-link-language" href="/Help/Home?topic=helppage#Language">Read More...</a>'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})
	
	$('.qtip-email').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'If your notification preference is email, you will receive email notices at this address for upcoming due date, hold pickups, and overdue items.  Please make sure your spam filtering allows email from librarycatalog@einetwork.net'
	    },
	    hide: {
	        delay: 1000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})
});