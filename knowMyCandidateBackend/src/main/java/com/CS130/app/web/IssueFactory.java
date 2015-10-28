package com.CS130.app.web;

import org.parse4j.ParseObject;

public class IssueFactory {

	public Issue getNewIssue() {
		return new Issue();
	}
	
	public Issue getIssue(String objectId) {
		Issue issueReference = (Issue) ParseObject.createWithoutData("Issue", objectId);
		return issueReference;
	}
	
}
