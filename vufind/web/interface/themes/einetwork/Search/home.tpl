<div id="loginHome2">
	<div class="loginHome-left"></div>
	<div class="loginHome-center">
				<p class="bold new_updates">Please welcome Millvale Community Library to the county-wide library system! You can now choose this location for hold pickups and your preferred libraries.</p>

		<div class="startMessage">
			Get started by entering your search above.
		</div>
		<div class="splashLinks">
			<table class="splashTable"><tr>
				<td style="width:35%">
					<div id="selectreads">
						<a href="http://bookdb.nextgoodbook.com/signup/ml/f485432415b23a8962922e0b2d198227" target="_blank">
							<img src="/interface/themes/einetwork/images/Selectreads/selectreads-block.png" alt="SelectReads logo" height="72" width="190" />
						</a>
						<img class="qtip-selectreads help-icon" style="vertical-align:top" src="/images/help_icon.png" /></span>
					</div>
					<div id="authorcheck">
						<a href="http://authordb.nextgoodbook.com/landing/l/f485432415b23a8962922e0b2d198227" target="_blank">
							<img src="/interface/themes/einetwork/images/Selectreads/authorchecklogo.png" alt="Author Check logo" height="65" width="150" />
						</a>
						<img class="qtip-authorcheck help-icon" style="vertical-align:top" src="/images/help_icon.png" />
					</div>
				</td>
    				<td style="width:30%" class="splashCenter">
					<div id="newdvd">
				            <a href="{$url}/Search/Results?lookfor=&type=Keyword&basicType=Keyword&filter[]=time_since_added%3A%22Week%22&Keyword&filter[]=time_since_added%3A%22Month%22&filter[]=format%3A%22DVD%22&sort=year&view=list&searchSource=local">New DVDs</a>
				        </div><br>
					<div id="newblu">
				            <a href="{$url}/Search/Results?lookfor=&type=Keyword&basicType=Keyword&filter[]=time_since_added%3A%22Week%22&filter[]=time_since_added%3A%22Month%22&filter[]=format%3A%22Blu-Ray%22&sort=year&view=list&searchSource=local">New Blu-Rays</a>
				        </div><br>
					<div id="newebooks">
				            <a href="{$url}/Search/Results?lookfor=&type=Keyword&basicType=Keyword&filter[]=time_since_added%3A%22Week%22&filter[]=time_since_added%3A%22Month%22&filter[]=format%3A%22Ebook+Download%22&filter[]=format%3A%22Adobe+EPUB%20eBook%22&filter[]=format%3A%22Kindle+Book%22&filter[]=format%3A%22Adobe+PDF%20eBook%22&filter[]=format%3A%22OverDrive+Read%22&sort=year&view=list&searchSource=0">New eBooks</a>
				        </div><br>
				        <div id="articles">
				            <a href="http://erec.einetwork.net/">Databases and Articles</a>
				        </div><br>
				        <div id="interlibraryloan">
				            <a href="http://illiad.carnegielibrary.org/illiad/logon.html">Interlibrary Loan</a>
				        </div>	
				</td>
    				<td style="width:35%">
					<div id="newbookalerts">
						<a href="http://nextgoodbook.com/newsletter/landing/l/f485432415b23a8962922e0b2d198227/c/1000" target="_blank">
							<img src="/interface/themes/einetwork/images/Selectreads/New-Book-Alerts190-sml.jpg" alt="New Book Alerts logo" height="52" width="160" />
						</a>
						<img class="qtip-newbookalerts help-icon" style="vertical-align:top" src="/images/help_icon.png" />
					</div>
					<div id="novelist">
						<a href="http://search.ebscohost.com/login.aspx?authtype=cpid&custid=s4663075&profile=novelist" target="_blank">
							<img src="/interface/themes/einetwork/images/Selectreads/NoveList/novelist_button_150x75.gif" alt="NoveList logo" height="65" width="130" />
						</a>
						<img class="qtip-novelist help-icon" style="vertical-align:top" src="/images/help_icon.png" /></span>	
					</div>
				</td>
			</tr></table>
		</div>
		<div class="login2">
			<!--<form id="loginForm" action="{$path}/MyResearch/Home" method="post">-->

			<div class="librarycard">
				<b><a onclick='getAccountSetting()'>I have a Library Card</a></b>
			</div><!--<div id="email">
						<input id="card" class="text" type="text" name="username" title="Library Card Number"  value="{$username|escape}" placeholder="Library Card Number" maxlength="14"/>
						<div id="cardError">&nbsp;</div>
					</div>
					<div id="password">
						<input id="pin" class="text" type="text" name="password" title="4 digit PIN number" placeholder="4 digit PIN number" maxlength="8"/>
						<div id="pinError">&nbsp;</div>-->
			<!--<div><a href="/MyResearch/PinReset">I forgot or don't have my pin</a></div>-->
			<!--</div>
					<div>
						<input class="button" type="submit" name="submit" value="Login" alt='{translate text="Login"}' />
					</div>
				</form>-->
		</div>

		<div class="register2">
			<div>
				<a href="{$path}/MyResearch/GetCard"><b>I need a Library Card</b></a>
			</div><!--<div id="description">
					With a free catalog account, you can request items directly from the catalog, view your past searches and get personalized recommendations for items you might like.
				</div>
				<div>
					<a href="{$path}/MyResearch/GetCard">
						<input class="button" type="submit" name="submit" value="Register"/>
					</a>
				</div>
			</div>-->
		</div>

		<div class="loginHome-right"></div>
	</div>
</div>	
