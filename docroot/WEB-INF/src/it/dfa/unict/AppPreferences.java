package it.dfa.unict;

public class AppPreferences {
	private String fgHost = "";
	private int fgPort;
	private String fgAPIVersion = "";
	private int applicationId;
	private String pilotScript = "";

	public String getFgHost() {
		return fgHost;
	}

	public void setFgHost(String fgHost) {
		this.fgHost = fgHost;
	}

	public String getFgAPIVersion() {
		return fgAPIVersion;
	}

	public void setFgAPIVersion(String fgAPIVersion) {
		this.fgAPIVersion = fgAPIVersion;
	}

	public int getFgPort() {
		return fgPort;
	}

	public void setFgPort(int fgPort) {
		this.fgPort = fgPort;
	}

	public int getApplicationId() {
		return applicationId;
	}

	public void setApplicationId(int applicationId) {
		this.applicationId = applicationId;
	}

	public String getPilotScript() {
		return pilotScript;
	}

	public void setPilotScript(String pilotScript) {
		this.pilotScript = pilotScript;
	}

	@Override
	public String toString() {
		return "AppPreferences [fgHost=" + fgHost + ", fgPort=" + fgPort
				+ ", fgAPIVersion=" + fgAPIVersion + ", applicationId="
				+ applicationId + ", pilotScript=" + pilotScript + "]";
	}

}
