<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_7_2#></title>
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

$j(document).ready(function(){
	var textArea = E('textarea');
	textArea.scrollTop = textArea.scrollHeight;
});

function initial(){
	show_banner(2);
	show_menu(5,10,1);
	show_footer();

	showclock();
}

function showclock(){
	JS_timeObj.setTime(systime_millsec);
	systime_millsec += 1000;
	JS_timeObj2 = JS_timeObj.toString();
	JS_timeObj2 = JS_timeObj2.substring(0,3) + ", " +
	              JS_timeObj2.substring(4,10) + "  " +
				  checkTime(JS_timeObj.getHours()) + ":" +
				  checkTime(JS_timeObj.getMinutes()) + ":" +
				  checkTime(JS_timeObj.getSeconds()) + "  " +
				  JS_timeObj.getFullYear() + " GMT" +
				  timezone;
	$("system_time").innerHTML = JS_timeObj2;
	setTimeout("showclock()", 1000);
}

function clearLog(){
	document.form.next_host.value = location.host;
	document.form.action_mode.value = " ClearLog ";
	document.form.submit();
}
</script>
<style>
.status_log_area {
	width: 100%;
	height: 377px;
	box-sizing: border-box;
	font-family: "Courier New", Courier, mono;
	font-size: 13px;
	background: #111;
	color: #EEE;
	border: 1px solid #6b8fa3;
}
.status_time {
	display: inline-block;
	margin-left: 10px;
	padding: 4px 8px;
	color: #FFF;
	background: #2f3d42;
	border: 1px solid #6b8fa3;
}
</style>
</head>

<body onload="initial();" class="bg">
    <div id="TopBanner"></div>

    <div id="Loading" class="popup_bg"></div>

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
    <form method="post" name="form" action="apply.cgi" class="form_thin">
    <input type="hidden" name="current_page" value="Main_LogStatus_Content.asp">
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
                                                <div class="formfonttitle"><#menu5_7#> - <#menu5_7_2#></div>
                                                <div style="margin:10px 0 10px 5px;" class="splitLine"></div>

                                                <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                                    <tr>
                                                        <th><#General_x_SystemTime_itemname#></th>
                                                        <td><span class="status_time" id="system_time"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <textarea rows="21" class="status_log_area" readonly="readonly" wrap="off" id="textarea"><% nvram_dump("syslog.log",""); %></textarea>
                                                        </td>
                                                    </tr>
                                                </table>

                                                <div class="apply_gen">
                                                    <input type="submit" onClick="clearLog();" value="<#CTL_clear#>" class="button_gen">
                                                    <input type="button" onClick="location.href='syslog.txt'" value="<#CTL_onlysave#>" class="button_gen">
                                                    <input type="button" onClick="location.href=location.href" value="<#CTL_refresh#>" class="button_gen">
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
