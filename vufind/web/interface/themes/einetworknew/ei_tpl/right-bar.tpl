{strip}
{literal}
<script type="text/javascript">

	$(document).ready(function(){

		$('#notification-center-link').click(function(){
			$('.notification-center').show('fast');
		})

		$('.notification-center .close').click(function(){
			$('.notification-center').hide('slow');
		})

	});

</script>
{/literal}
<div class="right-bar">
	<div class="row">
		<div class="col-xs-12 col-md-12 notification-center-container">
			<span class="glyphicon glyphicon-inbox"></span> <a id="notification-center-link" class="disable-link" href="">Notification Center</a> <span style="color:#f00;font-size:0.95em">(2)</span>
			<div class="row">
				<div class="col-xs-12 col-md-12 notification-center">
					<p class="notification-arrow-up"></p>
					<button type="button" class="close pull-right">&times;</button>
					<p>Your library card is due to expire within the next <span class="label label-danger" style="font-size:0.85em">30 days</span>.<br />Please visit your local library to renew your card to ensure access to all online services.</p>
					<p class="notification-center-footer">You have <span class="label label-danger" style="font-size:0.85em">$1.35</span> in overdue fines.</p>
				</div>
			</div>
		</div>
	</div>

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
			<div class="list-group side-nav">
				<a class="list-group-item disable-link" href="" onclick='getWishList()'>Wish Lists</a>
				<a class="list-group-item disable-link" href="" onclick='getCheckedOutItem()'>Checked Out Items <span id="my-item-PlaceHolder"></span></a>
				<a class="list-group-item disable-link" href="" onclick='getRequestedItem()' >Requested Items <span id="my-ruest-item-placeHolder"></span></a>
				<a class="list-group-item disable-link" href="" onclick='getReadingHistory()' >Reading History</a>
				<a class="list-group-item" href="/Search/History">Saved Searches</a>
				<a class="list-group-item disable-link" href="" onclick='getAccountSetting()'>Account Settings</a>
				<a class="list-group-item" href="/MyResearch/Firsttime">First Time Using the Catalog?</a>
				<a class="list-group-item" href="/MyResearch/Latestupdates">Latest Website Updates</a>
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
			<div class="list-group side-nav">
				<a class="list-group-item" href="{$url}/MyResearch/MyList/1">{$Title1}</a>
				<a class="list-group-item" href="{$url}/MyResearch/MyList/2">{$Title2}</a>
				<a class="list-group-item" href="{$url}/MyResearch/MyList/5924">{$Title3}</a>
				<a class="list-group-item" href="{$url}/MyResearch/MyList/5925">{$Title4}</a>
				<a class="list-group-item" href="{$url}/MyResearch/MyList/3">{$Title5}</a>
				<a class="list-group-item" href="http://articles.einetwork.net">Databases and Articles</a>
				<a class="list-group-item" href="http://illiad.carnegielibrary.org/illiad/logon.html">Interlibrary Loan</a>
			</div>

</div>

</div>
{/strip}