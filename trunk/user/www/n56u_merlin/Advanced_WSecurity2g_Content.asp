<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_1_5#></title>
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
<script type="text/javascript" src="/wireless_2g.js"></script>
<script type="text/javascript" src="/help_wl.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script>
var $j = jQuery.noConflict();

function initial(){
	show_banner(1);
	show_menu(5,1,5);
	show_footer();

	if (!support_5g_radio()){
		document.form.goto5.style.display = "none";
		$("col_goto5").width = "33%";
	}
}

function applyRule(){
	if(validForm()){
		showLoading();
		
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "/Advanced_WSecurity2g_Content.asp";
		document.form.next_page.value = "";
		
		document.form.submit();
	}
}

function validForm(){
	if(!validate_ipaddr_final(document.form.rt_radius_ipaddr, 'radius_ipaddr'))
		return false;

	if(!validate_range(document.form.rt_radius_port, 0, 65535))
		return false;

	if(!validate_string(document.form.rt_radius_key))
		return false;

	return true;
}

function done_validating(action){
	refreshpage();
}
</script>
<style>
	.password_toggle {
		margin-left: -5px;
		padding: 3px 8px;
		color: #FFFFFF;
		background: #596e74;
		border: 1px solid #6b8fa3;
		cursor: pointer;
	}
</style>
</head>

<body onload="initial();" onunLoad="return unload_body();" class="bg">
    <div id="TopBanner"></div>

    <div id="Loading" class="popup_bg"></div>

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
    <form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
    <input type="hidden" name="current_page" value="Advanced_WSecurity2g_Content.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="WLANAuthentication11b;WLANConfig11b;">
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
                                            <div class="formfonttitle"><#menu5_1#> - <#t2RADIUS#> (2.4GHz)</div>
                                            <div style="margin:10px 0 10px 5px;" class="splitLine"></div>
                                            <div class="formfontdesc"><#WLANAuthentication11a_display1_sectiondesc#></div>

                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr>
                                            <th width="50%" style="border-top: 0 none;"><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,2,1);"><#WLANAuthentication11a_ExAuthDBIPAddr_itemname#></a></th>
                                            <td width="50%" style="border-top: 0 none;">
                                                <input type="text" maxlength="15" class="input" size="15" name="rt_radius_ipaddr" value="<% nvram_get_x("","rt_radius_ipaddr"); %>" onKeyPress="return is_ipaddr(this,event);" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);"  onmouseover="openTooltip(this,2,2);"><#WLANAuthentication11a_ExAuthDBPortNumber_itemname#></a></th>
                                            <td>
                                                <input type="text" maxlength="5" class="input" size="5" name="rt_radius_port" value="<% nvram_get_x("","rt_radius_port"); %>" onkeypress="return is_number(this,event);" onblur="return validate_portrange(this, '');"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);"  onmouseover="openTooltip(this,2,3);"><#WLANAuthentication11a_ExAuthDBPassword_itemname#></a></th>
                                            <td>
                                                <div>
                                                    <input type="password" name="rt_radius_key" id="rt_radius_key" maxlength="64" size="32" style="width: 175px;" value="<% nvram_get_x("","rt_radius_key"); %>" />
                                                    <button class="password_toggle" type="button" onclick="passwordShowHide('rt_radius_key')">...</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                            <div class="apply_gen">
                                                <input class="button_gen" type="button" name="goto5" value="<#GO_5G#>" onclick="location.href='Advanced_WSecurity_Content.asp';">
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
