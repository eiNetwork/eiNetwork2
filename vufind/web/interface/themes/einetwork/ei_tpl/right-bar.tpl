{if $notifications.count > 0}
{literal}
<script type="text/javascript">

	var user_id = {/literal}{$user->id}{literal}

	$(document).ready(function(){

		{/literal}{if $notifications.state == 0}{literal}
			var t=setTimeout(function(){$('.notification-center').show('fast');},2000)
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
        <div id="blank">&nbsp;</div>
        <input type="button" class="button" id="view_cart_button" onclick="getViewCart()" value="View Cart">
    </div>
    
    <div class="separator"><hr/></div>
    
    <div class="account-links">
        <div id="wish-lists">
            <a onclick='getWishList()'>My Lists</a>
        </div>
	 <div id="my-item">
            <a onclick='getCheckedOutItem()'>Checked Out Items <span id="my-item-PlaceHolder"></span></a>
        </div>
	<div id="my-request">
          <a onclick='getRequestedItem()' >Requested Items<span id="my-ruest-item-placeHolder"></span></a>
	</div>
	<div id="reading-history">
            <a onclick='getReadingHistory()' >Reading History</a>
        </div>
        <div id="history">
            <a href="/Search/History">Saved Searches</a>
        </div>
        <div id="account-settings">
            <a onclick='getAccountSetting()'>Account Settings</a>
        </div>
	<div id="first-time">
            <a href="/MyResearch/Firsttime">First Time Using the Catalog?</a>
        </div>
	<div id="latest-updates">
            <a href="/MyResearch/Latestupdates">Latest Website Updates</a>
        </div>
	<div id="latest-updates">
            <a href="/MyResearch/einhelp">Catalog Help</a>
        </div>
        <div id="temp-changes">
            <a href="/MyResearch/Tempchanges">Temporary Changes *</a>
        </div>
    </div>

    <p class="libraries-strong"><a href="http://www.countycitylibraries.org/" target="_blank"><img src="http://www.aclalibraries.org/images/ccl200.jpg" alt="Help us keep our libraries strong!" width="200" height="57" border="0" /></a></p>
    
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
    <div class="recommendations">
	
	
	
        <div id="articles">
            <a href="http://articles.einetwork.net">Databases and Articles</a>
        </div>
        <div id="interlibraryloan">
            <a href="http://illiad.carnegielibrary.org/illiad/logon.html">Interlibrary Loan</a>
        </div>	
        
    </div>
</div>
{/strip}