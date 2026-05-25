<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_3_5#></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/index_style.css">
<link rel="stylesheet" type="text/css" href="/form_style.css">
<link rel="stylesheet" type="text/css" href="/other.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/merlin_adapter.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script>
var $j = jQuery.noConflict();

$j(document).ready(function() {
	init_itoggle('sp_battle_ips');
});
</script>

<script>

var ipmonitor = [<% get_static_client(); %>];
var wireless = {<% wl_auth_list(); %>};

var clients_info = getclients(0,0);

var isMenuopen = 0;

function initial(){
	var id_menu = 4;
	if(!support_ipv6())
		id_menu--;

	show_banner(1);
	show_menu(5,4,id_menu);
	show_footer();

	showLANIPList();

	load_body();
}

function applyRule(){
	if(validForm()){
		showLoading();
		
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "/Advanced_Exposed_Content.asp";
		document.form.next_page.value = "";
		
		document.form.submit();
	}
}

function validForm(){
	if(!validate_ipaddr_final(document.form.dmz_ip, 'dmz_ip'))
		return false;

	return true;
}

function setClientIP(num){
	document.form.dmz_ip.value = clients_info[num][1];
	hideClients_Block();
}

function showLANIPList(){
	var code = "";
	var show_name = "";
	
	for(var i = 0; i < clients_info.length ; i++){
		if(clients_info[i][0] && clients_info[i][0].length > 20)
			show_name = clients_info[i][0].substring(0, 18) + "..";
		else
			show_name = clients_info[i][0];
		
		if(clients_info[i][1]){
			code += '<a href="javascript:void(0)"><div onclick="setClientIP('+i+');"><strong>'+clients_info[i][1]+'</strong>';
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

function pullLANIPList(obj){
	
	if(isMenuopen == 0){
		$j(obj).children('i').removeClass('icon-chevron-down').addClass('icon-chevron-up');
		$("ClientList_Block").style.display = 'block';
		document.form.dmz_ip.focus();
		isMenuopen = 1;
	}
	else
		hideClients_Block();
}

function hideClients_Block(){
	$j("#chevron").children('i').removeClass('icon-chevron-up').addClass('icon-chevron-down');
	$('ClientList_Block').style.display='none';
	isMenuopen = 0;
}

function done_validating(action){
	refreshpage();
}
</script>
<style>
.alert {
	padding: 8px 10px;
	margin: 10px 0;
	border: 1px solid #6b8fa3;
	color: #FFFFFF;
	background: #596e74;
}
.btn {
	display: inline-block;
	padding: 3px 8px;
	color: #FFFFFF;
	background: #596e74;
	border: 1px solid #6b8fa3;
	cursor: pointer;
}
.input-append {
	display: flex;
	align-items: center;
}
.ddown-list {
	position: absolute;
	z-index: 50;
}
</style>
</head>
<body onload="initial();" onunLoad="return unload_body();" class="bg">
<div id="TopBanner"></div>

<div id="Loading" class="popup_bg"></div>

<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="current_page" value="Advanced_Exposed_Content.asp">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="next_host" value="">
<input type="hidden" name="sid_list" value="IPConnection;PPPConnection;">
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
                                            <div class="formfonttitle"><#menu5_3#> - <#menu5_3_5#></div>
                                            <div style="margin:10px 0 10px 5px;" class="splitLine"></div>
                                            <div class="formfontdesc"><#IPConnection_ExposedIP_sectiondesc#></div>

                                            <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr>
                                            <th width="50%"><#IPConnection_ExposedIP_itemname#></th>
                                            <td>
                                                <div id="ClientList_Block" class="alert alert-info ddown-list"></div>
                                                <div class="input-append">
                                                    <input type="text" maxlength="15" class="input" size="15" name="dmz_ip" value="<% nvram_get_x("","dmz_ip"); %>" onkeypress="return is_ipaddr(this,event);" style="float:left; width: 175px"/>
                                                    <button class="btn btn-chevron" id="chevron" type="button" onclick="pullLANIPList(this);" title="Select the IP of LAN clients."><i class="icon icon-chevron-down"></i></button>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                            <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="margin-top:10px;">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;"><#IPConnection_BattleNet_sectionname#></th>
                                        </tr>
                                        <tr>
                                            <td colspan="2"><div class="alert alert-info" style="margin: 2px;"><#IPConnection_BattleNet_sectiondesc#></div></td>
                                        </tr>
                                        <tr>
                                            <th width="50%"><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,7,21);"><#IPConnection_BattleNet_itemname#></a></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="sp_battle_ips_on_of">
                                                        <input type="checkbox" id="sp_battle_ips_fake" <% nvram_match_x("", "sp_battle_ips", "1", "value=1 checked"); %><% nvram_match_x("", "sp_battle_ips", "0", "value=0"); %> />
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" name="sp_battle_ips" id="sp_battle_ips_1" <% nvram_match_x("", "sp_battle_ips", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" value="0" name="sp_battle_ips" id="sp_battle_ips_0" <% nvram_match_x("", "sp_battle_ips", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                            <div class="apply_gen">
                                                <input name="button" type="button" class="button_gen" onclick="applyRule();" value="<#CTL_apply#>">
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
