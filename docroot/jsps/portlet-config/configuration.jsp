<%-- 
    Document   : edit.jsp
    Created on : Feb 15, 2016, 10:08:35 AM
    Author     : mario
--%>

<%@page import="com.liferay.portal.kernel.util.FileUtil"%>
<%@page import="com.liferay.portal.kernel.util.ListUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="it.dfa.unict.AppPreferences"%>
<%@page import="it.dfa.unict.util.Constants"%>
<%@page import="it.dfa.unict.util.Utils"%>
<%@page import="it.dfa.unict.WRFPortlet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@include file="../../init.jsp"%>

<%
	PortletPreferences preferences = null;

	String portletResource = ParamUtil.getString(request,
			"portletResource");

	if (Validator.isNotNull(portletResource)) {
		preferences = PortletPreferencesFactoryUtil.getPortletSetup(
				request, portletResource);
	}

	String JSONAppPrefs = GetterUtil.getString(preferences.getValue(
			Constants.APP_PREFERENCES, null));
	AppPreferences appPreferences = Utils
			.getAppPreferences(JSONAppPrefs);

	String pilotScript = FileUtil.read(WRFPortlet.pilotScript);
%>

<liferay-portlet:actionURL portletConfiguration="true"
	var="savePreferencesUrl">
	<portlet:param name="<%=Constants.CMD%>"
		value="<%=Constants.SAVE_PREFS%>" />
</liferay-portlet:actionURL>


<liferay-portlet:actionURL portletConfiguration="true"
	var="savePilotUrl">
	<portlet:param name="<%=Constants.CMD%>"
		value="<%=Constants.SAVE_PILOT%>" />
</liferay-portlet:actionURL>

<aui:fieldset label="generic-pref-lbl">
	<aui:layout>

		<aui:column columnWidth="50" first="true">
			<aui:form action="${savePreferencesUrl}" name="aForm" method="post">
				<aui:field-wrapper>
					<aui:button name="save" value="save-configuration" type="submit" />
				</aui:field-wrapper>

				<liferay-ui:success key="<%=Constants.CONFIG_SAVED_SUCCESS%>"
					message="<%=Constants.CONFIG_SAVED_SUCCESS%>" />
				<aui:input type="text" name="fgHost" id="fgHostId"
					label="Futuregateway host:" size="60"
					value="<%=appPreferences.getFgHost()%>">
					<aui:validator name="required" />
				</aui:input>

				<aui:input type="text" name="fgPort" id="fgPortId"
					label="Futuregateway port:" size="60"
					value="<%=appPreferences.getFgPort()%>">
					<aui:validator name="required" />
					<aui:validator name="digits" errorMessage="port-number" />
				</aui:input>

				<aui:input type="text" name="fgAPIVersion" id="fgAPIVersionId"
					label="API version:" size="60"
					value="<%=appPreferences.getFgAPIVersion()%>">
					<aui:validator name="required" />
				</aui:input>

				<aui:input type="text" name="applicationId" id="applicationId"
					label="Application identifier" size="60"
					value="<%=appPreferences.getApplicationId()%>">
					<aui:validator name="required" />
					<aui:validator name="digits" errorMessage="app-id" />
				</aui:input>
			</aui:form>
		</aui:column>
		<aui:column columnWidth="50" last="true">
			<aui:form action="<%=savePilotUrl%>" method="post">
				<aui:field-wrapper>
					<aui:button name="save" value="save-pilot" type="submit" />
				</aui:field-wrapper>
				<liferay-ui:success key="pilot-update-success"
					message="pilot-update-success" />
				<aui:input type="textarea" name="pilotScript" id="pilotScript"
					label="pilot-script" rows="20" cols="100" value="<%=pilotScript%>" />
			</aui:form>
		</aui:column>
	</aui:layout>
</aui:fieldset>

