# About Opie Masque

This addon enables [Masque](https://github.com/SFX-WoW/Masque) ([CurseForge](https://www.curseforge.com/wow/addons/masque), [Wago](https://addons.wago.io/addons/masque), [WoWInterface](https://wowinterface.com/downloads/info12097-Masque.html)) to skin [OPie](https://www.townlong-yak.com/addons/opie) ([CurseForge](https://www.curseforge.com/wow/addons/opie), [WoWInterface](https://wowinterface.com/downloads/info9094-OPie.html)) rings.  An up-to-date version of both Masque and OPie are required for it to work.

You can install this addon from [CurseForge](https://www.curseforge.com/wow/addons/opie-masque-revived "CurseForge"), [Wago](https://addons.wago.io/addons/opiemasque), or [WoWInterface](https://wowinterface.com/downloads/info26505-OPieMasque.html).

## Configuration and Features

OPie Masque registers as a skin for OPie and should support any skin compatible with Masque.  When no other OPie skins are installed, OPie Masque should become the default skin automatically.  If not, you can change the skin from the OPie addon settings panel under the Appearance section.  You can then choose a Masque skin you have installed from the Masque Skin Settings panel for the OPie group or globally.

Recharge and cooldown numbers are handled by WoW natively in Retail, Wrath Classic, and Cataclysm Classic, and they will appear on OPie automatically assuming the following conditions are met:

* You are running the Retail, Wrath Classic, or Cataclysm Classic version of the game
* The WoW option Action Bars > "Show Numbers for Cooldowns" is enabled
* The OPie options "Show cooldown numbers" or "Show recharge numbers" are enabled (according to your preference)

There is currently no option to show the cooldowns in OPie without having them generally enabled for your main Action Bars as well.

There are no separate options for OPie Masque implemented at this time.

## Classic Support

Classic is missing many features from Retail, but OPie and Masque offer full support for Classic, so OPie Masque inherits that support for the most part.  However, "Show cooldown numbers" and "Show recharge numbers" are both unavailable in Classic Era as they rely on built-in functionality from Retail.

If you want this functionality in Classic Era, [OmniCC](https://github.com/tullamods/OmniCC) ([Curseforge](https://www.curseforge.com/wow/addons/omni-cc), [Wago](https://addons.wago.io/addons/omnicc), [WoWInterface](https://www.wowinterface.com/downloads/info4836-OmniCC.html)) should work, though it will not honor OPie's cooldown number options.

I've done limited testing with Classic Era, Wrath Classic, and Cataclysm Classic because I don't play them, but I believe everything should work.  If you report bugs or submit patches, I'll do my best to address them.

## Special Thanks

Thanks to [StormFX](https://github.com/StormFX), the author of Masque, for a ton of feedback and development tips and for creating a logo for the addon.

Thanks to [Phanx](https://github.com/phanx-wow), the original author of OPie Masque.

## Licensing Information

This code has been forked with permission from the original author Phanx who no longer plays WoW.  The code was listed with a proprietary license in its original location, but has been changed to the more permissive MIT license with permission.
