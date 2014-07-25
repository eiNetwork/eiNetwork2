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

	
});