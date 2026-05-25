<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_7_5#></title>
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
function initial(){
	show_banner(1);
	show_menu(5,10,3);
	show_footer();
}
</script>
<style>
.status_log_area {height:403px;}
</style>
</head>

<body onload="initial();" class="bg">
    <div id="TopBanner"></div>

    <div id="Loading" class="popup_bg"></div>

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

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
                                                <div class="formfonttitle"><#menu5_7#> - <#menu5_7_5#></div>
                                                <div style="margin:10px 0 10px 5px;" class="splitLine"></div>

                                                <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                                    <tr>
                                                        <td>
                                                            <textarea rows="23" class="status_log_area" readonly="readonly" wrap="off"><% nvram_dump("iptable.log",""); %></textarea>
                                                        </td>
                                                    </tr>
                                                </table>

                                                <div class="apply_gen">
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

    <div id="footer"></div>
</body>
</html>
