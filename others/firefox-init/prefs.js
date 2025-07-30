// custom tweaks
user_pref("ui.key.menuAccessKeyFocuses", false); // disable alt menu
user_pref("widget.use-xdg-desktop-portal.file-picker", 1); // use correct file picker

// ui tweaks
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org"); // set dark theme
user_pref("browser.tabs.inTitlebar", 0); // use native title bar
user_pref("browser.translations.automaticallyPopup", false); // no popups for translation
user_pref("browser.tabs.hoverPreview.showThumbnails", false); // disable image preview on tab hover
user_pref("browser.toolbars.bookmarks.visibility", "always"); // always show bookmarks
user_pref("sidebar.revamp.defaultLauncherVisible", false); // disable horizontal tabs icon
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"urlbar-container\",\"customizableui-special-spring2\",\"downloads-button\",\"unified-extensions-button\",\"ublock0_raymondhill_net-browser-action\",\"addon_darkreader_org-browser-action\",\"sponsorblocker_ajay_app-browser-action\",\"plasma-browser-integration_kde_org-browser-action\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"screenshot-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\",\"unified-extensions-area\"],\"currentVersion\":23,\"newElementCount\":3}");

// disable first run page
user_pref("startup.homepage_welcome_url", ""); 
user_pref("startup.homepage_welcome_url.additional", ""); 
user_pref("datareporting.policy.firstRunURL", "");
user_pref("datareporting.policy.dataSubmissionPolicyAcceptedVersion", 2);
user_pref("datareporting.policy.dataSubmissionPolicyNotifiedTime", "9000000000000");
user_pref("browser.startup.homepage_override.mstone", "141.0");

// disable bloat on new tab pages
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.startup.homepage", "about:home");

// passwords
user_pref("signon.rememberSignons", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

// safety / privacy
user_pref("network.trr.mode", 3); // maximum DNS safety possible
user_pref("dom.security.https_only_mode", true); 
user_pref("dom.security.https_only_mode_ever_enabled", true);
user_pref("browser.contentblocking.category", "custom"); 
user_pref("privacy.fingerprintingProtection", true);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("privacy.globalprivacycontrol.was_ever_enabled", true);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.usage.uploadEnabled", false);
