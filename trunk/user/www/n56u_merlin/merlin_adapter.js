/*
 * Merlin shell adapter for the Padavan web backend.
 *
 * state.js still owns capability detection, translated labels, and menu arrays.
 * This adapter only changes the generated chrome so migrated pages can use the
 * ASUSWRT-Merlin layout without pulling Merlin's session/httpApi menu stack.
 */
(function(){
	var menuIconMap = {
		1: "menu_Index",
		5: "menu_TrafficAnalyzer",
		6: "menu_Log",
		7: "menu_Setting"
	};

	var subMenuIconMap = {
		1: "menu_Wireless",
		2: "menu_Wireless",
		3: "menu_LAN",
		4: "menu_WAN",
		5: "menu_Firewall",
		6: "menu_APP",
		7: "menu_Setting",
		8: "menu_NekworkTool",
		9: "menu_Log",
		10: "menu_Log",
		11: "menu_APP",
		12: "menu_APP",
		13: "menu_APP",
		14: "menu_APP"
	};

	function byId(id){
		return document.getElementById(id);
	}

	function escapeAttr(value){
		return String(value || "").replace(/&/g, "&amp;").replace(/"/g, "&quot;");
	}

	function escapeHtml(value){
		return String(value || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
	}

	function hasPage(url){
		return !!url;
	}

	function renderMenuItem(title, url, iconClass, selected, idPrefix){
		var klass = selected ? "menu menuClicked" : "menu";
		var target = url || "javascript:void(0)";
		var code = '<div class="' + klass + '"';
		if(url)
			code += ' onclick="location.href=\'' + escapeAttr(url) + '\'" title="' + escapeAttr(url) + '"';
		code += ' id="' + idPrefix + '_menu">';
		code += '<table class="merlin-menu-table"><tr><td class="merlin-menu-icon-cell"><div class="menu_Icon ' + iconClass + '"></div></td>';
		code += '<td class="menu_Desc"><a href="' + target + '">' + title + '</a></td></tr></table></div>\n';
		return code;
	}

	function pruneMenus(L1, L2, L3){
		var i;
		var num_ephy = support_num_ephy();
		if(num_ephy < 2)
			num_ephy = 2;
		if(num_ephy > 8)
			num_ephy = 8;

		if(sw_mode == "3"){
			tabtitle[2].splice(3, 1);
			tablink[2].splice(3, 1);
			tabtitle[3].splice(1, 5);
			tablink[3].splice(1, 5);
			tabtitle[4].splice(1, 5);
			tablink[4].splice(1, 5);
			tabtitle[5].splice(4, 1);
			tablink[5].splice(4, 1);
			tabtitle[9].splice(2, 4);
			tablink[9].splice(2, 4);
			tablink[2][1] = "Advanced_APLAN_Content.asp";
			menuL2_link[3] = tablink[2][1];
			menuL2_link[4] = "";
			menuL2_title[4] = "";
			menuL2_link[5] = "";
			menuL2_title[5] = "";

			if(lan_proto == "1"){
				tabtitle[2].splice(2, 1);
				tablink[2].splice(2, 1);
			}
		}
		else{
			if(sw_mode == "4"){
				tablink[3].splice(3, 2);
				tabtitle[3].splice(3, 2);
			}
			if(!support_ipv6()){
				tablink[3].splice(2, 1);
				tabtitle[3].splice(2, 1);
			}
		}

		for(i = 0; i < num_ephy; i++){
			tablink[8][i + 3] = "Main_EStatus_Content.asp#" + i.toString();
			if(i > 0)
				tabtitle[8][i + 3] = "LAN" + i.toString();
		}

		if(num_ephy < 8){
			tabtitle[8].splice(3 + num_ephy, 8 - num_ephy);
			tablink[8].splice(3 + num_ephy, 8 - num_ephy);
		}

		if(!support_2g_radio()){
			menuL2_link[1] = "";
			menuL2_title[1] = "";
			tabtitle[0].splice(1, 6);
			tablink[0].splice(1, 6);
			tabtitle[8].splice(1, 1);
			tablink[8].splice(1, 1);
		}

		if(!support_5g_radio()){
			menuL2_link[2] = "";
			menuL2_title[2] = "";
			tabtitle[1].splice(1, 6);
			tablink[1].splice(1, 6);
			var idx = support_2g_radio() ? 2 : 1;
			tabtitle[8].splice(idx, 1);
			tablink[8].splice(idx, 1);
		}

		if(!support_storage()){
			tabtitle[5].splice(1, 5);
			tablink[5].splice(1, 5);
			menuL2_link[6] = "";
			menuL2_title[6] = "";
		}
		else{
			if(!support_usb()){
				tabtitle[5].splice(4, 2);
				tablink[5].splice(4, 2);
			}
			if(!found_app_smbd() && !found_app_ftpd()){
				tabtitle[5].splice(2, 2);
				tablink[5].splice(2, 2);
			}
			else if(!found_app_smbd()){
				tabtitle[5].splice(2, 1);
				tablink[5].splice(2, 1);
			}
			else if(!found_app_ftpd()){
				tabtitle[5].splice(3, 1);
				tablink[5].splice(3, 1);
			}
		}
	}

	function renderMainMenu(L1, L2){
		var code = '<div class="merlin-leftnav">';
		code += '<div class="m_qis_r merlin-qis-tile"><table class="merlin-menu-table"><tbody><tr>';
		code += '<td class="merlin-menu-icon-cell"><div class="menu_Icon menu_QIS"></div></td>';
		code += '<td class="menu_Desc"><a href="javascript:void(0);"><#QIS#></a></td>';
		code += '</tr></tbody></table></div>';
		code += '<div class="menu_Split menu_Split_general"><table width="192px" height="30px"><tbody><tr><td><#menu5_1_1#></td></tr></tbody></table></div>';
		for(var i = 1; i < menuL1_title.length; i++){
			if(menuL1_title[i] == "")
				continue;
			var selected = (L1 == i && L2 <= 0);
			var icon = menuIconMap[i] || "menu_Setting";
			if(hasPage(menuL1_link[i]))
				code += renderMenuItem(menuL1_title[i], selected ? "" : menuL1_link[i], icon, selected, "level1_" + i);
		}
		code += '<div class="menu_Split"><table width="192px" height="30px"><tbody><tr><td><#menu5#></td></tr></tbody></table></div>';
		return code + "</div>";
	}

	function renderSubMenu(L2){
		var code = '<div class="submenu">';
		for(var i = 1; i < menuL2_title.length; i++){
			if(menuL2_title[i] == "")
				continue;
			code += renderMenuItem(menuL2_title[i], L2 == i ? "" : menuL2_link[i], subMenuIconMap[i] || "menu_Setting", L2 == i, "level2_" + i);
		}
		return code + "</div>";
	}

	function renderTabs(L2, L3){
		if(!L3 || !tabtitle[L2 - 1]){
			byId("tabMenu").innerHTML = "";
			return;
		}

		var code = "";
		for(var i = 1; i < tabtitle[L2 - 1].length; i++){
			if(tabtitle[L2 - 1][i] == "")
				continue;
			var selected = L3 == i;
			var href = selected ? "javascript:void(0)" : tablink[L2 - 1][i];
			if(selected && L2 == 9 && tablink[L2 - 1][i].indexOf("#") > 0)
				href = tablink[L2 - 1][i];
			code += '<a class="' + (selected ? "tabClicked" : "tab") + '" href="' + href + '" id="tab_' + L2 + '_' + i + '">';
			code += '<span>' + tabtitle[L2 - 1][i] + '</span></a>\n';
		}
		byId("tabMenu").innerHTML = code;
	}

	window.show_banner = function(){
		var code = '';
		var product = escapeHtml(window.merlin_productid || "<#Web_Title#>");
		code += '<form method="post" name="titleForm" id="titleForm" action="/start_apply.htm" target="hidden_frame">';
		code += '<input type="hidden" name="current_page" value="">';
		code += '<input type="hidden" name="sid_list" value="LANGUAGE;">';
		code += '<input type="hidden" name="action_mode" value=" Apply ">';
		code += '<input type="hidden" name="preferred_lang" id="preferred_lang" value="' + escapeAttr(window.merlin_preferred_lang || "") + '">';
		code += '<input type="hidden" name="flag" value="">';
		code += '</form>';
		code += '<div class="banner1 merlin-banner" align="center">';
		code += '<img src="images/New_ui/asustitle.png" width="218" height="54" align="left" alt="ASUS">';
		code += '<div class="merlin-model-wrap" align="center"><span id="modelName_top" onclick="this.focus();" class="modelName_top">' + product + '</span></div>';
		code += '<div class="merlin-powered" align="left"><span><a href="https://www.asuswrt-merlin.net/" target="_blank" rel="noreferrer"><img src="images/merlin-logo.png" alt="Powered by Asuswrt-Merlin"></a></span></div>';
		code += '<a href="javascript:logout();"><div class="titlebtn merlin-titlebtn" align="center"><span><#t1Logout#></span></div></a>';
		code += '<a href="javascript:reboot();"><div class="titlebtn merlin-titlebtn merlin-rebootbtn" align="center"><span><#BTN_REBOOT#></span></div></a>';
		code += '<div class="merlin-language"><select id="select_lang" name="select_lang" onchange="submit_language();">';
		code += '<option value="EN">English</option><option value="CN">Chinese</option><option value="TW">Traditional</option><option value="JP">Japanese</option><option value="RU">Russian</option>';
		code += '</select></div>';
		code += '</div>';
		code += '<div class="statusBar minup_bg merlin-statusbar">';
		code += '<div class="merlin-status-inner">';
		code += '<div class="merlin-status-text">';
		code += '<div class="titledown"><span id="operation_mode_title">Operation Mode</span><span>:</span><span class="title_link" style="text-decoration:none;" id="op_link"><a href="/Advanced_OperationMode_Content.asp" style="color:white"><span id="sw_mode_span" style="text-decoration:underline;"></span></a></span>';
		code += '<span>Firmware:</span><a href="/Advanced_FirmwareUpgrade_Content.asp" style="color:white;"><span id="firmver" class="title_link"></span></a>';
		code += '<span id="ssidTitle">SSID:<span onclick="go_setting(2)" title="2.4GHz" id="elliptic_ssid_2g" class="title_link"></span><span onclick="go_setting(5)" title="5GHz" id="elliptic_ssid_5g" class="title_link"></span></span></div>';
		code += '</div>';
		code += '<div id="status_block" class="merlin-status-icons">';
		code += '<div id="wifi_hw_sw_status" class="wifihwswstatusoff merlin-status-icon" title="<#menu5_1#>" onclick="location.href=\'Advanced_Wireless2g_Content.asp\'"></div>';
		code += '<div id="guestnetwork_status" class="guestnetworkstatusoff merlin-status-icon" title="<#menu5_1_2#>" onclick="location.href=\'Advanced_WGuest2g_Content.asp\'"></div>';
		code += '<div id="connect_status" class="connectstatusoff merlin-status-icon" title="<#statusTitle_Internet#>" onclick="location.href=\'/index.asp?flag=Internet\'"></div>';
		code += '<div id="usb_status" class="usbstatusoff merlin-status-icon" title="<#menu5_4#>" onclick="location.href=\'Advanced_AiDisk_others.asp\'"></div>';
		code += '</div>';
		code += '</div></div>';
		byId("TopBanner").innerHTML = code;

		show_loading_obj();
		if(typeof show_top_status == "function")
			show_top_status();
	};

	window.show_menu = function(L1, L2, L3){
		pruneMenus(L1, L2, L3);
		if(document.body)
			document.body.className = document.body.className.replace(/\bmerlin-form-page\b/g, "").replace(/\s+/g, " ").replace(/^\s+|\s+$/g, "");
		byId("mainMenu").innerHTML = renderMainMenu(L1, L2);
		byId("subMenu").innerHTML = renderSubMenu(L2);
		renderTabs(L2, L3);
		if(document.body && byId("tabMenu") && byId("tabMenu").className.indexOf("submenuBlock") >= 0 && !(L1 == 1 && L2 <= 0))
			document.body.className += (document.body.className ? " " : "") + "merlin-form-page";
	};

	window.show_footer = function(){
		byId("footer").innerHTML = '<div align="center" class="bottom-image"></div><div align="center" class="copyright"><#footer_copyright_desc#></div>';
		flash_button();
	};
})();
