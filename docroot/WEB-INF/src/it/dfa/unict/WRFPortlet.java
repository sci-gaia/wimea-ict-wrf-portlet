package it.dfa.unict;

import it.dfa.unict.futuregatewayclient.FutureGatewayClient;
import it.dfa.unict.futuregatewayclient.FutureGatewayClientException;
import it.dfa.unict.futuregatewayclient.pojo.AppInput;
import it.dfa.unict.futuregatewayclient.pojo.InputFile;
import it.dfa.unict.futuregatewayclient.pojo.Link;
import it.dfa.unict.futuregatewayclient.pojo.Task;
import it.dfa.unict.util.Constants;
import it.dfa.unict.util.Utils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
import javax.portlet.ProcessAction;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.LiferayPortletConfig;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.FileUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.JavaConstants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.User;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

public class WRFPortlet extends MVCPortlet {

	private final Log _log = LogFactoryUtil.getLog(WRFPortlet.class);

	public static String pilotScript;

	/**
	 * Initializes portlet's configuration with pilot-script file path.
	 * 
	 * @see com.liferay.util.bridges.mvc.MVCPortlet#init()
	 */
	@Override
	public void init() throws PortletException {
		super.init();
		pilotScript = getPortletContext().getRealPath(Constants.FILE_SEPARATOR)
				+ "WEB-INF/job/" + getInitParameter("pilot-script");
	}

	/**
	 * Processes the 'multipart/form-data' form uploading file, gets the jobs
	 * label finally submits job towards a list of enabled DCI specified in the
	 * configuration.
	 * 
	 * @param actionRequest
	 * @param actionResponse
	 * @throws IOException
	 * @throws PortletException
	 */
	@ProcessAction(name = "submit")
	public void submit(ActionRequest actionRequest,
			ActionResponse actionResponse) throws IOException, PortletException {

		PortletPreferences preferences = actionRequest.getPreferences();
		String JSONAppPrefs = GetterUtil.getString(preferences.getValue(
				Constants.APP_PREFERENCES, null));
		_log.debug(JSONAppPrefs);
		AppPreferences appPrefs = Utils.getAppPreferences(JSONAppPrefs);
		_log.debug(appPrefs);

		if (appPrefs.getApplicationId() <= 0) {
			SessionErrors.add(actionRequest, "wrong-app-id");
		} else if (Validator.isIPAddress(appPrefs.getFgHost())
				|| Validator.isHostName(appPrefs.getFgHost())) {

			AppInput appInput = new AppInput();
			appInput.setApplication(appPrefs.getApplicationId());

			String username = this.getUserScreenName(actionRequest);
			UploadPortletRequest uploadRequest = PortalUtil
					.getUploadPortletRequest(actionRequest);

			List<InputFile> inputFiles = new ArrayList<InputFile>();
			String[] inputSandbox = { null, null, null, null };
			for (int i = 0; i < 2; i++) {
				File uploadedFile = processInputFile(uploadRequest, i);
				if (uploadedFile != null && uploadedFile.length() == 0) {
					SessionErrors.add(actionRequest, "empty-file" + i);
					break;
				} else {
					inputSandbox[i] = uploadedFile.getAbsolutePath();
					InputFile inputFile = new InputFile();
					inputFile.setName(uploadedFile.getName());
					inputFiles.add(inputFile);
					appInput.getArguments().add(inputFile.getName() + " ");
				}
			}
			String jobLabel;
			if (inputFiles.size() > 1) {
				jobLabel = ParamUtil.get(uploadRequest, "jobLabel",
						"WRF Application");
				appInput.setDescription(jobLabel);
				appInput.setInputFiles(inputFiles);
				InputFile inputFile = new InputFile();

				String lbcScriptStr = ParamUtil.getString(uploadRequest,
						"lbc-script", null);
				File lbcScript = FileUtil.createTempFile("sh");
				FileUtil.write(lbcScript, lbcScriptStr);

				inputFile.setName(lbcScript.getName());
				appInput.getInputFiles().add(inputFile);
				appInput.getArguments().add(lbcScript.getName() + " ");
				inputSandbox[2] = lbcScript.getAbsolutePath();

				String pwdStr = ParamUtil.getString(uploadRequest, "password1",
						null);
				File pwdFile = FileUtil.createTempFile();
				FileUtil.write(pwdFile, pwdStr);
				inputFile = new InputFile();
				inputFile.setName(pwdFile.getName());
				appInput.getInputFiles().add(inputFile);
				appInput.getArguments().add(pwdFile.getName() + " ");
				inputSandbox[3] = pwdFile.getAbsolutePath();
				_log.info(appInput);

				FutureGatewayClient client = new FutureGatewayClient(
						appPrefs.getFgHost(), appPrefs.getFgPort(),
						appPrefs.getFgAPIVersion());

				try {
					this.submitTask(appInput, username, inputSandbox, client);
					actionResponse.setRenderParameter("jobLabel", jobLabel);
					actionResponse.setRenderParameter("jspPage",
							"/jsps/submit.jsp");

				} catch (IOException | FutureGatewayClientException e) {
					_log.error(e.getMessage());
					SessionErrors.add(actionRequest, "error");
					actionResponse.setRenderParameter("jspPage",
							"/jsps/view.jsp");
				}
			}

		} else {
			SessionErrors.add(actionRequest, "wrong-fg-host");
		}
		// Hide default Liferay success/error messages
		PortletConfig portletConfig = (PortletConfig) actionRequest
				.getAttribute(JavaConstants.JAVAX_PORTLET_CONFIG);
		LiferayPortletConfig liferayPortletConfig = (LiferayPortletConfig) portletConfig;
		SessionMessages.add(actionRequest, liferayPortletConfig.getPortletId()
				+ SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);

	}

	/**
	 * 
	 * @param appInput
	 * @param username
	 * @param inputSandbox
	 * @param client
	 * @throws IOException
	 * @throws FutureGatewayClientException
	 */
	private void submitTask(AppInput appInput, String username,
			String[] inputSandbox, FutureGatewayClient client)
			throws IOException, FutureGatewayClientException {
		Task t = client.createTask(appInput, username);
		_log.info(t);

		if (t.getStatus().equals("WAITING") && inputSandbox != null) {
			// 2. upload input file
			String uploadPath = "";
			List<Link> links = t.getLinks();
			for (Link link : links) {
				if (link.getRel().equals("input")) {
					uploadPath = link.getHref();
					break;
				}
			}
			String t2 = client.uploadFile(uploadPath, inputSandbox);
			_log.info(t2);
		}
	}

	/**
	 * @param uploadRequest
	 * @param username
	 * @param timestamp
	 * @param appInput
	 * @return
	 * @throws IOException
	 */
	private File processInputFile(UploadPortletRequest uploadRequest, int i)
			throws IOException {

		File file = null;
		String fileInputName = "fileupload" + i;

		String sourceFileName = uploadRequest.getFileName(fileInputName);

		if (Validator.isNotNull(sourceFileName)) {
			_log.debug("Uploading file: " + sourceFileName + " ...");

			String fileName = FileUtil.stripExtension(sourceFileName);
			_log.debug(fileName);

			String extension = FileUtil.getExtension(sourceFileName);
			_log.debug(extension);

			// Get the uploaded file as a file.
			File uploadedFile = uploadRequest.getFile(fileInputName, true);
			file = FileUtil.createTempFile(extension);
			FileUtil.move(uploadedFile, file);

		}
		return file;
	}

	/**
	 * Returns the logged in user's username.
	 * 
	 * @param actionRequest
	 *            {@link ActionRequest} from which get the information.
	 * @return logged in user's username
	 */
	private String getUserScreenName(ActionRequest actionRequest) {
		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest
				.getAttribute(WebKeys.THEME_DISPLAY);
		User user = themeDisplay.getUser();
		return user.getScreenName();
	}
}
