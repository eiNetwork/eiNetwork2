{if $notifications.count > 0}
{literal}
<script type="text/javascript" src="/js/right-bar.js"></script>
<script type="text/javascript">

	var user_id = {/literal}{$user->id}{literal}

	$(document).ready(function(){

		{/literal}{if $notifications.state == 0}{literal}
			var t=setTimeout(function(){$('.notification-center').show('fast'{/literal}{if $notificationCenterAlert}{literal}, function () {flashNotificationCenter({r:255, g:0, b:0},150);}{/literal}{/if}{literal});},2000)
		{/literal}{/if}{literal}

		$('#notification-center-link').click(function(){
			$('.notification-center').show('fast');
		})

		$('.notification-center button').click(function(){

			// save popup state in session.

			var url = path + "/MyResearch/AJAX?method=saveNotificationPopupState"
			$.ajax( {
				url : url,
				data : {user_id: user_id},
				dataType : 'text',
				type : 'post'
			});

			$('.notification-center').hide('slow');
		})
	});

</script>
{/literal}
{/if}
{strip}
<div id="right-bar">

	{if $user}
	<div>
		<div class="notification-center-container">
			<img src="/interface/themes/einetwork/images/inbox.png" /> <a id="notification-center-link" class="disable-link" href="">Notification Center</a> <span style="color:#f00;font-size:0.95em">({$notifications.count})</span>
			<div class="row">
				<div class="col-xs-12 col-md-12 notification-center clearfix">
					<p class="notification-arrow-up notification-center-footer"></p>

					<button type="button" class="notification-center-close" title="Close notification center"></button>

					{assign var="x" value=0}

					{foreach from=$notifications.messages item="message"}

					{assign var="x" value=$x+1}

					<p class="notification-center-message{if $x eq $notifications.count} notification-center-footer{/if}">{$message}</p>

					{/foreach}

					<div style="clear: both"></div>
				</div>
			</div>
		</div>
	</div>
	{/if}

    <div class="bookcart">
        <div id="cart-image">
            <img src="/interface/themes/einetwork/images/shopping_cart.png"  alt="cart" style="vertical-align:middle;margin-left:2px"/>
            <span id="cart-description" style="vertical-align:middle"></span>
        </div>

        <input type="button" class="button" id="view_cart_button" onclick="getViewCart()" value="View Cart"><span><img class="qtip-book-cart help-icon" src="/images/help_icon.png" /></span>
    </div>
    <div id="blank">&nbsp;</div>  
    <div class="separator"><hr/></div>
    
    <div class="account-links">
        <div id="wish-lists">
            <a onclick='getWishList()'>My Lists</a>
        </div>
	 <div id="my-item">
            <a onclick='getCheckedOutItem()'>View &amp; Renew Items <span id="my-item-PlaceHolder"></span></a><span><img class="qtip-checked-out help-icon" style="vertical-align:middle" src="/images/help_icon.png" /></span>
        </div>
	<div id="my-request">
          <a onclick='getRequestedItem()' >View &amp; Update Requests<span id="my-ruest-item-placeHolder"></span></a>
	</div>
	<div id="reading-history">
            <a onclick='getReadingHistory()' >Reading History</a>
        </div>
        <div id="history">
            <a href="/Search/History">Save Searches</a>
        </div>
        <div id="account-settings">
            <a onclick='getAccountSetting()'>Update Profile</a>
        </div>
	<div id="latest-updates">
            <a class="new_updates" href="/MyResearch/Latestupdates">Latest Website Updates</a>
        </div>
	<div id="latest-updates">
            <a id="help-contents-link" href="/Help/Home?topic=contents">Catalog Help</a>
        </div>
	<div id="text-notices">
            <a class="new_updates" href="/MyResearch/SMShelp">Text Notices Help</a><span><img class="qtip-sms-help help-icon" style="vertical-align:middle" src="/images/help_icon.png" /></span>
        </div>
	
    </div>
    {literal}
    <br>
    <br>
    <br>
    <br>
    <br>
    <br>
	<script type="text/javascript">
	    $("#my-item-PlaceHolder").ready(function(){
		$.getJSON(path + '/MyResearch/AJAX?method=getAllItems', function (data){
		    if (data.error){
		    }else{
			if(data.SumOfCheckoutItems != 0){
			    $("#my-item-PlaceHolder").text("("+data.SumOfCheckoutItems+")");
			}
			if(data.SumOfRequestItems != 0){
			    $("#my-ruest-item-placeHolder").text(" ("+data.SumOfRequestItems+")");
			}
			setInterval("getRequestAndCheckout()",20000);
		    }
		}
		)
	    }
	);
	</script>
    {/literal}
    {literal}
	<script type="text/javascript">
	    function getRequestAndCheckout(){
	    $.getJSON(path + '/MyResearch/AJAX?method=getAllItems', function (data){
		if (data.error){
		}else{
		    if(data.SumOfCheckoutItems != 0){
			$("#my-item-PlaceHolder").text("("+data.SumOfCheckoutItems+")");
		    }
		    if(data.SumOfRequestItems != 0){
			$("#my-ruest-item-placeHolder").text(" ("+data.SumOfRequestItems+")");
		    }
		}
	    }
	    )
	    }
        </script>
    {/literal}

    
    
    <div class="prefer-branch" id="prefer-branch">
        <div id="description">
            Your Preferred Branches
        </div>
	<input id="edit-button" class="button" type="button" value="Edit" onclick="getToUpdatePreferredBranches()"/>
    </div>
    {literal}
    <script type="text/javascript">
	$("#prefer-branch").ready(function(){
	    $.ajax({
			type: 'get',
            url: "/MyResearch/AJAX?method=getLocations",
			dataType:"html",
			success: function(data) {
			    $("#prefer-branch").html(data);
				 if(data){
					$("#topBar").css("display","block");
				}
				$('.qtip-preferred-libs').qtip({ // Grab some elements to apply the tooltip to
				    content: {
				        text: 'Specifying Preferred Libraries sets your default pickup location for items requested online. <a id="qtip-link-preferred-libs" href="/Help/Home?topic=myaccount#PreferredLibraries">Read More...</a>'
				    },
				    hide: {
				        delay: 1000
				    },
				    style: {
				        classes: 'qtip-rounded'
				    }
				})
			},
			error: function() {
				$('#popupbox').html(failMsg);
					setTimeout("hideLightbox();", 3000);
				}
		    });
	    })
    </script>
    {/literal}

   {php}
        global $interface;
   
	$tmpList1 = new User_list();
	$tmpList1->id = 1;    
	$tmpList1->find();
	while ($tmpList1->fetch()){
	    $title1 = $tmpList1->title;
    	}
	$interface->assign("Title1", $title1 );
	
	$tmpList2 = new User_list();
	$tmpList2->id = 2;    
	$tmpList2->find();
	while ($tmpList2->fetch()){
	    $title2 = $tmpList2->title;
    	}
	$interface->assign("Title2", $title2 );
	
	$tmpList3 = new User_list();
	$tmpList3->id = 5924;    
	$tmpList3->find();
	while ($tmpList3->fetch()){
	    $title3 = $tmpList3->title;
    	}
	$interface->assign("Title3", $title3 );

	$tmpList4 = new User_list();
	$tmpList4->id = 5925;    
	$tmpList4->find();
	while ($tmpList4->fetch()){
	    $title4 = $tmpList4->title;
    	}
	$interface->assign("Title4", $title4 );	

	$tmpList5 = new User_list();
	$tmpList5->id = 3;    
	$tmpList5->find();
	while ($tmpList5->fetch()){
	    $title5 = $tmpList5->title;
    	}
	$interface->assign("Title5", $title5 );		
		
    {/php}
    
    <div id="blank">&nbsp;</div>
    <div class="separator"><hr/></div>
    <div class="recommendations">
	
	<!-- What's New Queries display here -->
	<div id="newdvd">
            <a href="{$url}/Search/Results?lookfor=&type=Keyword&basicType=Keyword&filter[]=time_since_added%3A%22Week%22&Keyword&filter[]=time_since_added%3A%22Month%22&filter[]=format%3A%22DVD%22&sort=year&view=list&searchSource=local">New DVDs</a>
        </div>
	
	<div id="newblu">
            <a href="{$url}/Search/Results?lookfor=&type=Keyword&basicType=Keyword&filter[]=time_since_added%3A%22Week%22&filter[]=time_since_added%3A%22Month%22&filter[]=format%3A%22Blu-Ray%22&sort=year&view=list&searchSource=local">New Blu-Rays</a>
        </div>
	
	<div id="newebooks">
            <a href="{$url}/Search/Results?lookfor=&type=Keyword&basicType=Keyword&filter[]=time_since_added%3A%22Week%22&filter[]=time_since_added%3A%22Month%22&filter[]=format%3A%22Ebook+Download%22&filter[]=format%3A%22Adobe+EPUB%20eBook%22&filter[]=format%3A%22Kindle+Book%22&filter[]=format%3A%22Adobe+PDF%20eBook%22&filter[]=format%3A%22OverDrive+Read%22&sort=year&view=list&searchSource=0">New eBooks</a>
        </div>
	
	<!-- featured lists display here -->
<!--        <div id="title1">
            <a href="{$url}/MyResearch/MyList/1">{$Title1}</a>
        </div>
        <div id="title2">
            <a href="{$url}/MyResearch/MyList/2">{$Title2}</a>
        </div>
	<div id="title3">
            <a href="{$url}/MyResearch/MyList/5924">{$Title3}</a>
        </div>
        <div id="title4">
            <a href="{$url}/MyResearch/MyList/5925">{$Title4}</a>
        </div>
        <div id="title5">
            <a href="{$url}/MyResearch/MyList/3">{$Title5}</a>
        </div>
-->	<!-- end of featured lists -->
	
        <div id="articles">
            <a href="http://erec.einetwork.net/">Databases and Articles</a>
        </div>
        <div id="interlibraryloan">
            <a href="http://illiad.carnegielibrary.org/illiad/logon.html">Interlibrary Loan</a>
        </div>	
        
    </div>
</div>
{/strip}
