# Merlin Web UI Port Plan

This project currently ships the Padavan/N56U Bootstrap-based UI from `trunk/user/www/n56u_ribbon_fixed`. The target visual reference is ASUSWRT-Merlin's UI in `/Volumes/rt-n56u-work/asuswrt-merlin.ng-main/release/src/router/www`.

The port should not replace the current `www` tree wholesale. Merlin's UI depends on a much larger backend and frontend surface: `httpApi.js`, `form.js`, `validator.js`, `isSupport()`, many `nvram_get()` calls, and hundreds of model/function-specific pages. Current firmware pages use the older `show_menu(L1, L2, L3)` flow, Bootstrap 2 classes, `nvram_get_x()`, and Padavan-specific pages.

## Current Baseline

- Current web root: `trunk/user/www/n56u_ribbon_fixed`
- Merlin reference root: `/Volumes/rt-n56u-work/asuswrt-merlin.ng-main/release/src/router/www`
- Current top-level ASP pages: see `docs/webui-merlin-inventory/current-asp.txt`
- Pages with Merlin namesake templates: see `docs/webui-merlin-inventory/common-asp.txt`
- Padavan-specific pages requiring manual styling: see `docs/webui-merlin-inventory/current-only-asp.txt`

Run the inventory with:

```sh
sh tools/webui_merlin_inventory.sh
```

## Strategy

1. Build the Merlin-style UI in a separate web root, `trunk/user/www/n56u_merlin`, and keep `n56u_ribbon_fixed` usable until the new shell is viable.
2. Keep current form actions, ASP handlers, nvram names, and feature gates unless a migrated Merlin page clearly requires backend adaptation.
3. Import Merlin shell CSS/assets directly into `n56u_merlin`, but only the files used by the migrated shell and pages.
4. Reuse Padavan's `state.js` capability detection and translated menu arrays through a small Merlin adapter instead of porting Merlin's `httpApi`/session/menuTree stack.
5. Convert high-traffic pages into Merlin's table shell (`TopBanner`, `content`, `mainMenu`, `subMenu`, `tabMenu`, `FormTitle`, `FormTable`, `button_gen`) and then use those pages as templates for batch migration.
6. Avoid importing unsupported Merlin-only features such as AiMesh, AiProtection, AdaptiveQoS, ROG/UI4, SDN, and model-specific sysdep pages unless backend support is added later.

## Current Prototype

- Prototype web root: `trunk/user/www/n56u_merlin`
- Default build remains `n56u_ribbon_fixed`; build the prototype with `make -C trunk/user/www WEBUI_NAME=n56u_merlin romfs`.
- Core Merlin CSS copied into the prototype: `index_style.css`, `form_style.css`, `NM_style.css`, `other.css`.
- Slim shell assets copied into `images/` and `images/New_ui/`; the prototype is about 3.3M rather than Merlin's 83M web tree.
- `merlin_adapter.js` overrides `show_banner()`, `show_menu(L1, L2, L3)`, and `show_footer()` for migrated pages while preserving Padavan menu arrays and feature pruning.
- Migrated form pages: `Advanced_LAN_Content.asp`, `Advanced_DHCP_Content.asp`, `Advanced_Wireless_Content.asp`, `Advanced_WAN_Content.asp`, `Advanced_DDNS_Content.asp`, `Advanced_System_Content.asp`, `Advanced_GWStaticRoute_Content.asp`, `Advanced_VirtualServer_Content.asp`, `Advanced_Exposed_Content.asp`, `Advanced_BasicFirewall_Content.asp`, `Advanced_Firewall_Content.asp`, `Advanced_Netfilter_Content.asp`, `Advanced_URLFilter_Content.asp`, and `Advanced_MACFilter_Content.asp`. They now use the Merlin page shell and `FormTable`, but still submit the original Padavan fields to `/start_apply.htm`.
- `index.asp` now uses a lightweight Merlin Network Map layout (`NM_table`, `NM_radius_*`, Merlin network-map icons) instead of the old Padavan `big-icons` column. The status iframe and device data still use the current rt-n56u `device-map/*.asp` pages, so visual migration can continue without requiring Merlin's `httpApi.js`, `networkmapd`, AiMesh, dual-WAN, or client-edit backend stack.
- The Network Map iframe pages now use a shared lightweight `device-map/merlin-status.css` style layer. This covers `router.asp`, `router2g.asp`, `internet.asp`, `intranet.asp`, `clients.asp`, `disk.asp`, `hub.asp`, `sata.asp`, `printer.asp`, and `modem.asp`, removing Bootstrap's main CSS/JS from their visible panel chrome while preserving existing rt-n56u status, apply, refresh, USB, printer, modem, and block/unblock logic.

## Phases

### Phase 1: Visual Shell

- Add a separate `n56u_merlin` web root.
- Copy the current web root as backend-compatible baseline, then remove duplicated experimental assets.
- Import Merlin shell CSS and the minimal image set needed by the shell.
- Add `merlin_adapter.js` for banner/menu/footer rendering.

### Phase 2: Pilot Pages

Convert these pages first:

- `Advanced_LAN_Content.asp` (done as first prototype)
- `index.asp` (Merlin Network Map shell and icons, rt-n56u status iframes retained)
- `Advanced_Wireless_Content.asp` (Merlin shell/FormTable, original wireless validation retained)
- `Advanced_WAN_Content.asp` (Merlin shell/FormTable, original WAN/IPTV/VLAN validation retained)
- `Advanced_DHCP_Content.asp` (Merlin shell/FormTable, original DHCP/static lease list retained)
- `Advanced_DDNS_Content.asp` (Merlin shell/FormTable, original provider list and update flow retained)
- `Advanced_System_Content.asp` (Merlin shell/FormTable, original admin/time/log/help controls retained)
- `Advanced_GWStaticRoute_Content.asp` (Merlin shell/FormTable, original static route validation and list management retained)
- `Advanced_VirtualServer_Content.asp` (Merlin shell/FormTable, original port-forwarding presets, client picker, rule splitting, and list management retained)
- `Advanced_Exposed_Content.asp` (Merlin shell/FormTable, original DMZ client picker and BattleNet passthrough switch retained)
- `Advanced_Firewall_Content.asp` (Merlin shell/FormTable, original LAN/WAN filter schedule, protocol wizard, and list management retained)
- `Advanced_Netfilter_Content.asp` (Merlin shell/FormTable, original NAT, conntrack, passthrough, and ALG controls retained)
- `Advanced_URLFilter_Content.asp` (Merlin shell/FormTable, original schedule, client MAC picker, URL keyword list, and invert option retained)
- `Advanced_MACFilter_Content.asp` (Merlin shell/FormTable, original MAC client picker, schedule controls, drop mode, and list management retained)
- Network Map iframe panels (shared Merlin-style status chrome, original rt-n56u device-map backend retained)

The conversion should retain current JavaScript validation and hidden form fields while changing markup toward Merlin's `FormTitle`, `FormTable`, `button_gen`, `submenuBlock`, and network map visual language.

### Phase 3: Common Pages

For files listed in `common-asp.txt`, compare against the Merlin namesake page and port only the structure and styling that is compatible with the current backend.

### Phase 4: Current-Only Pages

For files listed in `current-only-asp.txt`, apply the finalized pilot page structure manually. These pages are project-specific and cannot be copied from Merlin:

- Scripts, tweaks, console, and services pages
- Shadowsocks, dns-forwarder, mentohust, scutclient pages
- Current VPN client/server pages
- Padavan status and log pages

### Phase 5: Backend Compatibility

Only add backend ASP handlers when the UI truly needs them. Prefer frontend shims or removing unsupported UI branches over porting Merlin's full `httpd` stack.

## Verification

- Run `sh tools/webui_merlin_inventory.sh` after adding or removing ASP pages.
- Run `make -C trunk/user/www WEBUI_NAME=n56u_merlin romfs` or the project firmware build target to verify packaging.
- Inspect `trunk/romfs/www` after packaging to ensure the selected `n56u_merlin` files are present and feature pruning has not deleted required files.
- Browser-check login, index, LAN, WAN, wireless, system, firmware upgrade, reboot, and one current-only feature page.
