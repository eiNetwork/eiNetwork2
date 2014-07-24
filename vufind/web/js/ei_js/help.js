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

});