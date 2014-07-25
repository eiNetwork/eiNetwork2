$( document ).ready(function() {

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
	        text: 'Limits to items that were available at the time of the last nightly update. <a href="">Read More....</a>'
	    },
	    hide: {
	        delay: 2000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-available_at').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Click on a <span class="bold">Location</span> below to limit your search results to the holdings of the selected library.'
	    },
	    hide: {
	        delay: 2000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-building').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Click on a <span class="bold">Location</span> below to limit your search results to the holdings of the selected library.'
	    },
	    hide: {
	        delay: 2000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-format').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Material Type(s)</span>, click on those you wish to include.  For example, DVD and Book on CD.  Click See All to view all available material types.'
	    },
	    hide: {
	        delay: 2000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-target_audience_full').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Age Group</span>, click on one of the four options below.'
	    },
	    hide: {
	        delay: 2000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-literary_form_full').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Literary Form</span>, click on an option below.'
	    },
	    hide: {
	        delay: 2000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-topic_facet').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Subject</span>, click on an option below.'
	    },
	    hide: {
	        delay: 2000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-authorStr').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Author</span>, click on an author’s name in the list below.'
	    },
	    hide: {
	        delay: 2000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

	$('.qtip-language').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'To limit your search by <span class="bold">Language</span>, click on an available language option in the list below.'
	    },
	    hide: {
	        delay: 2000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})

});