package org.grails.plugins.console

import grails.validation.Validateable

class ExecuteCommand implements Validateable {
	String code
	boolean autoImportDomains

	String getCode() {
		return this.@code ?: ''
	}
}
