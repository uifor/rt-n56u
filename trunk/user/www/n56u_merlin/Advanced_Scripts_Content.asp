<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_10_2#></title>
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
<script>

<% login_state_hook(); %>

function initial(){
	show_banner(1);
	show_menu(5,8,2);
	show_footer();

	if (!login_safe())
		textarea_scripts_enabled(0);

	if (get_ap_mode()){
		showhide_div('row_post_wan_script', 0);
		showhide_div('row_post_iptables_script', 0);
	}
}

function textarea_scripts_enabled(v){
	inputCtrl(document.form['scripts.start_script.sh'], v);
	inputCtrl(document.form['scripts.started_script.sh'], v);
	inputCtrl(document.form['scripts.shutdown_script.sh'], v);
	inputCtrl(document.form['scripts.post_wan_script.sh'], v);
	inputCtrl(document.form['scripts.post_iptables_script.sh'], v);
	inputCtrl(document.form['scripts.ez_buttons_script.sh'], v);
}

function applyRule(){
	if(validForm()){
		showLoading();
		
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "/Advanced_Scripts_Content.asp";
		document.form.next_page.value = "";
		
		document.form.submit();
	}
}

function validForm(){
	return true;
}

function done_validating(action){
	refreshpage();
}

</script>
<style>
	.script_textarea {
		width: 100%;
		box-sizing: border-box;
		font-family: "Courier New";
		font-size: 12px;
	}
</style>
</head>

<body onload="initial();" onunLoad="return unload_body();" class="bg">
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
    <form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">

    <input type="hidden" name="current_page" value="Advanced_Scripts_Content.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="General;">
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
                                            <div class="formfonttitle"><#menu5_10#> - <#menu5_10_2#></div>
                                            <div style="margin:10px 0 10px 5px;" class="splitLine"></div>
                                            <div class="formfontdesc"><#Scripts_desc#></div>

                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr>
                                            <th style="background-color: #E3E3E3;"><#UserScripts#></th>
                                        </tr>
                                        <tr>
                                            <td>
                                                <a href="javascript:spoiler_toggle('script0')"><span><#RunPreStart#></span></a>
                                                <div id="script0" style="display:none;">
                                                    <textarea rows="24" wrap="off" spellcheck="false" maxlength="4096" class="script_textarea" name="scripts.start_script.sh"><% nvram_dump("scripts.start_script.sh",""); %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <a href="javascript:spoiler_toggle('script1')"><span><#RunPostStart#></span></a>
                                                <div id="script1" style="display:none;">
                                                    <textarea rows="24" wrap="off" spellcheck="false" maxlength="8192" class="script_textarea" name="scripts.started_script.sh"><% nvram_dump("scripts.started_script.sh",""); %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <a href="javascript:spoiler_toggle('script5')"><span><#RunShutdown#></span></a>
                                                <div id="script5" style="display:none;">
                                                    <textarea rows="24" wrap="off" spellcheck="false" maxlength="4096" class="script_textarea" name="scripts.shutdown_script.sh"><% nvram_dump("scripts.shutdown_script.sh",""); %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="row_post_wan_script">
                                            <td>
                                                <a href="javascript:spoiler_toggle('script2')"><span><#RunPostWAN#></span></a>
                                                <div id="script2" style="display:none;">
                                                    <textarea rows="24" wrap="off" spellcheck="false" maxlength="8192" class="script_textarea" name="scripts.post_wan_script.sh"><% nvram_dump("scripts.post_wan_script.sh",""); %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="row_post_iptables_script">
                                            <td>
                                                <a href="javascript:spoiler_toggle('script3')"><span><#RunPostFWL#></span></a>
                                                <div id="script3" style="display:none;">
                                                    <textarea rows="24" wrap="off" spellcheck="false" maxlength="8192" class="script_textarea" name="scripts.post_iptables_script.sh"><% nvram_dump("scripts.post_iptables_script.sh",""); %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding-bottom: 0px;">
                                                <a href="javascript:spoiler_toggle('script4')"><span><#RunEzBtns#></span></a>
                                                <div id="script4" style="display:none;">
                                                    <textarea rows="24" wrap="off" spellcheck="false" maxlength="4096" class="script_textarea" name="scripts.ez_buttons_script.sh"><% nvram_dump("scripts.ez_buttons_script.sh",""); %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                            <div class="apply_gen">
                                                <input class="button_gen" onclick="applyRule();" type="button" value="<#CTL_apply#>">
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
