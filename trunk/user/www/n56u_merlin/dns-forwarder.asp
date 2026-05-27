<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_15#></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/index_style.css">
<link rel="stylesheet" type="text/css" href="/form_style.css">
<link rel="stylesheet" type="text/css" href="/other.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/merlin_adapter.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>

<script>
var $j = jQuery.noConflict();
<% dnsforwarder_status(); %>

$j(document).ready(function(){
	init_itoggle('dns_forwarder_enable');
});

function initial(){
	show_banner(2);
	show_menu(5,12,1);
	show_footer();
	fill_status(dnsforwarder_status());
}

function applyRule(){
	if(validForm()){
		showLoading();
		document.form.action_mode.value = " Restart ";
		document.form.current_page.value = "dns-forwarder.asp";
		document.form.next_page.value = "";
		document.form.submit();
	}
}

function validForm(){
	var addr_obj = document.form.dns_forwarder_bind;
	if(!validate_ipaddr_final(addr_obj, ''))
		return false;
	return true;
}

function fill_status(status_code){
	var stext = "Unknown";
	if (status_code == 0)
		stext = "<#Stopped#>";
	else if (status_code == 1)
		stext = "<#Running#>";
	$("dnsforwarder_status").innerHTML = '<span class="label label-' + (status_code != 0 ? 'success' : 'warning') + '">' + stext + '</span>';
}

</script>

<style>
.FormTable input,
.FormTable select {
	margin-bottom: 0px;
}
.FormTable td.status_label span.label {
	color: #FFFFFF;
	background: #596e74;
	border-color: #6b8fa3;
}
.FormTable td.status_label span.label-success {
	background: #3d774d;
	border-color: #6b9b73;
}
.FormTable td.status_label span.label-warning {
	background: #8a6d2f;
	border-color: #c09853;
}
</style>
</head>

<body onload="initial();" onunLoad="return unload_body();" class="bg">

<div id="TopBanner"></div>

<div id="Loading" class="popup_bg"></div>

<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
	
    <input type="hidden" name="current_page" value="dns-forwarder.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="dnsforwarderConf;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="">

<table class="content" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="17">&nbsp;</td>
		<td valign="top" width="202">
			<div id="mainMenu"></div>
			<div id="subMenu"></div>
		</td>
		<td valign="top">
			<div id="tabMenu" class="submenuBlock"></div>
			<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
				<tr>
					<td align="left" valign="top">
						<table width="760px" border="0" cellpadding="5" cellspacing="0" class="FormTitle" id="FormTitle">
							<tbody>
								<tr>
									<td bgcolor="#4D595D" valign="top">
										<div class="container">
											<div>&nbsp;</div>
											<div class="formfonttitle"><#menu5_15#></div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>

											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th><#running_status#></th>
													<td id="dnsforwarder_status" class="status_label"></td>
												</tr>
												<tr>
													<th><#menu5_15_1#></th>
													<td>
														<div class="main_itoggle">
															<div id="dns_forwarder_enable_on_of">
																<input type="checkbox" id="dns_forwarder_enable_fake" <% nvram_match_x("", "dns_forwarder_enable", "1", "value=1 checked"); %><% nvram_match_x("", "dns_forwarder_enable", "0", "value=0"); %>>
															</div>
														</div>
														<div style="position: absolute; margin-left: -10000px;">
															<input type="radio" value="1" name="dns_forwarder_enable" id="dns_forwarder_enable_1" <% nvram_match_x("", "dns_forwarder_enable", "1", "checked"); %>><#checkbox_Yes#>
															<input type="radio" value="0" name="dns_forwarder_enable" id="dns_forwarder_enable_0" <% nvram_match_x("", "dns_forwarder_enable", "0", "checked"); %>><#checkbox_No#>
														</div>
													</td>
												</tr>
												<tr>
													<th width="50%"><#menu5_14_2#></th>
													<td>
														<input type="text" maxlength="15" class="input" size="15" name="dns_forwarder_bind" style="width: 145px" value="<% nvram_get_x("","dns_forwarder_bind"); %>" onkeypress="return is_ipaddr(this,event);"/>
													</td>
												</tr>
												<tr>
													<th width="50%"><#menu5_14_3#></th>
													<td>
														<input type="text" maxlength="5" class="input" size="15" name="dns_forwarder_port" style="width: 145px" value="<% nvram_get_x("", "dns_forwarder_port"); %>">
													</td>
												</tr>
												<tr>
													<th width="50%"><#menu5_14_4#></th>
													<td>
														<input type="text" maxlength="64" class="input" size="64" name="dns_forwarder_server" style="width: 145px" value="<% nvram_get_x("", "dns_forwarder_server"); %>">
													</td>
												</tr>
											</table>

											<div class="apply_gen">
												<input class="button_gen" type="button" value="<#CTL_apply#>" onclick="applyRule()">
											</div>
										</div>
										<div class="popup_container popup_element_second"></div>
									</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td width="10" align="center" valign="top">&nbsp;</td>
	</tr>
</table>
</form>

<div id="footer"></div>

</body>
</html>
