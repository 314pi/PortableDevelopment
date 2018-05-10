/* -*- Mode: Java; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* ***** BEGIN LICENSE BLOCK *****
 * Version: NPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Netscape Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/NPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is mozilla.org code.
 *
 * The Initial Developer of the Original Code is 
 * Netscape Communications Corporation.
 * Portions created by the Initial Developer are Copyright (C) 1998-2000
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or 
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the NPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the NPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

pref("editor.author",                        "");

pref("editor.use_custom_colors",             false);
pref("editor.text_color",                    "#000000");
pref("editor.link_color",                    "#0000FF");
pref("editor.active_link_color",             "#000088");
pref("editor.followed_link_color",           "#FF0000");
pref("editor.background_color",              "#FFFFFF");
pref("editor.use_background_image",          false);
pref("editor.default_background_image",      "");
pref("editor.use_custom_default_colors",     1);

pref("editor.hrule.height",                  2);
pref("editor.hrule.width",                   100);
pref("editor.hrule.width_percent",           true);
pref("editor.hrule.shading",                 true);
pref("editor.hrule.align",                   1); // center

pref("editor.table.maintain_structure",      true);

pref("editor.prettyprint",                   false); // Kaze
pref("editor.htmlWrapColumn",                72);

pref("editor.throbber.url","chrome://editor-region/locale/region.properties");

pref("editor.toolbars.showbutton.new",       true);
pref("editor.toolbars.showbutton.open",      true);
pref("editor.toolbars.showbutton.save",      true);
pref("editor.toolbars.showbutton.publish",   true);
pref("editor.toolbars.showbutton.preview",   true);
pref("editor.toolbars.showbutton.cut",       false);
pref("editor.toolbars.showbutton.copy",      false);
pref("editor.toolbars.showbutton.paste",     false);
pref("editor.toolbars.showbutton.print",     true);
pref("editor.toolbars.showbutton.find",      false);
pref("editor.toolbars.showbutton.image",     true);
pref("editor.toolbars.showbutton.hline",     false);
pref("editor.toolbars.showbutton.table",     true);
pref("editor.toolbars.showbutton.link",      true);
pref("editor.toolbars.showbutton.namedAnchor", false);
pref("editor.toolbars.showbutton.form",      true);

pref("editor.toolbars.showbutton.bold",      true);
pref("editor.toolbars.showbutton.italic",    true);
pref("editor.toolbars.showbutton.underline", true);
pref("editor.toolbars.showbutton.DecreaseFontSize", true);
pref("editor.toolbars.showbutton.IncreaseFontSize", true);
pref("editor.toolbars.showbutton.ul",        true);
pref("editor.toolbars.showbutton.ol",        true);
pref("editor.toolbars.showbutton.outdent",   true);
pref("editor.toolbars.showbutton.indent",    true);

pref("editor.auto_save",                     false);
pref("editor.auto_save_delay",               10);    // minutes
pref("editor.use_html_editor",               0);
pref("editor.html_editor",                   "");
pref("editor.use_image_editor",              0);
pref("editor.image_editor",                  "");

pref("editor.singleLine.pasteNewlines",      1);

pref("editor.history.url_maximum",           10);

pref("editor.quotesPreformatted",            false);

pref("editor.publish.",                      "");
pref("editor.lastFileLocation.image",        "");
pref("editor.lastFileLocation.html",         "");
pref("editor.use_css",                       true);
pref("editor.css.default_length_unit",       "px");
pref("editor.save_associated_files",         false); // Kaze
pref("editor.always_show_publish_dialog",    false);

/*
 * What are the entities that you want Mozilla to save using mnemonic
 * names rather than numeric codes? E.g. if set, we'll output &nbsp;
 * otherwise, we may output 0xa0 depending on the charset.
 *
 * "none"   : don't use any entity names; only use numeric codes.
 * "basic"  : use entity names just for &nbsp; &amp; &lt; &gt; &quot; for 
 *            interoperability/exchange with products that don't support more
 *            than that.
 * "latin1" : use entity names for 8bit accented letters and other special
 *            symbols between 128 and 255.
 * "html"   : use entity names for 8bit accented letters, greek letters, and
 *            other special markup symbols as defined in HTML4.
 */
//~ pref("editor.encode_entity",                 "html");
pref("editor.encode_entity",                 "basic"); // Kaze (note that ' is NOT output as &quot)
pref("editor.encode.noGT",                   false);
pref("editor.encode.noEscaping",             false);

pref("editor.grid.snap",                     false);
pref("editor.grid.size",                     0);
pref("editor.resizing.preserve_ratio",       true);
pref("editor.positioning.offset",            0);

pref("editor.CR_creates_new_p",              true);
pref("editor.zoom_factor",                   "1.0");


/***********************************************\
 *                                             *
 *     KompoZer specific preferences           *
 *                                             *
\***********************************************/

pref("tipoftheday.openAtStartup",                true);

// Help Menu                                  
pref("editor.site.url",                          "chrome://editor-region/locale/region.properties");
pref("editor.faq.url",                           "chrome://editor-region/locale/region.properties");
pref("editor.devorg.url",                        "chrome://editor-region/locale/region.properties");
pref("editor.forums.url",                        "chrome://editor-region/locale/region.properties");
pref("editor.bugReports.url",                    "chrome://editor-region/locale/region.properties");
pref("editor.support.url",                       "chrome://editor-region/locale/region.properties");
pref("editor.L10N.url",                          "chrome://editor-region/locale/region.properties");
pref("editor.CCuserGuide.url",                   "chrome://editor-region/locale/region.properties");
pref("editor.aboutLinspire.url",                 "chrome://editor-region/locale/region.properties");
pref("editor.aboutDI.url",                       "chrome://editor-region/locale/region.properties");

// New Page Settings                          
pref("editor.custom_language",                   "");
pref("editor.custom_direction",                  "none");
pref("editor.custom_charset",                    "ISO-8859-1");
pref("editor.table.default_align",               "");
pref("editor.table.default_valign",              "");
pref("editor.table.default_wrapping",            "");
pref("editor.table.default_cellspacing",         2);
pref("editor.table.default_cellpadding",         2);

// Default Doctype                            
pref("editor.default.doctype",                   "html");
pref("editor.default.strictness",                true); // Kaze

// Spell Checker
pref("spellchecker.enablerealtimespell",         false);
pref("spellchecker.realtimespell.warning_color", "orange");
pref("editor.showDisableSpellCheckWarning",      true);

// Helper Applications
//@line 184 "/cygdrive/c/mozilla/kompozer/composer/app/profile/editor.js"
pref("editor.helpers.browser.useSystem",         true);
//@line 186 "/cygdrive/c/mozilla/kompozer/composer/app/profile/editor.js"
pref("editor.helpers.text.useSystem",            true);
pref("editor.helpers.image.useSystem",           true);
pref("editor.helpers.media.useSystem",           true);
pref("editor.helpers.file.useSystem",            true);
pref("editor.helpers.ftp.useSystem",             true);

// use the Debian-sensible browser by default (deprecated by helper apps?)
pref("network.protocol-handler.app.http",        "/usr/bin/x-www-browser");
pref("network.protocol-handler.app.https",       "/usr/bin/x-www-browser");
pref("network.protocol-handler.app.ftp",         "/usr/bin/x-www-browser");
pref("network.protocol-handler.app.file",        "/usr/bin/x-www-browser");

// Extensions, Gecko 1.8.1
pref("extensions.getMoreExtensionsURL",          "http://addons.kompozer.net/xpi/");
pref("extensions.getMoreThemesURL",              "http://addons.kompozer.net/jar/");

// CSS Editor                              
pref("extensions.cascades.expertMode",           true);
pref("extensions.cascades.dropdownLists",        true);
pref("layout.css.report_errors",                 false);

// Site Manager                            
pref("extensions.sitemanager.openInNewTab",      true);
pref("extensions.sitemanager.useSystemIcons",    false);
pref("extensions.sitemanager.filter.html",       "htm, html, xhtml, php*");
pref("extensions.sitemanager.filter.css",        "css");
pref("extensions.sitemanager.filter.images",     "ico, jpg, jpeg, png, gif, bmp");
pref("extensions.sitemanager.filter.media",      "ogg, ogm, mpeg, mpg, mp3, mp4, mov, wma, wmv, avi");
pref("extensions.sitemanager.filter.text",       "txt, ht*, js, xml, asp, jsp, inc");

// FireFTP - most of these prefs should be removed
pref("extensions.sitemanager.welcomemode",       false);
pref("extensions.sitemanager.errormode",         true);
pref("extensions.sitemanager.refreshmode",       true);
pref("extensions.sitemanager.passwordmode",      true);
pref("extensions.sitemanager.sessionsmode",      true);
pref("extensions.sitemanager.hiddenmode",        false);
pref("extensions.sitemanager.interfacemode",     0);
pref("extensions.sitemanager.network",           30);
pref("extensions.sitemanager.timeoutmode",       true);
pref("extensions.sitemanager.retry",             10);
pref("extensions.sitemanager.attempts",          40);
pref("extensions.sitemanager.destructmode",      false);
pref("extensions.sitemanager.filemode",          1);
pref("extensions.sitemanager.asciifiles",        "ai,bas,bat,c,cc,cgi,conf,cpp,css,diz,eps,h,htaccess,htm,html,hqx,java,jsp,map,nfo,pas,php,pl,ps,py,rdf,rss,sh,shtml,txt,uue,xml");
pref("extensions.sitemanager.loadmode",          1);
pref("extensions.sitemanager.logmode",           true);
pref("extensions.sitemanager.debugmode",         false);
pref("extensions.sitemanager.bytesmode",         false);
pref("extensions.sitemanager.nopromptmode",      false);
pref("extensions.sitemanager.logerrormode",      false);
pref("extensions.sitemanager.keepalivemode",     true);
pref("extensions.sitemanager.proxytype",         "");
pref("extensions.sitemanager.proxyhost",         "");
pref("extensions.sitemanager.proxyport",         0);
pref("extensions.sitemanager.folder",            "");
pref("extensions.sitemanager.donated",           false);
pref("extensions.sitemanager.loadurl",           "");
pref("extensions.sitemanager.integrateftplinks", false);
pref("extensions.sitemanager.temppasvmode",      true);
pref("extensions.sitemanager.defaultaccount",    "");
pref("extensions.sitemanager.activeportmode",    false);
pref("extensions.sitemanager.activelow",         1);
pref("extensions.sitemanager.activehigh",        65535);
pref("extensions.sitemanager.timestampsmode",    false);

