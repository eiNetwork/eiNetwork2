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
<div class="right-bar">
	{if $user}
	<div class="row">
		<div class="col-xs-12 col-md-12 notification-center-container">
			<span class="glyphicon glyphicon-inbox"></span> <a id="notification-center-link" class="disable-link {if $notifications.count == 0}inactive-link{/if}" href="">Notification Center</a> <span style="color:#f00;font-size:0.95em">({$notifications.count})</span>
			<div class="row">
				<div class="col-xs-12 col-md-12 notification-center clearfix">
					<p class="notification-arrow-up notification-center-footer"></p>

					{assign var="x" value=0}

					{foreach from=$notifications.messages item="message"}

					{assign var="x" value=$x+1}

					<p {if $x eq $notifications.count}class="notification-center-footer"{/if}>{$message}</p>

					{/foreach}

					<button type="button" class="btn btn-primary pull-right">Close</button>
				</div>
			</div>
		</div>
	</div>
	{/if}

	<div class="row">
		<div class="col-xs-12 col-md-12">
			<div class="panel panel-default book-cart">
				<div class="panel-body">
					<img src="/interface/themes/einetworknew/images/shopping_cart.png" alt="cart"/>
			        <span id="cart-descrpiion" style="vertical-align:middle"></span><br />
			        <button class="btn btn-default pull-right" id="view_cart_button" onclick="getViewCart()">View Cart</button>
				</div>
			</div>
		</div>
	</div>



	<div class="row">
		<div class="col-xs-12 col-md-12">
			<div class="side-nav">
				{if ($smarty.server.REQUEST_URI == '/List/Results')}
					{assign var="wishlist_link" value="right-current-link"}
				{elseif ($smarty.server.REQUEST_URI == '/MyResearch/CheckedOut')}
					{assign var="checkedout_link" value="right-current-link"}
				{elseif ($smarty.server.REQUEST_URI == '/MyResearch/Holds')}
					{assign var="requested_link" value="right-current-link"}
				{elseif ($smarty.server.REQUEST_URI == '/MyResearch/ReadingHistory')}
					{assign var="readinghistory_link" value="right-current-link"}
				{elseif ($smarty.server.REQUEST_URI == '/Search/History')}
					{assign var="searchhistory_link" value="right-current-link"}
				{elseif ($smarty.server.REQUEST_URI == '/MyResearch/Profile')}
					{assign var="profile_link" value="right-current-link"}
				{elseif ($smarty.server.REQUEST_URI == '/MyResearch/Firsttime')}
					{assign var="firsttime_link" value="right-current-link"}
				{elseif ($smarty.server.REQUEST_URI == '/MyResearch/Latestupdates')}
					{assign var="latestupdates_link" value="right-current-link"}
				{/if}
				<ul>
					<li><a class="disable-link" href="" onclick='getWishList()'>Wish Lists</a></li>
					<li><a class="disable-link" href="" onclick='getCheckedOutItem()'>Checked Out Items <span id="my-item-PlaceHolder"></span></a></li>
					<li><a class="disable-link" href="" onclick='getRequestedItem()' >Requested Items <span id="my-ruest-item-placeHolder"></span></a></li>
					<li><a class="disable-link" href="" onclick='getReadingHistory()' >Reading History</a></li>
					<li><a href="/Search/History">Saved Searches</a></li>
					<li><a class="disable-link" href="" onclick='getAccountSetting()'>Account Settings</a></li>
					<li><a href="/MyResearch/Firsttime">First Time Using the Catalog?</a></li>
					<li><a href="/MyResearch/Latestupdates">Latest Website Updates</a></li>
				</ul>
			</div>
		</div>
	</div>
    
    {literal}
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
			setInterval("getRequestAndCheckout()",2000);
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

    {if $user}
    <div class="row">
		<div class="col-xs-12 col-md-12">
			<div class="panel panel-default">
				<div class="panel-heading">Your Preferred Libraries</div>
				<div class="panel-body">
					<div class="prefer-branch" id="prefer-branch">
				        <div id="description">
				            
				        </div>
				    </div>
				</div>
			</div>
		</div>
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

    {else}

    	<hr />

    {/if}
    
   

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

    <div class="row">
		<div class="col-xs-12 col-md-12">
			<div class="side-nav side-lists">
				<ul>
					<li><a href="{$url}/MyResearch/MyList/1">{$Title1}</a></li>
					<li><a href="{$url}/MyResearch/MyList/2">{$Title2}</a></li>
					<li><a href="{$url}/MyResearch/MyList/5924">{$Title3}</a></li>
					<li><a href="{$url}/MyResearch/MyList/5925">{$Title4}</a></li>
					<li><a href="{$url}/MyResearch/MyList/3">{$Title5}</a></li>
					<li><a href="http://articles.einetwork.net">Databases and Articles</a></li>
					<li><a href="http://illiad.carnegielibrary.org/illiad/logon.html">Interlibrary Loan</a></li>
				</ul>
			</div>
		</div>
	</div>
	
{/strip}
