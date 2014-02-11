{strip}
<script type="text/javascript" src="{$path}/services/Record/ajax.js"></script>
<div class="row">
	<div class="col-xs-9 col-md-9">
		<div class="resulthead" style="margin-bottom: 25px;">
			<h3>{translate text='Place a Hold'}</h3>
		</div>
		<form id='placeHoldForm' name='placeHoldForm' action="{$path}/Record/{$id|escape:"url"}/Hold" method="post">
			<div style="margin-left: 20px">
				<div id="loginFormWrapper">
					{if (!isset($profile)) }

						<div class="row hold-row-spacing">
							<div class="col-xs-6 col-md-6">I have an Allegheny County Library Card</div>
						</div>

						<div class="row hold-row-spacing">
							<div class="col-xs-5 col-md-5">{translate text='Username'}: </div>
							<div class="col-xs-4 col-md-4"><input type="text" name="username" id="username" value="{$username|escape}" size="15" class="form-control"/></div>
						</div>

						<div class="row hold-row-spacing">
							<div class="col-xs-5 col-md-5">{translate text='Password'}: </div>
							<div class="col-xs-4 col-md-4"><input type="password" name="password" id="password" size="15" class="form-control"/></div>
						</div>

						<div class="row hold-row-spacing">
							<div class="col-xs-5 col-md-5"></div>
							<div class="col-xs-4 col-md-4"><input id="loginButton" type="button" onclick="GetPreferredBranches('{$id|escape}');" value="Login" class="btn btn-default"/></div>
						</div>

					{/if}

					<div id='holdOptions' {if (!isset($profile)) }style='display:none'{/if}>

						<div class="row hold-row-spacing">
							<div class="col-xs-3 col-md-3">{translate text="I want to pick this up at"}:</div>
							<div class="col-xs-5 col-md-5">
								<select name="campus" id="campus" style="margin-left: 20px;width: 260px" class="form-control">
									{if count($pickupLocations) > 0}
										{foreach from=$pickupLocations item=location}
											<option value="{$location->code}" {if $location->selected == "selected"}selected="selected"{/if}>{$location->displayName}</option>
										{/foreach}
									{else} 
										<option>placeholder</option>
									{/if}
								</select>
							</div>
							<div class="col-xs-4 col-md-4"><input type="submit" class="btn btn-default" style="margin-left: 60px;" name="submit" id="requestTitleButton" value="{translate text='Request This Title'}" {if (!isset($profile))}disabled="disabled"{/if}/></div>
						</div>

						<div class="row hold-row-spacing">
							<div class="col-xs-5 col-md-5">
								<input type="hidden" name="type" value="hold"/>
								<input type="checkbox" style="margin-right: 0px" name="autologout" /> Log me out after requesting the item. 
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div class="col-xs-3 col-md-3">
		{include file="ei_tpl/right-bar.tpl"}
	</div>
</div>
{/strip}
