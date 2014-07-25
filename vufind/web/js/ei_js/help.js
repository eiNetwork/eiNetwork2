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
	$('.qtip-sort-by').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Orders your search results by Relevance, Newest or Oldest publication year first, Title, or Author.'
	    },
	    hide: {
	        delay: 2000
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
	        delay: 2000
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
	        delay: 2000
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
	$('.qtip-book-cart').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Adding items to your Book Cart allows you to save them for later and place multiple requests at one time. '
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

	$('.qtip-preferred-libs').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'Specifying Preferred Libraries sets your default pickup location for items requested online.'
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
	$('.qtip-checked-out').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'From your Checked Out Items page you can renew items and review due dates.  '
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
	
	$('.qtip-email').qtip({ // Grab some elements to apply the tooltip to
	    content: {
	        text: 'If yout notification preference is email, you will receive email notices at this address for upcoming due date, hold pickups, and overdue items.  Please make sure your spam filtering allows email from librarycatalog@einetwork.net'
	    },
	    hide: {
	        delay: 2000
	    },
	    style: {
	        classes: 'qtip-rounded'
	    }
	})
});