<%-- 
    Document   : view
    Created on : Feb 15, 2016, 10:29:44 AM
    Author     : mario
--%>

<%@page import="it.dfa.unict.AppPreferences"%>
<%@page import="it.dfa.unict.util.Constants"%>
<%@page import="it.dfa.unict.util.Utils"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.liferay.util.PwdGenerator"%>
<%@page import="java.util.List"%>
<%@include file="../init.jsp"%>

<%
	PortletPreferences preferences = renderRequest.getPreferences();

	SimpleDateFormat dateFormat = new SimpleDateFormat(
			Constants.TS_FORMAT);
	String timestamp = dateFormat.format(Calendar.getInstance()
			.getTime());

	String jobLabel = user.getScreenName() + "_" + timestamp;

	String JSONAppPrefs = GetterUtil.getString(preferences.getValue(
			Constants.APP_PREFERENCES, null));

	boolean isConfigured = true;
	if (JSONAppPrefs == null || JSONAppPrefs.isEmpty()) {
		isConfigured = false;
	}

	String uploadProgressId = PwdGenerator.getPassword(
			PwdGenerator.KEY3, 4);
%>

<aui:layout>
	<aui:column columnWidth="50" first="true">
		<img src="<%=request.getContextPath()%>/images/AppLogo.png"
			height="80%" width="80%" />
	</aui:column>
	<aui:column columnWidth="50" last="true">
		<%=LanguageUtil.get(portletConfig,
							themeDisplay.getLocale(), "how-to-use")%>
	</aui:column>
</aui:layout>

<c:choose>
	<c:when test="<%=isConfigured%>">
		<liferay-ui:error key="error-space" message="error-disk-space" />
		<portlet:actionURL name="submit" var="submitURL" />
		<portlet:resourceURL id="createTask" var="createTaskURL" />

		<liferay-ui:upload-progress id="<%=uploadProgressId%>"
			message="uploading" redirect="<%=submitURL%>" />

		<aui:form action="<%=submitURL%>" enctype="multipart/form-data"
			onSubmit="'<%=uploadProgressId %>'.startProgress(); return true;"
			method="post">

			<liferay-ui:panel-container accordion="false">
				<liferay-ui:panel title="input-file" collapsible="true"
					helpMessage="input-file">
					<liferay-ui:error key="empty-file0" message="empty-file" />
					<aui:input name="fileupload0" label="namelist-wps"
						title="namelist-wps" type="file" helpMessage="accept-wps">
						<aui:validator name="required" />
						<aui:validator name="acceptFiles">'wps'</aui:validator>
					</aui:input>
					<liferay-ui:error key="empty-file1" message="empty-file" />
					<aui:input name="fileupload1" label="namelist-input"
						title="namelist-input" type="file" helpMessage="accept-input">
						<aui:validator name="required" />
						<aui:validator name="acceptFiles">'input'</aui:validator>
					</aui:input>
				</liferay-ui:panel>
				<br />
				<br />
				<liferay-ui:panel title="lbc-files" collapsible="true"
					helpMessage="lbc-files">
					<aui:input type="textarea" name="lbc-script"
						label="download-lbc-script" style="width: 600px; height: 200px">
						<aui:validator name="required" />
					</aui:input>
					<aui:input type="password" name="password1" id="password1"
						label="password" helpMessage="ncar-password">
						<aui:validator name="required" />
					</aui:input>
					<aui:input type="password" name="password2" id="password1"
						label="re-type-password">
						<aui:validator name="equalTo">'#<portlet:namespace />password1'</aui:validator>
					</aui:input>
				</liferay-ui:panel>
			</liferay-ui:panel-container>
			
			<aui:input type="text" name="jobLabel" label="job-label" size="60"
							helpMessage="job-label-help" id="jobLabel" value="<%= jobLabel %>" />
			
			<aui:field-wrapper>
				<aui:button name="submit" value="submit" type="submit" />
				<aui:button name="reset" value="cancel" type="reset" />
			</aui:field-wrapper>

		</aui:form>
	</c:when>
	<c:otherwise>
		<div class="portlet-msg-info">
			<liferay-ui:message key="check-configuration" />
		</div>
	</c:otherwise>
</c:choose>
