<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_1_4#></title>
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
<script type="text/javascript" src="/wireless.js"></script>
<script type="text/javascript" src="/help_wl.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script>
var $j = jQuery.noConflict();

<% login_state_hook(); %>

var client_mac = login_mac_str();
var smac = client_mac.split(":");

var ipmonitor = [<% get_static_client(); %>];
var wireless = {<% wl_auth_list(); %>};

var clients_info = getclients(1,0);

var ACLList = [<% get_nvram_list("DeviceSecurity11a", "ACLList"); %>];

var isMenuopen = 0;

function initial(){
	show_banner(1);
	
	show_menu(5,2,4);
	
	show_footer();
	
	change_mac_enabled();
	
	showACLList();
	showLANIPList();
}

function applyRule(){
	if(prevent_lock()){
		showLoading();
		if (document.form.wl_macmode.value == "disabled")
			document.form.action_mode.value = " Apply ";
		else
			document.form.action_mode.value = " Restart ";
		document.form.current_page.value = "/Advanced_ACL_Content.asp";
		document.form.next_page.value = "";
		document.form.submit();
	}
	else
		return false;
}

function change_mac_enabled(){
	if (document.form.wl_macmode.value == "disabled"){
		$("ACLList_Block").style.display = "none";
	} else {
		$("ACLList_Block").style.display = "";
	}
}

function prevent_lock(){
	if(document.form.wl_macmode.value == "allow"){
		if(document.form.wl_macnum_x_0.value < 1){
			if(confirm("<#FirewallConfig_MFList_accept_hint1#>")){
				document.form.wl_maclist_x_0.value = smac[0] + smac[1] + smac[2] + smac[3] + smac[4] + smac[5];
				document.form.wl_macdesc_x_0.value = "";
				markGroupACL(document.form.ACLList2, 32, ' Add ');
				document.form.submit();
			}
			else
				return false;
		}
		else
			return true;
	}
	else
		return true;
}

function setClientMAC(num){
	document.form.wl_maclist_x_0.value = clients_info[num][2];
	document.form.wl_macdesc_x_0.value = clients_info[num][0];
	hideClients_Block();
}

function showLANIPList(){
	var code = "";
	var show_name = "";
	
	for(var i = 0; i < clients_info.length ; i++){
		if(clients_info[i][3] != 10)
			continue;
		
		if(clients_info[i][0] && clients_info[i][0].length > 20)
			show_name = clients_info[i][0].substring(0, 18) + "..";
		else
			show_name = clients_info[i][0];
		
		if(clients_info[i][2]){
			code += '<a href="javascript:void(0)"><div onclick="setClientMAC('+i+');"><strong>'+clients_info[i][1]+'</strong>';
			code += ' ['+clients_info[i][2]+']';
			if(show_name && show_name.length > 0)
				code += ' ('+show_name+')';
			code += ' </div></a>';
		}
	}
	if (code == "")
		code = '<div style="text-align: center;" onclick="hideClients_Block();"><#Nodata#></div>';
	code +='<!--[if lte IE 6.5]><iframe class="hackiframe2"></iframe><![endif]-->';	
	$("ClientList_Block").innerHTML = code;
}

function hideClients_Block(){
	$j("#chevron").text("v");
	$('ClientList_Block').style.display='none';
	isMenuopen = 0;
}

function pullLANIPList(obj){
	if(isMenuopen == 0){
		$j(obj).text("^");
		$("ClientList_Block").style.display = 'block';
		document.form.wl_maclist_x_0.focus();
		isMenuopen = 1;
	}
	else
		hideClients_Block();
}

function validNewRow(max_rows) {
	if (document.form.wl_macnum_x_0.value >= max_rows){
		alert("<#JS_itemlimit1#> " + max_rows + " <#JS_itemlimit2#>");
		return false;
	}

	if (document.form.wl_maclist_x_0.value==""){
		alert("<#JS_fieldblank#>");
		document.form.wl_maclist_x_0.focus();
		document.form.wl_maclist_x_0.select();
		return false;
	}

	if (!validate_hwaddr(document.form.wl_maclist_x_0)){
		return false;
	}

	var mac_lower = document.form.wl_maclist_x_0.value.toLowerCase();

	for(i=0; i<ACLList.length; i++){
		if(mac_lower==ACLList[i][0].toLowerCase()) {
			alert('<#JS_duplicate#>' + ' (MAC: ' + ACLList[i][0] + ')' );
			document.form.wl_maclist_x_0.focus();
			document.form.wl_maclist_x_0.select();
			return false;
		}
	}

	return true;
}

function markGroupACL(o, c, b) {
	document.form.group_id.value = "ACLList";
	if(b == " Add "){
		if (validNewRow(c) == false)
			return false;
	}
	pageChanged = 0;
	document.form.action_mode.value = b;
	return true;
}

function showACLList(){
	var code = '';
	if(ACLList.length == 0) {
		code +='<tr><td colspan="3" style="text-align: center;"><div class="alert alert-info"><#IPConnection_VSList_Norule#></div></td></tr>';
	}
	else{
	    for(var i = 0; i < ACLList.length; i++){
		code +='<tr id="row' + i + '">';
		code +='<td width="35%">&nbsp;' + ACLList[i][0] + '</td>';
		code +='<td width="60%">&nbsp;' + ACLList[i][1] + '</td>';
		code +='<td width="5%" style="text-align: center;"><input type="checkbox" name="ACLList_s" value="' + i + '" onClick="changeBgColor(this,' + i + ');" id="check' + i + '"></td>';
		code +='</tr>';
	    }
		code += '<tr>';
		code += '<td colspan="2">&nbsp;</td>'
		code += '<td><button class="acl_button acl_delete" type="submit" onclick="return markGroupACL(this, 32, \' Del \');" name="ACLList">-</button></td>';
		code += '</tr>'
	}
	$j('#ACLList_Block').append(code);
}

function changeBgColor(obj, num){
	$("row" + num).style.background=(obj.checked)?'#D9EDF7':'whiteSmoke';
}

function done_validating(action){
	refreshpage();
}

</script>
<style>
.table-list td {
    padding: 6px 8px;
}
.table-list input,
.table-list select {
    margin-top: 0px;
    margin-bottom: 0px;
}
	.acl_input {
		width: 175px;
		box-sizing: border-box;
	}
	.acl_desc {
		width: 100%;
		box-sizing: border-box;
	}
	.acl_button {
		display: inline-block;
		padding: 3px 8px;
		color: #FFFFFF;
		background: #596e74;
		border: 1px solid #6b8fa3;
		cursor: pointer;
	}
	.acl_delete {
		background: #8a3b3b;
		border-color: #b94a48;
	}
</style>
</head>

<body onload="initial();" class="bg">
    <div id="TopBanner"></div>

    <div id="Loading" class="popup_bg"></div>

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

    <form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
    <input type="hidden" name="current_page" value="Advanced_ACL_Content.asp">
    <input type="hidden" name="next_page" value="Advanced_WSecurity_Content.asp">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="DeviceSecurity11a;">
    <input type="hidden" name="group_id" value="ACLList">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="">

    <input type="hidden" name="wl_macnum_x_0" value="<% nvram_get_x("", "wl_macnum_x"); %>" readonly="1" />

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
                                            <div class="formfonttitle"><#menu5_1#> - <#menu5_1_4#> (5GHz)</div>
                                            <div style="margin:10px 0 10px 5px;" class="splitLine"></div>
                                            <div class="formfontdesc"><#DeviceSecurity11a_display1_sectiondesc#></div>

                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr>
                                            <th width="50%" style="border-top: 0 none;">
                                                <a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,4,1);"><#FirewallConfig_MFMethod_itemname#></a>
                                            </th>
                                            <td style="border-top: 0 none;">
                                                <select name="wl_macmode" class="input" onchange="change_mac_enabled();">
                                                    <option value="disabled" <% nvram_match_x("","wl_macmode", "disabled","selected"); %>><#CTL_Disabled#></option>
                                                    <option value="allow" <% nvram_match_x("","wl_macmode", "allow","selected"); %>><#FirewallConfig_MFMethod_item1#></option>
                                                    <option value="deny" <% nvram_match_x("","wl_macmode", "deny","selected"); %>><#FirewallConfig_MFMethod_item2#></option>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>

                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable table-list" id="ACLList_Block" style="margin-top:10px;">
                                        <tr>
                                            <th colspan="3" style="background-color: #E3E3E3;"><#FirewallConfig_MFList_groupitemname#></th>
                                        </tr>
                                        <tr>
                                            <th width="35%"><#FirewallConfig_MFhwaddr_itemname#></th>
                                            <th width="60%"><#WIFIMacDesc#></th>
                                            <th width="5%">&nbsp;</th>
                                        </tr>
                                        <tr>
                                            <td width="35%">
                                                <div id="ClientList_Block" class="ddown-list" style="width: 400px;"></div>
                                                <div>
                                                    <input type="text" maxlength="12" class="acl_input" size="12" name="wl_maclist_x_0" value="<% nvram_get_x("", "wl_maclist_x_0"); %>" onKeyPress="return is_hwaddr(event);"/>
                                                    <button class="acl_button" id="chevron" type="button" onclick="pullLANIPList(this);" title="Select the MAC of WiFi clients">v</button>
                                                </div>
                                            </td>
                                            <td width="60%">
                                                <input type="text" maxlength="32" class="acl_desc" size="32" name="wl_macdesc_x_0" value="<% nvram_get_x("", "wl_macdesc_x_0"); %>" onKeyPress="return is_string(this,event);" />
                                            </td>
                                            <td width="5%">
                                                <button class="acl_button" style="max-width: 219px" type="submit" onclick="return markGroupACL(this, 32, ' Add ');" name="ACLList2" value="<#CTL_add#>" size="12">+</button>
                                            </td>
                                        </tr>
                                    </table>

                                            <div class="apply_gen">
                                                <input class="button_gen" type="button" value="<#GO_2G#>" onclick="location.href='Advanced_ACL2g_Content.asp';">
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
