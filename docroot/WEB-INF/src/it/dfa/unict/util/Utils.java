package it.dfa.unict.util;

import it.dfa.unict.AppPreferences;

import com.liferay.portal.kernel.json.JSONFactoryUtil;

public class Utils {

	public static AppPreferences getAppPreferences(String JSONAppPrefs) {
		AppPreferences appPreferences = new AppPreferences();

		if (JSONAppPrefs != null && !JSONAppPrefs.equals(""))
			appPreferences = JSONFactoryUtil.looseDeserialize(JSONAppPrefs,
					AppPreferences.class);

		return appPreferences;
	}

}
