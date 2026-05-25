<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_2_1#></title>
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
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script>
var old_lan_addr = "<% nvram_get_x("","lan_ipaddr"); %>";
var old_lan_mask = "<% nvram_get_x("","lan_netmask"); %>";

function initial(){
	show_banner();
	show_menu(5, 3, 1);
	show_footer();
}

function applyRule(){
	if(validForm()){
		showLoading();

		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "Advanced_LAN_Content.asp";
		document.form.next_page.value = "";

		document.form.submit();
	}
}

function valid_LAN_IP(ip_obj){
	var A_class_min = inet_network("1.0.0.0");
	var A_class_max = inet_network("126.255.255.255");
	var B_class_min = inet_network("127.0.0.0");
	var B_class_max = inet_network("127.255.255.255");
	var C_class_min = inet_network("128.0.0.0");
	var C_class_max = inet_network("255.255.255.255");

	var ip_num = inet_network(ip_obj.value);

	if(ip_num > A_class_min && ip_num < A_class_max)
		return true;
	else if(ip_num > B_class_min && ip_num < B_class_max)
		return false;
	else if(ip_num > C_class_min && ip_num < C_class_max)
		return true;
	return false;
}

function validForm(){
	var addr_obj = document.form.lan_ipaddr;
	var mask_obj = document.form.lan_netmask;
	var addr_num = inet_network(addr_obj.value);

	if(!validate_ipaddr_final(addr_obj, 'lan_ipaddr') ||
			!validate_ipaddr_final(mask_obj, 'lan_netmask'))
		return false;

	if(!valid_LAN_IP(addr_obj)) {
		alert(addr_obj.value+" <#JS_validip#>");
		addr_obj.focus();
		addr_obj.select();
		return false;
	}

	var snet_min = get_subnet_num(addr_obj.value, mask_obj.value, 0);
	var snet_max = get_subnet_num(addr_obj.value, mask_obj.value, 1);

	if(addr_num == snet_min || addr_num == snet_max){
		alert(addr_obj.value+"/"+mask_obj.value+" <#JS_validip#>");
		addr_obj.focus();
		addr_obj.select();
		return false;
	}

	var wan_addr = document.form.wan_ipaddr.value;
	var wan_mask = document.form.wan_netmask.value;

	if(wan_addr != "0.0.0.0" && wan_addr != "" && wan_mask != "0.0.0.0" && wan_mask != ""){
		if(matchSubnet2(wan_addr, wan_mask, addr_obj.value, mask_obj.value)){
			alert("<#JS_validsubnet#>");
			mask_obj.focus();
			mask_obj.select();
			return false;
		}
	}

	if(addr_obj.value != old_lan_addr || mask_obj.value != old_lan_mask){
		var o_min = document.form.dhcp_start;
		var o_max = document.form.dhcp_end;
		if(!matchSubnet(o_min.value, addr_obj.value, mask_obj.value) ||
				!matchSubnet(o_max.value, addr_obj.value, mask_obj.value) ||
				inet_network(o_min.value) <= snet_min ||
				inet_network(o_max.value) >= snet_max) {
			if(confirm("<#JS_DHCP1#>")){
				var snet_pool = snet_max-snet_min;
				o_min.value = num2ip4(snet_min+2);
				if (snet_pool > 30)
					o_max.value=num2ip4(snet_max-11);
				else
					o_max.value=num2ip4(snet_max-1);
			}else{
				mask_obj.focus();
				mask_obj.select();
				return false;
			}
		}
	}

	if(addr_obj.value != old_lan_addr)
		alert("<#LANHostConfig_lanipaddr_changed_hint#>");

	return true;
}

function done_validating(action){
	refreshpage();
}
</script>
</head>

<body onload="initial();" onunLoad="return unload_body();" class="bg">
<div id="TopBanner"></div>

<div id="hiddenMask" class="popup_bg" style="z-index:10000;">
	<table cellpadding="5" cellspacing="0" id="dr_sweet_advise" class="dr_sweet_advise" align="center">
		<tr>
			<td>
				<div class="drword" id="drword" style="height:110px;"><#Main_alert_proceeding_desc4#> <#Main_alert_proceeding_desc1#>...</div>
				<div class="drImg"><img src="images/alertImg.png"></div>
				<div style="height:70px;"></div>
			</td>
		</tr>
	</table>
</div>

<div id="Loading" class="popup_bg"></div>

<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="current_page" value="Advanced_LAN_Content.asp">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="next_host" value="">
<input type="hidden" name="sid_list" value="LANHostConfig;">
<input type="hidden" name="group_id" value="">
<input type="hidden" name="action_mode" value="">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="wan_ipaddr" value="<% nvram_get_x("", "wan0_ipaddr"); %>" readonly="1">
<input type="hidden" name="wan_netmask" value="<% nvram_get_x("", "wan0_netmask"); %>" readonly="1">
<input type="hidden" name="dhcp_start" value="<% nvram_get_x("", "dhcp_start"); %>">
<input type="hidden" name="dhcp_end" value="<% nvram_get_x("", "dhcp_end"); %>">

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
											<div class="formfonttitle"><#menu5_2#> - <#menu5_2_1#></div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
											<div class="formfontdesc"><#LANHostConfig_display1_sectiondesc#></div>

											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th width="35%"><a class="hintstyle" href="javascript:void(0);" onClick="openHint(4,1);"><#LANHostConfig_IPRouters_itemname#></a></th>
													<td>
														<input type="text" maxlength="15" class="input_15_table" id="lan_ipaddr" name="lan_ipaddr" value="<% nvram_get_x("LANHostConfig","lan_ipaddr"); %>" onKeyPress="return is_ipaddr(this,event);" autocorrect="off" autocapitalize="off">
														<span>192.168.1.1</span>
													</td>
												</tr>
												<tr>
													<th><a class="hintstyle" href="javascript:void(0);" onClick="openHint(4,2);"><#LANHostConfig_SubnetMask_itemname#></a></th>
													<td>
														<input type="text" maxlength="15" class="input_15_table" name="lan_netmask" value="<% nvram_get_x("LANHostConfig","lan_netmask"); %>" onkeypress="return is_ipaddr(this,event);" autocorrect="off" autocapitalize="off">
														<span>255.255.255.0</span>
													</td>
												</tr>
												<tr>
													<th><#LAN_STP#></th>
													<td>
														<input type="radio" value="1" name="lan_stp" id="lan_stp_1" <% nvram_match_x("", "lan_stp", "1", "checked"); %>><#checkbox_Yes#>
														<input type="radio" value="0" name="lan_stp" id="lan_stp_0" <% nvram_match_x("", "lan_stp", "0", "checked"); %>><#checkbox_No#>
													</td>
												</tr>
											</table>

											<div class="apply_gen">
												<input class="button_gen" onclick="applyRule()" type="button" value="<#CTL_apply#>">
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
