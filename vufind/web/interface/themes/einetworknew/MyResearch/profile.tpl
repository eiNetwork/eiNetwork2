<div id="page-content" class="content">
{literal}
<script type="text/javascript">
	$(document).ready(function(){
		$('#phone').blur(function(){
			var phone=$(this).val(),
			    phoneReg=/^[2-9]\d{9}$/;
			if(!phoneReg.test(phone)){
				$('#phoneError').text('*please enter a valid phone number');
				phoneValid=false;
				return false;
			}else{
				$('#phoneError').html('&nbsp;');
				return true;
			}
		});

		$('#email').blur(function(){
			var email=$('input[name="email"]').val(),
		            emailReg=/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
			if(!emailReg.test(email)||email==''){
				$('#emailError').text("*please enter a vaild email address");
				emailValid=false;
				return false;
			}else{
				$('#emailError').html('&nbsp;');
			}
		});
		
	});
	function checkWhenSubmit(){
		//$('input[name="phone"]').val($('input[name="phone"]').val().replace(/\D/g,'')) ;
		var phone=$('input[name="phone"]').val(),
		phoneReg=/^[2-9]\d{9}$/;
		var email=$('input[name="email"]').val(),
		emailReg=/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
		if(!phoneReg.test(phone)||!emailReg.test(email)||email==''){
			return false;
		}else{
			return true;
		}
	}

</script>
{/literal}	 

	<div class="col-xs-9 col-md-9">
		{if $profileUpdateErrors}
		<div class="error">{$profileUpdateErrors}</div>
		{/if}
		{if $user->cat_username}
		<div><h2>Account Settings</h2></div>
		<div><p style="font-size:80%;color:red">We are receiving reports about some users not receiving email notices for upcoming due dates, hold pickups, or overdue items.  You may wish to check My Account or contact your local library for this information.   Please contact your email provider if you believe you are not receiving these notices.</p></div>
		{if $profile.expireclose == 1}
		<font color="red"><b>Your library card is due to expire within the next 30 days.  Please visit your local library to renew your card to ensure access to all online service.  </a></b></font>
		{elseif $profile.expireclose == -1}
		<font color="red"><b>Your library card is expired.  Please visit your local library to renew your card to ensure access to all online service.  </a></b></font>
		{/if}
		<form role="form" id="profileForm" action="" method="post" {if $edit == true}onsubmit="return checkWhenSubmit();"{/if}>
		<h3 id="info">Information</h3>
		<input class="btn btn-default modify-pin" type="button" onclick="ajaxLightbox('/MyResearch/AJAX?method=getPinUpdateForm',false,false,'400px',false,'250px');return false;" value="Modify PIN Number"/>
			<div class="profile">
			<div id="name_notification" class="profile_row">
				<table>
				<tr style="font-weight: bolder">
					<td>{translate text='Name'}</td>
					<td>{translate text='Notification Preference'}</td>
				</tr>
				<tr>
					<td>
						{if $profile.fullname}
							{$profile.fullname|escape}
						{else}
							{$user->lastname|escape|upper}, {$user->firstname|escape|upper}
						{/if}
					
					</td>
					<td>
						{if $edit == true}
							<select name='notices' class="form-control">
							<option value='z' >E-mail</option>
							<option value='p' {if $profile.notices == 'p'}selected="selected"{/if}>Phone</option>
							</select>
						{else}
						{if $profile.notices == 'p'}Phone{else}Email{/if}
						{/if}
					</td>
				</tr>
				</table>
			</div>
			<div id="card_expiration" class="profile_row">
				<table>
				<tr style="font-weight: bolder">
					<td>{translate text='Library Card Number'}</td>
					<td>{translate text='Card Expires'}</td>
				</tr>
				<tr>
					<td>{$card_number}</td>
					<td><div {if $profile.expireclose} style="color: red" {/if}>{$profile.expires|escape}</div></td>
				</tr>
				</table>
			</div>
			<div id="address_library" class="profile_row">
				<table>
				<tr style="font-weight: bolder">
					<td>{translate text='Address'}</td>
					<td>{translate text='My Home Library'}</td>
				</tr>
				<tr>
					<td>{$profile.address1|escape}<br />{$profile.city|escape} {$profile.state|escape} {$profile.zip|escape}</td>
					<td>{$profile.homeLocation|escape}</td>
				</tr>
				</table>
			</div>
			<div id="phone_email" class="profile_row">
				<table>
				<tr style="font-weight: bolder">
					<td>{translate text='Phone Number'}</td>
					<td>{translate text='Email'}</td>
				</tr>
				<tr>
					<td>
						{if $edit == true}
						<input id="phone" name='phone' class="form-control" value='{$profile.phone|regex_replace:"/\D/":""}' size='20' maxlength='10' />
						<span id="phoneError" class="error">&nbsp;</span>
						{else}
							{if $profile.phone}
								{$profile.phone|regex_replace:"/\D/":""}
							{else}
								{$user->phone|regex_replace:"/\D/":""}
							{/if}
						{/if}
					</td>
					<td>
						{if $edit == true}
						<input id="email" name='email' class="form-control" value='{$profile.email|escape}' size='20' maxlength='30' />
						<span id="emailError" class="error">&nbsp;</span>
						{else}
							{if $profile.email}
								{$profile.email|escape}
							{else}
								{$user->email|escape}
							{/if}
						{/if}
					</td>
				</tr>
				</table>
			</div>

			<div id="preferred_alternative" class="profile_row">
				<table>
				<tr style="font-weight: bolder">
					<td>{translate text='Preferred Library'}</td>
					<td>{translate text='Alternative Library'}</td>
				</tr>
				<tr>
					<td>
						{if $edit == true}
						{html_options name="myLocation1" options=$locationList class="form-control" selected=$profile.myLocation1Id}
						{else}{$profile.myLocation1|escape}
						{/if}
					</td>
					<td>
						{if $edit == true}
						{html_options name="myLocation2" options=$locationList class="form-control" selected=$profile.myLocation2Id}
						{else}{$profile.myLocation2|escape}
						{/if}
					</td>
				</tr>
				</table>
			</div>	
			
		</div>
		<div id="overdrivetab" class="profile_row">
			{if $overDriveLendingOptions}
				<table>
					<tr style="font-weight: bolder"><td colspan="2">{translate text='OverDrive E-Content Lending Options'}</td></tr>
<!--					<div>{$overDriveLendingOptions|print_r}</div>-->
					{foreach from=$overDriveLendingOptions item=lendingOption name=lending}
						{if $smarty.foreach.lending.iteration is odd}<tr>{/if}
							<td text-align="left">
								<div style="font-weight: bolder">{$lendingOption.name}</div><br/>
								<div id="{$lendingOption.id}Select">
									{if $edit}
									<select name="{$lendingOption.id}" class="form-control">
										{foreach from=$lendingOption.options item=option}
												<option value="{$option.value}" {if $option.selected}selected{/if}>{$option.name}</option>

										{/foreach}
									</select>
									{else}
										{foreach from=$lendingOption.options item=option}
										{if $option.selected}
										{$option.name}
										{/if}
										{/foreach}
									{/if}
								</div>
							</td>
						{if $smarty.foreach.lending.iteration is even}</tr>{/if}
					{/foreach}
				</table>
			{/if}				
		</div>

		{if $canUpdate}
			{if $edit == true}
			<input  type='submit' value='Update Profile' name='update'  class='btn btn-default'/>
			<input  type='button' value='Cancel' name='update' onclick='window.location.href="/MyResearch/Profile"' class='btn btn-default'/>
			{else}
			<input type='submit' value='Edit Profile' name='edit' class='btn btn-default'>
			{/if}
		{/if}
		</form>
		{/if}
	</div>
	
	<div class="col-xs-3 col-md-3 clearfix">
		{include file="MyResearch/menu.tpl"}
		{include file="Admin/menu.tpl"}
	</div>
	
</div>
