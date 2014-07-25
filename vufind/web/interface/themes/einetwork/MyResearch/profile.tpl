<div id="page-content" class="content">
{literal}
<script type="text/javascript">
	$(document).ready(function(){
		
		if ($('select[name="notices"]').val() == 'p'){
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
		} else if ($('select[name="notices"]').val() == 'z'){	
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
		}
		
	});
	function checkWhenSubmit(){

		var phone=$('input[name="phone"]').val();
		phoneReg=/^[2-9]\d{9}$/;
		var email=$('input[name="email"]').val();
		emailReg=/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

		noSubmit = false;

		$('#phoneError').text('');
		$('#emailError').text('');

		if ($('select[name="notices"]').val() == 'p'){
			if(phone=='' || !phoneReg.test(phone)){
				noSubmit = true;
				$('#phoneError').text('You chose to be notified by phone. Please enter a valid phone number');
			}
		} else if ($('select[name="notices"]').val() == 'z'){
			if(email=='' || !emailReg.test(email)){
				noSubmit = true;
				$('#emailError').text("You chose to be notified by email. Please enter a valid email address");
			}
		}

		if (noSubmit == true){
			return false;
		} else {
			return true;
		}

	}

</script>
{/literal}
	 
	<div id="left-bar">
		
	</div>


	<div id="main-content">
		{if $profileUpdateErrors}
		<div class="error">{$profileUpdateErrors}</div>
		{/if}
		{if $user->cat_username}
		<div><h2>Account Settings</h2></div>
<!--		<div class="new-alert-box-container"> 
			<ul class="new-alert-box">
				<li></li>
			</ul>
		</div>-->
		<form id="profileForm" action="" method="post" {if $edit == true}onsubmit="return checkWhenSubmit();"{/if}>
		{if $canUpdate}
			{if $edit == true}
			<input  type='submit' value='Update Profile' name='update'  class='button'/>
			<input  type='button' value='Cancel' name='update' onclick='window.location.href="/MyResearch/Profile"' class='button'/>
			{else}
			<input type='submit' value='Edit Profile' name='edit' class='button'/>
			{/if}
		{/if}
		<input class="button" type="button" onclick="ajaxLightbox('/MyResearch/AJAX?method=getPinUpdateForm',false,false,'400px',false,'250px');return false;" value="Modify PIN Number"/>
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
							<select name='notices'>
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
					<td>{translate text='Email'}<span><img class="qtip-email help-icon" style="vertical-align:middle" src="/images/help_icon.png" /></span></td>
				</tr>
				<tr>
					<td>
						{if $edit == true}
						<input id="phone" name='phone' class="text" value='{$profile.phone|regex_replace:"/\D/":""}' size='20' maxlength='10' />
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
						<input id="email" name='email' class="text" value='{$profile.email|escape}' size='20' maxlength='30' />
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
						{html_options name="myLocation1" options=$locationList selected=$profile.myLocation1Id}
						{else}{$profile.myLocation1|escape}
						{/if}
					</td>
					<td>
						{if $edit == true}
						{html_options name="myLocation2" options=$locationList selected=$profile.myLocation2Id}
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
									<select name="{$lendingOption.id}">
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
			<input  type='submit' value='Update Profile' name='update'  class='button'/>
			<input  type='button' value='Cancel' name='update' onclick='window.location.href="/MyResearch/Profile"' class='button'/>
			{else}
			<input type='submit' value='Edit Profile' name='edit' class='button'/>
			{/if}
		{/if}
		<input class="button" type="button" onclick="ajaxLightbox('/MyResearch/AJAX?method=getPinUpdateForm',false,false,'400px',false,'250px');return false;" value="Modify PIN Number"/>
		</form>
		{/if}
	</div>
	
	<div id="right-bar">
		{include file="MyResearch/menu.tpl"}
		{include file="Admin/menu.tpl"}
	</div>
	
</div>
