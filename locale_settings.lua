module(..., package.seeall)
debug.ReloadScripts.allowReload(..., true)
local thisModule = _M

-- NOTE: The native names here may appear buggy, because they are in UTF-8, but they are just fine.
-- This is the list of all known languages (note, not all of these are supported for all purposes, such as for audio purposes).
-- Languages per build or per platform are defined in: initLanguagesPerPlatformOrBuild()
all_languages = 
{
	{ id = "en", nativeName = "English", englishName = "English", audioName = "english_us_/" }
	, { id = "de", nativeName = "Deutsch", englishName = "German", audioName = "german/" }
	, { id = "fr", nativeName = "Français", englishName = "French", audioName = "french_france_/" }
	, { id = "es", nativeName = "Español", englishName = "Spanish", audioName = "spanish_spain_/" }
	, { id = "it", nativeName = "Italiano", englishName = "Italian", audioName = "italian/" }
	, { id = "ru", nativeName = "Русский", englishName = "Russian", audioName = "russian/", useCompatibilityFont = false, useCompatibilityFont2 = false }
	, { id = "ja", nativeName = "日本語", englishName = "Japanese", audioName = "japanese/", useCompatibilityFont = true, useCompatibilityFont2 = true }
	, { id = "zh", nativeName = "简体中文", englishName = "Chinese (Simplified)", audioName = "chinese_s/", useCompatibilityFont = true, useCompatibilityFont2 = true }
}

-- list of supported gui langugages
all_guiLocaleLanguages = 
{
	"en"
	, "de"
	, "fr"
	, "es"
	, "it"
	, "ru"
	, "ja"
	, "zh"
}

-- list of supported subtitling langugages
all_subtitleLocaleLanguages = 
{
	"en"
	, "de"
	, "fr"
	, "es"
	, "it"
	, "ru"
	, "ja"
	, "zh"
}
	
-- list of supported audio langugages
all_audioLanguages = 
{
	"en"
}

languages = { };
guiLocaleLanguages = { };
subtitleLocaleLanguages = { };
audioLanguages = { };

declareReload(thisModule, [[all_languages]])
declareReload(thisModule, [[all_guiLocaleLanguages]])
declareReload(thisModule, [[all_subtitleLocaleLanguages]])
declareReload(thisModule, [[all_audioLanguages]])

declareReload(thisModule, [[languages]])
declareReload(thisModule, [[guiLocaleLanguages]])
declareReload(thisModule, [[subtitleLocaleLanguages]])
declareReload(thisModule, [[audioLanguages]])

function initLanguagesPerPlatformOrBuild()

	local useAllAvailableLanguages = false;
	
	-- Use "en" always as default if nothing else is defined
	local tmplanguages =					{ "en"}
	local tmpguiLocaleLanguages =			{ "en"}
	local tmpsubtitleLocaleLanguages =		{ "en"}
	local tmpaudioLanguages =				{ "en"}
	
	-- Clear old ones
	languages = { };
	guiLocaleLanguages = { };
	subtitleLocaleLanguages = { };
	audioLanguages = { };
	
	if FB_BUILD == "FB_FINAL_RELEASE" then
		-- Steam and non-steam has all languages
		tmplanguages =					{"en", "de", "fr", "es", "it", "ru", "ja", "zh"}
		tmpguiLocaleLanguages =			{"en", "de", "fr", "es", "it", "ru", "ja", "zh"}
		tmpsubtitleLocaleLanguages =	{"en", "de", "fr", "es", "it", "ru", "ja", "zh"}
		tmpaudioLanguages =				{"en"}
	else
		-- If not final release, just use all available languages. E.g. in Editor we want to be able to configure all languages
		useAllAvailableLanguages = true;
	end
	
	if useAllAvailableLanguages then
		-- Use all languages which are defined into all_ tables
		languages = all_languages;
		guiLocaleLanguages = all_guiLocaleLanguages;
		subtitleLocaleLanguages = all_subtitleLocaleLanguages;
		audioLanguages = all_audioLanguages;
	else
		-- Add all desired languages
		for i, lang in ipairs(all_languages) do
			for i, tmplang in ipairs(tmplanguages) do
				if lang.id == tmplang then
					table.insert(languages, lang);
				end
			end
		end
		
		guiLocaleLanguages = tmpguiLocaleLanguages;
		subtitleLocaleLanguages = tmpsubtitleLocaleLanguages;
		audioLanguages = tmpaudioLanguages;
	end
end

function tableHasEntry(t, v)
	for i=#t,1,-1 do
		if(t[i] == v) then
			return true
		end
	end
	return false	
end

function addLocalePatches()
	-- Init languages
	initLanguagesPerPlatformOrBuild();
	
	-- Language patches
	for i = 0,localeModule:getLocalePatchAmount()-1 do
		local localePatchInfoString = localeModule:getLocalePatchInfo(i)
		if (localePatchInfoString ~= "") then		
			localeModule:applyLocalePatchInfo(localePatchInfoString)
			if (_G.localePatchTemp) then
				local loc = _G.localePatchTemp
				if (type(loc) == "table") then
					if (type(loc.id) == "string"
						and type(loc.supportGui) == "boolean"
						and type(loc.supportSubtitle) == "boolean"
						and type(loc.supportAudio) == "boolean") 
					then
						table.insert(languages, loc)
						if (loc.supportGui and not tableHasEntry(guiLocaleLanguages, loc.id)) then
							table.insert(guiLocaleLanguages, loc.id)
						end
						if (loc.supportSubtitle and not tableHasEntry(subtitleLocaleLanguages, loc.id)) then
							table.insert(subtitleLocaleLanguages, loc.id)
						end
						if (loc.supportAudio and not tableHasEntry(audioLanguages, loc.id)) then
							table.insert(audioLanguages, loc.id)							
						end
					else
						logger:error("Locale patch info does not contain proper id or information about supported locale banks.")
					end
				else
					logger:error("Malformed locale patch info (non lua table data).")
				end
			else
				logger:error("Malformed locale patch info (probably a parse error).")
			end
		else
			logger:warning("Empty locale patch info encountered.")
		end
	end
	_G.localePatchTemp = nil
end

function load()
	-- Init languages
	initLanguagesPerPlatformOrBuild();

	-- Languages
	for i = 1,#languages do
		local useCompatibilityFont = false
		local useCompatibilityFont2 = false
		if (languages[i].useCompatibilityFont) then useCompatibilityFont = true end
		if (languages[i].useCompatibilityFont2) then useCompatibilityFont2 = true end
		-- (done like this for backward compatibility between different script<->executables) 
		if (useCompatibilityFont2) then
			localeModule:addLanguageExtended(languages[i].id, languages[i].nativeName, languages[i].englishName, languages[i].audioName, 2)
		else
			localeModule:addLanguage(languages[i].id, languages[i].nativeName, languages[i].englishName, languages[i].audioName, useCompatibilityFont)
		end
	end
	
	-- Setup GUI locales
	--
	localeModule:addLocaleBank("gui", "GuiLanguage")
	for i = 1,#guiLocaleLanguages do
		localeModule:addSupportedLanguageToBank("gui", guiLocaleLanguages[i])
	end
	
	-- Setup subtitle locales
	--
	localeModule:addLocaleBank("subtitles", "SubtitleLanguage")
	for i = 1,#subtitleLocaleLanguages do
		localeModule:addSupportedLanguageToBank("subtitles", guiLocaleLanguages[i])
	end
	
	-- Setup audio locales
	--
	localeModule:addLocaleBank("audio", "AudioLanguage")
	for i = 1,#audioLanguages do
		localeModule:addSupportedLanguageToBank("audio", guiLocaleLanguages[i])
	end
end

