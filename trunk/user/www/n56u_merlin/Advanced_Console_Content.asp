<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_6_6#></title>
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
<script type="text/javascript" src="/popup.js"></script>
<script>
var $j = jQuery.noConflict();

<% login_state_hook(); %>

function initial(){
	show_banner(1);
	show_menu(5,7,6);
	show_footer();

	if (!login_safe()){
		$j('#btn_exec').attr('disabled', 'disabled');
		$j('#SystemCmd').attr('disabled', 'disabled');
	}else
		document.form.SystemCmd.focus();
}

function getResponse(){
	$j.get('/console_response.asp', function(data){
		var response = ($j.browser.msie && !is_ie11p) ? data.nl2br() : data;
		$j("#console_area").text(response);
		$j('#btn_exec').removeAttr('disabled');
	});
}

function startPost(){
	if (!login_safe())
		return false;
	$j('#btn_exec').attr('disabled', 'disabled');
	$j.post('/apply.cgi',
	{
		'action_mode': ' SystemCmd ',
		'current_page': 'console_response.asp',
		'next_page': 'console_response.asp',
		'SystemCmd': $j('#SystemCmd').val()
	},
	function(response){
		getResponse();
	});
}

function clearOut(){
	$j('#console_area').html('');
	$j('#SystemCmd').val('');
}

function checkEnter(e){
	e = e || event;
	return (e.keyCode || event.which || event.charCode || 0) === 13;
}
</script>
<style>
	.console_input,
	.console_area {
		width: 100%;
		box-sizing: border-box;
	}
	.console_area {
		font-family: "Courier New", Courier, monospace;
		font-size: 13px;
	}
	.console_button {
		width: 100%;
		display: inline-block;
		padding: 3px 8px;
		color: #FFFFFF;
		background: #596e74;
		border: 1px solid #6b8fa3;
		cursor: pointer;
	}
</style>
</head>

<body onLoad="initial();" class="bg">
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>
    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

    <form method="post" name="form" action="apply.cgi" onkeypress="return !checkEnter(event)">
    <input type="hidden" name="current_page" value="">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="">
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
                                            <div class="formfonttitle"><#menu5_6#> - <#menu5_6_6#></div>
                                            <div style="margin:10px 0 10px 5px;" class="splitLine"></div>
                                            <div class="formfontdesc"><#Console_warn#></div>

                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr>
                                            <td width="80%" style="border-top: 0 none"><input type="text" id="SystemCmd" class="console_input" name="SystemCmd" maxlength="127" onkeypress="if (checkEnter(event)) startPost();" value=""></td>
                                            <td style="border-top: 0 none"><input class="console_button" id="btn_exec" onClick="startPost()" type="button" value="<#CTL_refresh#>" name="action"></td>
                                            <td style="border-top: 0 none"><button class="console_button" onClick="clearOut();" type="button" value="<#CTL_refresh#>" name="action" style="outline: 0">X</button></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" style="border-top: 0 none">
                                                <textarea class="console_area" id="console_area" rows="23" wrap="off" readonly="1"><% nvram_dump("syscmd.log","syscmd.sh"); %></textarea>
                                            </td>
                                        </tr>
                                    </table>
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
