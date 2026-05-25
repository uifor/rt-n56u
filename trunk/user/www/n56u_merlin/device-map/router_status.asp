<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="merlin-status.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="formcontrol.js"></script>
<script>
<% wanlink(); %>
<% lanlink(); %>

var $j = jQuery.noConflict();
var id_update_wan = 0;
var id_update_lan = 0;
var last_bytes_rx = 0;
var last_bytes_tx = 0;
var last_time = 0;
var cpu_usage_history = [];
var ram_usage_history = [];
var net_rx_history = [];
var net_tx_history = [];

window.performance = window.performance || {};
performance.now = (function() {
	return performance.now ||
		performance.mozNow ||
		performance.msNow ||
		performance.oNow ||
		performance.webkitNow ||
		function() { return new Date().getTime(); };
})();

function initial(){
	prepare_router_tabs();
	show_router_status();
	update_wan_status();
	update_lan_status();
	get_system_info();
}

function prepare_router_tabs(){
	if(support_2g_radio())
		$j("#wireless_tab").attr("onclick", "location.href='router2g.asp'");
	else if(support_5g_radio())
		$j("#wireless_tab").attr("onclick", "location.href='router.asp'");
	else
		$j("#wireless_tab").hide();
}

function clampPercent(value){
	value = parseInt(value, 10);
	if(isNaN(value) || value < 0)
		return 0;
	if(value > 100)
		return 100;
	return value;
}

function bytesToIEC(bytes, precision){
	var absval = Math.abs(bytes);
	var kilobyte = 1024;
	var megabyte = kilobyte * 1024;
	var gigabyte = megabyte * 1024;
	var terabyte = gigabyte * 1024;

	if (absval < kilobyte)
		return bytes + ' B';
	else if (absval < megabyte)
		return (bytes / kilobyte).toFixed(precision) + ' KB';
	else if (absval < gigabyte)
		return (bytes / megabyte).toFixed(precision) + ' MB';
	else if (absval < terabyte)
		return (bytes / gigabyte).toFixed(precision) + ' GB';
	else
		return (bytes / terabyte).toFixed(precision) + ' TB';
}

function kbitsToRate(kbits, precision){
	var absval = Math.abs(kbits);
	var megabit = 1000;
	var gigabit = megabit * 1000;

	if (absval < megabit)
		return kbits + ' Kbps';
	else if (absval < gigabit)
		return (kbits / megabit).toFixed(precision) + ' Mbps';
	else
		return (kbits / gigabit).toFixed(precision) + ' Gbps';
}

function updateBar(id, percent){
	percent = clampPercent(percent);
	$j("#" + id).css("width", percent + "%");
	$j("#" + id + "_text").html(percent + "%");
}

function pushHistory(arr, value){
	arr.push(clampPercent(value));
	if(arr.length > 46)
		arr.shift();
}

function drawHistory(svgId, histories, classes){
	var svg = document.getElementById(svgId);
	if(!svg)
		return;

	var width = 260;
	var height = 82;
	var code = '';
	var i;

	for(i = 0; i <= 4; i++){
		var y = Math.round(i * height / 4) + 0.5;
		code += '<line class="status-grid-line" x1="0" y1="' + y + '" x2="' + width + '" y2="' + y + '"></line>';
	}
	for(i = 0; i <= 8; i++){
		var x = Math.round(i * width / 8) + 0.5;
		code += '<line class="status-grid-line" x1="' + x + '" y1="0" x2="' + x + '" y2="' + height + '"></line>';
	}

	for(var h = 0; h < histories.length; h++){
		var arr = histories[h];
		if(!arr.length)
			continue;

		var points = [];
		for(i = 0; i < arr.length; i++){
			var px = arr.length == 1 ? width : i * (width / (arr.length - 1));
			var py = height - (arr[i] * height / 100);
			points.push(px.toFixed(1) + ',' + py.toFixed(1));
		}
		code += '<polyline class="' + classes[h] + '" points="' + points.join(' ') + '"></polyline>';
	}

	svg.innerHTML = code;
}

function show_router_status(){
	var arrLA = sysinfo.lavg.split(' ');
	var h = sysinfo.uptime.hours < 10 ? ('0' + sysinfo.uptime.hours) : sysinfo.uptime.hours;
	var m = sysinfo.uptime.minutes < 10 ? ('0' + sysinfo.uptime.minutes) : sysinfo.uptime.minutes;
	var usedRam = parseInt(sysinfo.ram.used, 10);
	var totalRam = parseInt(sysinfo.ram.total, 10);
	var freeRam = parseInt(sysinfo.ram.free, 10);
	var ramPercent = totalRam > 0 ? Math.round(usedRam * 100 / totalRam) : 0;

	$j("#la_info").html(arrLA[0] + " / " + arrLA[1] + " / " + arrLA[2]);
	$j("#uptime_info").html(sysinfo.uptime.days + "<#Day#>".substring(0,1) + " " + h + "<#Hour#>".substring(0,1) + " " + m + "<#Minute#>".substring(0,1));
	$j("#ram_used").html(bytesToIEC(usedRam * 1024, 0));
	$j("#ram_free").html(bytesToIEC(freeRam * 1024, 0));
	$j("#ram_total").html(bytesToIEC(totalRam * 1024, 0));
	$j("#ram_cached").html(bytesToIEC(sysinfo.ram.cached * 1024, 0));
	$j("#ram_buffers").html(bytesToIEC(sysinfo.ram.buffers * 1024, 0));
	updateBar("ram_bar", ramPercent);
	pushHistory(ram_usage_history, ramPercent);
	drawHistory("ram_graph", [ram_usage_history], ["history-line ram-line"]);

	if(!support_2g_radio())
		$j("#wifi2_info").hide();
	else
		$j("#wifi2_status").html(parseInt(sysinfo.wifi2.state, 10) > 0 ? "<#CTL_Enabled#>" : "<#CTL_Disabled#>");

	if(!support_5g_radio())
		$j("#wifi5_info").hide();
	else
		$j("#wifi5_status").html(parseInt(sysinfo.wifi5.state, 10) > 0 ? "<#CTL_Enabled#>" : "<#CTL_Disabled#>");
}

function showSystemInfo(cpu_now, force){
	show_router_status();

	if(typeof cpu_now == "object" && typeof cpu_now.busy != "undefined"){
		var busy = clampPercent(cpu_now.busy);
		updateBar("cpu_bar", busy);
		$j("#cpu_busy").html(busy + "%");
		$j("#cpu_user").html(clampPercent(cpu_now.user) + "%");
		$j("#cpu_system").html(clampPercent(cpu_now.system) + "%");
		$j("#cpu_idle").html(clampPercent(cpu_now.idle) + "%");
		pushHistory(cpu_usage_history, busy);
		drawHistory("cpu_graph", [cpu_usage_history], ["history-line cpu-line"]);
	}
}

function fill_wan_traffic(){
	var now = performance.now();
	var rx = typeof(wanlink_bytes_rx) === 'function' ? wanlink_bytes_rx() : 0;
	var tx = typeof(wanlink_bytes_tx) === 'function' ? wanlink_bytes_tx() : 0;
	var diff_rx = 0;
	var diff_tx = 0;

	if(last_time > 0 && now > last_time){
		var diff_time = now - last_time;
		if(rx >= last_bytes_rx)
			diff_rx = Math.floor((rx - last_bytes_rx) * 8 / diff_time);
		if(tx >= last_bytes_tx)
			diff_tx = Math.floor((tx - last_bytes_tx) * 8 / diff_time);
	}

	last_bytes_rx = rx;
	last_bytes_tx = tx;
	last_time = now;

	$j("#net_dl_rate").html(kbitsToRate(diff_rx, 2));
	$j("#net_ul_rate").html(kbitsToRate(diff_tx, 2));
	$j("#net_dl_total").html(bytesToIEC(rx, 2));
	$j("#net_ul_total").html(bytesToIEC(tx, 2));

	var rxPercent = Math.min(100, Math.round(diff_rx / 1000));
	var txPercent = Math.min(100, Math.round(diff_tx / 1000));
	updateBar("net_dl_bar", rxPercent);
	updateBar("net_ul_bar", txPercent);
	pushHistory(net_rx_history, rxPercent);
	pushHistory(net_tx_history, txPercent);
	drawHistory("net_graph", [net_rx_history, net_tx_history], ["history-line net-rx-line", "history-line net-tx-line"]);
}

function update_wan_status(){
	clearTimeout(id_update_wan);

	if(typeof(wanlink_bytes_rx) === 'function')
		fill_wan_traffic();

	$j.ajax({
		url: '/status_wanlink.asp',
		dataType: 'script',
		cache: true,
		complete: function(){
			if(typeof(wanlink_bytes_rx) === 'function')
				fill_wan_traffic();
			id_update_wan = setTimeout("update_wan_status();", 2500);
		}
	});
}

function portLabel(idx){
	return idx === 0 ? "WAN" : "LAN " + idx;
}

function portStatusClass(portText){
	var speed = parseInt(portText, 10);
	if(speed >= 1000)
		return "port-up-fast";
	if(speed > 0)
		return "port-up";
	return "port-down";
}

function show_ports(){
	var rows = "";
	var numPorts = 5;

	if(typeof(support_num_ephy) === "function"){
		numPorts = parseInt(support_num_ephy(), 10);
		if(isNaN(numPorts) || numPorts < 1)
			numPorts = 5;
	}

	for(var i = 0; i < numPorts; i++){
		var portText = "<#CTL_Disabled#>";
		if(typeof(ether_link_status) === "function")
			portText = ether_link_status(i);
		if(portText == "No link")
			portText = "<#CTL_Disabled#>";

		rows += '<div class="display-flex flex-a-center table-body">';
		rows += '<div class="port-block-width table-content table-content-first">' + portLabel(i) + '</div>';
		rows += '<div class="port-block-width table-content"><span class="port-state ' + portStatusClass(portText) + '">' + portText + '</span></div>';
		rows += '</div>';
	}

	$j("#ports_rows").html(rows);
}

function update_lan_status(){
	clearTimeout(id_update_lan);
	show_ports();

	$j.ajax({
		url: '/status_lanlink.asp',
		dataType: 'script',
		cache: true,
		complete: function(){
			show_ports();
			id_update_lan = setTimeout("update_lan_status();", 3000);
		}
	});
}
</script>
</head>

<body class="body_iframe" onload="initial();">
<div class="main-block status-main-block">
	<div class="display-flex flex-a-center">
		<div id="wireless_tab" class="tab-block"><#menu5_1#></div>
		<div id="status_tab" class="tab-block tab-click"><#menu5_7_1#></div>
	</div>

	<div id="net_field" class="unit-block">
		<div class="division-block">Internet Traffic</div>
		<div class="status-row">
			<div class="bar-title">DL</div>
			<div class="bar-container"><div id="net_dl_bar" class="core-color-container net-dl-color"></div></div>
			<div id="net_dl_rate" class="bar-text-width bar-text-percent">--</div>
		</div>
		<div class="status-row">
			<div class="bar-title">UL</div>
			<div class="bar-container"><div id="net_ul_bar" class="core-color-container net-ul-color"></div></div>
			<div id="net_ul_rate" class="bar-text-width bar-text-percent">--</div>
		</div>
		<div class="status-subrow">
			<span>RX <b id="net_dl_total">--</b></span>
			<span>TX <b id="net_ul_total">--</b></span>
		</div>
		<svg id="net_graph" class="svg-block status-graph" viewBox="0 0 260 82" preserveAspectRatio="none"></svg>
	</div>

	<div id="cpu_field" class="unit-block">
		<div class="division-block">CPU</div>
		<div class="status-row">
			<div class="bar-title"><#SI_LoadCPU#></div>
			<div class="bar-container"><div id="cpu_bar" class="core-color-container core-color-0"></div></div>
			<div id="cpu_busy" class="bar-text-width bar-text-percent">--</div>
		</div>
		<div class="status-subrow">
			<span>user <b id="cpu_user">--</b></span>
			<span>system <b id="cpu_system">--</b></span>
			<span>idle <b id="cpu_idle">--</b></span>
		</div>
		<svg id="cpu_graph" class="svg-block status-graph" viewBox="0 0 260 82" preserveAspectRatio="none"></svg>
	</div>

	<div id="ram_field" class="unit-block">
		<div class="division-block">RAM</div>
		<div class="status-subrow status-metrics">
			<span>Used<b id="ram_used">--</b></span>
			<span><#SI_FreeMem#><b id="ram_free">--</b></span>
			<span><#Total#><b id="ram_total">--</b></span>
		</div>
		<div class="status-row">
			<div class="bar-title">&nbsp;</div>
			<div class="bar-container"><div id="ram_bar" class="core-color-container ram-color"></div></div>
			<div id="ram_bar_text" class="bar-text-width bar-text-percent">--</div>
		</div>
		<div class="status-subrow">
			<span>cached <b id="ram_cached">--</b></span>
			<span>buffers <b id="ram_buffers">--</b></span>
			<span>load <b id="la_info">--</b></span>
		</div>
		<svg id="ram_graph" class="svg-block status-graph" viewBox="0 0 260 82" preserveAspectRatio="none"></svg>
	</div>

	<div id="phy_ports" class="unit-block">
		<div class="division-block">Ethernet Ports</div>
		<div class="display-flex flex-a-center table-header">
			<div class="port-block-width table-content">Port</div>
			<div class="port-block-width table-content"><#t2Status#></div>
		</div>
		<div id="ports_rows"></div>
	</div>

	<div id="hw_information_field" class="unit-block">
		<div class="division-block"><#menu5_8#></div>
		<div class="info-block">
			<div class="info-title">Model</div>
			<div class="info-content"><% nvram_get_x("", "productid"); %></div>
		</div>
		<div class="info-block">
			<div class="info-title">Firmware</div>
			<div class="info-content"><% nvram_get_x("", "firmver_sub"); %></div>
		</div>
		<div class="info-block">
			<div class="info-title">LAN IP</div>
			<div class="info-content"><% nvram_get_x("", "lan_ipaddr_t"); %></div>
		</div>
		<div class="info-block">
			<div class="info-title">Uptime</div>
			<div class="info-content" id="uptime_info">--</div>
		</div>
		<div class="info-block" id="wifi2_info">
			<div class="info-title">2.4GHz</div>
			<div class="info-content"><span id="wifi2_status">--</span></div>
		</div>
		<div class="info-block" id="wifi5_info">
			<div class="info-title">5GHz</div>
			<div class="info-content"><span id="wifi5_status">--</span></div>
		</div>
		<div class="button-right">
			<select class="domore" onchange="domore_link(this);">
				<option selected="selected"><#MoreConfig#>...</option>
				<option value="../Advanced_System_Info.asp"><#menu5_8#></option>
				<option value="../Advanced_System_Content.asp"><#menu5_7_1#></option>
				<option value="../Main_EStatus_Content.asp"><#menu5_9#></option>
				<option value="../Main_LogStatus_Content.asp"><#menu5_7_2#></option>
			</select>
		</div>
	</div>
</div>
</body>
</html>
