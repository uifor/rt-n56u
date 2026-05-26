<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_6_1#></title>
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
var $j = jQuery.noConflict();

function initial(){
	show_banner(2);
	show_menu(5,7,3);
	show_footer();

	if(sw_mode == '1' || sw_mode == '3'){
		showhide_div('wl_rt', 1);
		showhide_div('rt_wo_nat', 0);
	}else if(sw_mode == '4'){
		showhide_div('wl_rt', 0);
		showhide_div('rt_wo_nat', 1);
	}

	setScenerion(sw_mode);

	var o1 = document.form.sw_mode;
	var vd = support_btn_mode();
	o1[0].disabled = vd;
	o1[1].disabled = vd;
	o1[2].disabled = vd;
	document.form.button.disabled = vd;
}

function saveMode(){
	var o1 = document.form.sw_mode;
	if(sw_mode == '1'){
		if(o1[0].checked == true){
			alert("<#op_already_configured#>");
			return false;
		}
	}else if(sw_mode == '4'){
		if(o1[1].checked == true){
			alert("<#op_already_configured#>");
			return false;
		}
	}else if(sw_mode == '3'){
		if(o1[2].checked == true){
			alert("<#op_already_configured#>");
			return false;
		}
	}

	showLoading();

	document.form.action_mode.value = " Apply ";
	document.form.current_page.value = "Advanced_OperationMode_Content.asp";
	document.form.next_page.value = "";

	document.form.submit();
}

function done_validating(action){
	refreshpage();
}

function setScenerion(mode){
	if(mode == '1' || mode == '4'){
		$j("#radio2").hide();
		$j("#Internet_span").css("display", "");
		$j("#ap-line").css("display", "none");
		$j(".AP").hide();
		$j("#mode_desc").html("<#OP_GW_desc1#> <#OP_GW_desc2#>");
		$j("#nextButton").attr("value","<#CTL_next#>");
	}
	else if(mode == '3'){
		$j("#radio2").css("display", "none");
		$j("#Internet_span").css("display", "");
		$j("#ap-line").css("display", "none");
		$j(".AP").show();
		$j("#mode_desc").html("<#OP_AP_desc1#> <#OP_AP_desc2#>");
		$j("#nextButton").attr("value","<#CTL_next#>");
	}
}

</script>

<style>
#Senario table {width: 100%;}
#Senario table td {text-align: center;}
#Senario .scenario-icons td {
	height: 78px;
	vertical-align: middle;
}
.op-icon {
	position: relative;
	display: inline-block;
	width: 54px;
	height: 54px;
	box-sizing: border-box;
	border: 1px solid #6b8fa3;
	border-radius: 8px;
	background: linear-gradient(#31454c 0%, #1e2e34 100%);
	box-shadow: inset 0 1px 0 rgba(255,255,255,0.12), 0 1px 2px rgba(0,0,0,0.35);
}
.op-icon:before,
.op-icon:after,
.op-link:before,
.op-link:after {
	content: "";
	position: absolute;
	box-sizing: border-box;
}
.op-clients:before {
	left: 11px;
	top: 14px;
	width: 14px;
	height: 14px;
	border: 2px solid #d7e7ee;
	border-radius: 50%;
	box-shadow: 17px 0 0 -2px #d7e7ee;
}
.op-clients:after {
	left: 8px;
	top: 31px;
	width: 38px;
	height: 10px;
	border: 2px solid #d7e7ee;
	border-top: 0;
	border-radius: 0 0 12px 12px;
}
.op-router:before {
	left: 10px;
	top: 18px;
	width: 34px;
	height: 20px;
	border: 2px solid #9ed3ea;
	border-radius: 5px;
}
.op-router:after {
	left: 15px;
	top: 25px;
	width: 4px;
	height: 4px;
	border-radius: 50%;
	background: #9ed3ea;
	box-shadow: 9px 0 0 #9ed3ea, 18px 0 0 #9ed3ea;
}
.op-ap:before {
	left: 15px;
	top: 13px;
	width: 24px;
	height: 28px;
	border: 2px solid #d7e7ee;
	border-radius: 5px;
}
.op-ap:after {
	left: 25px;
	top: 7px;
	width: 4px;
	height: 11px;
	background: #d7e7ee;
	box-shadow: -8px 9px 0 -1px #d7e7ee, 8px 9px 0 -1px #d7e7ee;
}
.op-internet {
	border-radius: 50%;
}
.op-internet:before {
	left: 12px;
	top: 12px;
	width: 30px;
	height: 30px;
	border: 2px solid #d7e7ee;
	border-radius: 50%;
}
.op-internet:after {
	left: 14px;
	top: 25px;
	width: 26px;
	height: 2px;
	background: #d7e7ee;
	box-shadow: 0 -8px 0 -1px #d7e7ee, 0 8px 0 -1px #d7e7ee;
}
.op-link {
	position: relative;
	display: inline-block;
	width: 54px;
	height: 54px;
}
.op-link:before {
	left: 7px;
	top: 26px;
	width: 40px;
	height: 2px;
	background: #9ed3ea;
}
.op-link:after {
	left: 8px;
	top: 20px;
	width: 13px;
	height: 13px;
	border-left: 2px solid #9ed3ea;
	border-bottom: 2px solid #9ed3ea;
	transform: rotate(45deg);
}
.alert {
	padding: 8px 10px;
	margin: 10px 0;
	border: 1px solid #6b8fa3;
	color: #FFFFFF;
	background: #596e74;
}
.label {
	display: inline-block;
	padding: 4px 7px;
	color: #FFFFFF;
	background: #596e74;
}
.label-info {
	background: #2f769b;
}
.radio.inline {
	display: inline-block;
	margin-right: 16px;
}
</style>

</head>

<body onload="initial();" onunLoad="return unload_body();" class="bg">
<div id="TopBanner"></div>

<div id="Loading" class="popup_bg"></div>

<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="sid_list" value="IPConnection;">
<input type="hidden" name="group_id" value="">
<input type="hidden" name="action_mode" value="">
<input type="hidden" name="prev_page" value="">
<input type="hidden" name="current_page" value="/Advanced_OperationMode_Content.asp">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="flag" value="">
<input type="hidden" name="lan_ipaddr" value="<% nvram_get_x("", "lan_ipaddr"); %>">

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
											<div class="formfonttitle"><#menu5_6#> - <#t2OP#></div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
											<div style="margin-left: 10px; margin-top: 10px;">
	                                            <div class="controls">
	                                                <label class="radio inline"><div id="wl_rt" style="display:none;"><input type="radio" name="sw_mode" class="input" value="1" onclick="setScenerion(1);" <% nvram_match_x("IPConnection", "sw_mode", "1", "checked"); %>><#OP_GW_item#></div></label>
	                                                <label class="radio inline"><div id="rt_wo_nat" style="display:none;"><input type="radio" name="sw_mode" class="input" value="4" onclick="setScenerion(4);" <% nvram_match_x("IPConnection", "sw_mode", "4", "checked"); %>><#OP_GW_item#></div></label>
                                                <label class="radio inline"><div id="wl_ap"><input type="radio" name="sw_mode" class="input" value="3" onclick="setScenerion(3);" <% nvram_match_x("IPConnection", "sw_mode", "3", "checked"); %>><#OP_AP_item#></div></label>
                                            </div>

                                            <div id="mode_desc" style="margin-left: 0px; margin-top: 10px; margin-right: 10px;" class="alert alert-info"><#OP_GW_desc1#></div>
                                        </div>

                                        <div style="margin-top: 10px; margin-right: 10px; margin-left: 10px;">
                                            <center><div id="Senario" class="span12" style="height: 170px;">
                                                <div>
                                                    <table style="width: 100%">
                                                        <tr>
                                                            <td><span class="label"><#Wireless_Clients#></span></td>
                                                            <td>&nbsp;</td>
                                                            <td><span class="label label-info"><#Web_Title#></span></td>
                                                            <td class="AP">&nbsp;</td>
                                                            <td class="AP"><span class="label"><#Device_type_02_RT#></span></td>
                                                            <td>&nbsp;</td>
                                                            <td id="Internet_span"><span class="label"><#Internet#></span></td>
                                                        </tr>
                                                        <tr class="scenario-icons">
                                                            <td><span class="op-icon op-clients"></span></td>
                                                            <td><span class="op-link"></span></td>
                                                            <td><span class="op-icon op-router"></span></td>
                                                            <td class="AP"><span class="op-link"></span></td>
                                                            <td class="AP"><span class="op-icon op-ap"></span></td>
                                                            <td><span class="op-link"></span></td>
                                                            <td><span class="op-icon op-internet"></span></td>
                                                        </tr>
                                                    </table>
                                                </div>

                                                <div id="ap-line" style="display: none;position: absolute; margin-left: -10000px"></div>
                                            </div></center>
                                        </div>

	                                        <div class="apply_gen">
	                                            <input name="button" type="button" class="button_gen" onClick="saveMode();" value="<#CTL_onlysave#>">
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
