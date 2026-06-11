Scanner = function() {
	var self = this;
	
	this.settings = new Object();
	
	this.getErrorID = function() { return self.settings.error; };
	this.setErrorID = function(oid) { self.settings.error = oid; };
	this.getError = function() { return document.getElementById(self.getErrorID()); };
	
	this.getSoundID = function() { return self.settings.sound; };
	this.setSoundID = function(oid) { self.settings.sound = oid; };
	this.getSound = function() { return document.getElementById(self.getSoundID()); };
	
	this.getSettingsID = function() { return self.settings.settings; };
	this.setSettingsID = function(oid) { self.settings.settings = oid; };
	this.getSettings = function() { return document.getElementById(self.getSettingsID()); };
	
	this.getFormID = function() { return self.settings.form; };
	this.setFormID = function(oid) { self.settings.form = oid; };
	this.getForm = function() { return document.forms[self.getFormID()]; };
	
	this.getStartBoxNumber = function() {
		var startno = 1;
		var frm = self.getForm();
		if(frm.StartBoxNumber) { startno = frm.StartBoxNumber.value; }
		return startno;
	};
	
	this.showPopup = function(fieldname, content) {
		var field = self.getField(fieldname);
		field.blur();
	
		var pw = self.getError();
		var leftpos = Number(self.getFieldLeft(fieldname)) + 100;
		var toppos = Number(self.getFieldTop(fieldname)) - 25;
		pw.innerHTML = content;
		pw.style.padding = "5px";
		pw.style.fontSize = "12px";
		pw.style.fontFamily = "arial";
		pw.style.color = "black";
   		pw.style.backgroundColor = "white";
    	pw.style.border = "1px solid red";
		pw.style.width = "250px";
		pw.style.height = "150px";
		pw.style.left = leftpos + "px";
		pw.style.top = toppos + "px";
		pw.style.display = "block";
	};
	
	this.hidePopup = function() {
		var pw = self.getError();
		pw.style.display = "none";
	};
	
	this.getEmptySound = function() { 
		var sound = "sounds/" + self.settings.emptysound; 
		return sound;	
	};
	
	this.setEmptySound = function(file) { self.settings.emptysound = file; };
	
	this.getDupeSound = function() { 
		var sound = "sounds/" + self.settings.dupesound; 
		return sound;
	};
	this.setDupeSound = function(file) { self.settings.dupesound = file; };
	
	this.getMaskSound = function() { 
		var sound = "sounds/" + self.settings.masksound; 
		return sound;
	};
	this.setMaskSound = function(file) { self.settings.masksound = file; };
	
	this.getFinalSound = function() { 
		var sound = "sounds/" + self.settings.finalsound; 
		return sound
	};
	this.setFinalSound = function(file) { self.settings.finalsound = file; };
	
	this.playSound = function(file) {
		var snd = self.getSound();
 		snd.src = file;
	};
	
	this.setIgnoreAll = function(flag) { self.settings.ignoreall = flag; };
	this.getIgnoreAll = function() { return self.settings.ignoreall; };
	
	this.getPrefix = function() { return self.settings.prefix; };
	this.setPrefix = function(prefix) { self.settings.prefix = prefix; };
	
	this.getSeparator = function() { return self.settings.separator; };
	this.setSeparator = function(sep) { self.settings.separator = sep; };
	
	this.getFullPrefix = function() { return self.getPrefix() + self.getSeparator(); };
	
	this.getNumbered = function() { return self.settings.numbered; };
	this.setNumbered = function(numbered) { self.settings.numbered = numbered; };
	
	this.activateFields = function(fieldname) {
		var fieldnum = self.getFieldNumber(fieldname);
		var maxfields = ((self.getStartBoxNumber()) + self.countFields());
		var prefix = self.getFullPrefix();
		for(i=fieldnum; i<maxfields; i++) {
			var tmpname = prefix + i;
			var tmpfld = self.getField(tmpname);
			tmpfld.readOnly = false;
		}
	};
	
	this.clearError = function(fieldname) {
		self.hidePopup();
		self.activateFields(fieldname);
		self.markField(fieldname, self.settings.styles.incomplete);
		if(self.isDuplicate(fieldname)) { self.markField(self.getFieldDuplicate(fieldname), self.settings.styles.complete); }
		self.resetField(fieldname);
		// self.placeCursor(self.getFieldNumber(fieldname));
		self.placeCursorByName(fieldname);
	};
	
	this.clearRange = function(start, finish) {
		var fields = self.getFields();
		for(i=0; i<fields.length; i++) {
			var field = fields[i];
			var j = Number(i) + 1;
			if(j >= start && j <= finish) { 
				self.resetField(field.name); 
				self.markField(field.name, self.settings.styles.incomplete);
			}
		}
	};
	
	this.clearForward = function(fieldname) {
		var d_fieldname = self.getFieldDuplicate(fieldname);
		var d_number = self.getFieldNumber(d_fieldname);
		var n_number = Number(d_number) + 1;
		var n_fieldname = self.getFieldName(n_number);
		var t_number = self.getFieldNumber(fieldname);
		self.hidePopup();
		self.activateFields(n_fieldname);
		self.clearRange(n_number, t_number);
		self.placeCursor(n_number);
		/*
		self.markFields(self.settings.styles.incomplete);
		*/
		return;
	};
	
	this.correctError = function(fieldname) {
		self.hidePopup();
		self.unlockFields();
		self.markField(fieldname, self.settings.styles.incomplete);
		if(self.isDuplicate(fieldname)) { self.markField(self.getFieldDuplicate(fieldname), self.settings.styles.complete); }
		self.placeCursor(self.getFieldNumber(fieldname));
	};
	
	this.ignoreError = function(fieldname) {
		self.hidePopup();
		self.activateFields(fieldname);
		self.markField(fieldname, self.settings.styles.complete);
		if(self.isDuplicate(fieldname)) { self.markField(self.getFieldDuplicate(fieldname), self.settings.styles.complete); }
		self.nextField(fieldname);
	};
	
	this.ignoreAll = function(fieldname) {
		self.setIgnoreAll(true);
		self.ignoreError(fieldname);
	};
	
	this.restartError = function() {
		self.hidePopup();
		self.unlockFields();
		self.resetFields();
		self.markFields(self.settings.styles.incomplete);
		self.placeCursor(self.getStartBoxNumber());
	};
	
	this.placeCursor = function(pos) {
		var field = self.getField(self.getFieldName(pos));
		if(field) { field.focus(); }
	};
	
	this.placeCursorByName = function(fieldname) {
		var field = self.getField(fieldname);
		if(field) { field.focus(); }
	};
	
	this.getFieldIDs = function() { 
		var ids = new Array();
		var fields = self.getFields();
		for(i=0; i<fields.length; i++) {
			var field = fields[i];
			ids[ids.length] = field.name;
		}
		return ids;
	};
	
	this.getFields = function() { 
		var fields = new Array();
		var allinputs = document.getElementsByTagName("input");
		var prefix = self.getFullPrefix();
		for(i=0; i<allinputs.length; i++) {
			var allinput = allinputs.item(i);
			if(allinput.name.indexOf(prefix) != -1) {
				fields[fields.length] = allinput;
			}
		}
		return fields;
	};
	
	this.getField = function(fieldname) { 
		var frm = self.getForm();
		return frm[fieldname];
	};
	
	this.getFieldNumber = function(fieldname) { 
		var prefix = self.getFullPrefix();
		return fieldname.substring(prefix.length, fieldname.length);
	};
	
	this.isLastField = function(fieldname) { 
		var lastfield = false;
		if(self.getFieldNumber(fieldname) == ((self.getStartBoxNumber() -1) + self.countFields())) { lastfield = true; }
		return lastfield;
	};
	
	this.isFirstField = function(fieldname) { 
		var firstfield = false;
		if(self.getFieldNumber(fieldname) == self.getStartBoxNumber()) { firstfield = true; }
		return firstfield;
	};
	
	this.getFieldValue = function(fieldname) { 
		var field = self.getField(fieldname);
		return field.value;
	};
	
	this.countFields = function() { 
		var fields = self.getFields();
		return fields.length;
	};
	
	this.getFieldIndex = function(fieldname) { 
		var field = self.getField(fieldname);
		return field.tabindex;
	};
	
	this.resetFields = function() { 
		var fields = self.getFields();
		for(i=0; i<fields.length; i++) {
			var field = fields[i];
			self.resetField(field.name);
		}
	};
	
	this.resetField = function(fieldname) { 
		var field = self.getField(fieldname);
		field.value = "";
	};
	
	this.markField = function(fieldname, objstyle) { 
		var field = self.getField(fieldname);
		field.style.border = objstyle.border;
		field.style.backgroundColor = objstyle.backgroundColor;
		field.style.color = objstyle.color;
		field.style.fontFamily = objstyle.fontFamily;
		field.style.fontWeight = objstyle.fontWeight;
		field.style.fontSize = objstyle.fontSize;
	};
	
	this.markFields = function(objstyle) {
		var fields = self.getFields();
		for(i=0; i<fields.length; i++) {
			var field = fields[i];
			self.markField(field.name, objstyle);
		}
	};
	
	this.lockFields = function() {
		var flds = self.getFields();
		for(i=0; i<flds.length; i++) {
			fld = flds[i]; 
			self.lockField(fld.name);
		}
	};
	
	this.unlockFields = function() {
		var flds = self.getFields();
		for(i=0; i<flds.length; i++) {
			fld = flds[i]; 
			self.unlockField(fld.name);
		}
	};
	
	this.lockField = function(fieldname) { 
		var field = self.getField(fieldname);
		field.readOnly = true;
	};
	
	this.unlockField = function(fieldname) { 
		var field = self.getField(fieldname);
		field.readOnly = false;
	};
	
	this.getLeftPos = function(obj) { 
		var pos = 0;
		pos = Number(pos) + Number(obj.scrollLeft) + Number(obj.offsetLeft);
		if(obj.offsetParent) {
			var tmp = self.getLeftPos(obj.offsetParent);
			pos = Number(pos) + Number(tmp);
		}
		return  pos;
	};
	this.getTopPos = function(obj) { 
		var pos = 0;
		pos =  Number(pos) +  Number(obj.scrollTop) +  Number(obj.offsetTop);
		if(obj.offsetParent) {
			var tmp = self.getTopPos(obj.offsetParent);
			pos = Number(pos) + Number(tmp);
		}
		return  pos; 
	};
	
	this.getFieldTop = function(fieldname) { 
		var pos = 0;
		var fld = self.getField(fieldname);
		pos = self.getTopPos(fld);
		return pos;
	};
	
	this.getFieldLeft = function(fieldname) { 
		var pos = 0;
		var fld = self.getField(fieldname);
		pos = self.getLeftPos(fld);
		return pos;
	};
	
	this.nextField = function(fieldname) { 
		var maxnum = Number((self.getStartBoxNumber() -1) + self.countFields());
		var curnum = Number(self.getFieldNumber(fieldname));
		if(curnum < maxnum) { 
			nextnum = Number(curnum) + 1;
			self.markField(fieldname, self.settings.styles.complete);
			self.lockField(fieldname);
			self.placeCursor(nextnum); 
		}
		else { 
			var field = self.getField(fieldname);
			self.markField(fieldname, self.settings.styles.complete);
			field.blur();
			self.lockField(fieldname);
			self.playSound(self.getFinalSound());
			document.detailform.ButtonClicked[0].focus();
		}
	};
	
	this.getFieldMask = function(fieldname) { 
		var mask = self.getFieldValue(fieldname);
		mask = mask.replace(/[0-9]/g, "0");
		mask = mask.replace(/[A-Za-z]/g, "X");
		return mask;
	};
	
	this.getFieldDuplicate = function(fieldname) { 
		var dupename = "";
		var fieldnum = self.getFieldNumber(fieldname);
		var fieldval = self.getFieldValue(fieldname);
		var fields = self.getFields();
		for(i=0; i<fields.length; i++) {
			var field = fields[i];
			if(field.name != fieldname && field.value == fieldval) {
				if(field.value != "") {
					dupename = field.name;
					break;
				}
			}
		}
		return dupename;
	};
	
	this.isValidMask = function(fieldname) { 
		var valid = true;
		if(self.isFirstField(fieldname) == true) {
			self.setMaskTemplate(self.getFieldMask(fieldname));
		}
		else {
			var secmask = self.getFieldMask(fieldname);
			var mtemplate = self.getMaskTemplate();
			if(secmask.length != mtemplate.length) { valid = false; }
		}
		return valid;
	};
	
	this.isDuplicate = function(fieldname) { 
		var dupe = false;
		var dupename = self.getFieldDuplicate(fieldname); 
		if(dupename != "") { dupe = true; }
		return dupe;
	};
	
	this.isEmpty = function(fieldname) { 
		var empty = false;
		if(self.getFieldValue(fieldname) == "") { empty = true; }
		return empty;
	};
	
	this.getFieldName = function(pos) { return self.getPrefix() + self.getSeparator() + pos; };
	
	this.getDupeAlert = function() { return self.settings.dupealert; };
	this.setDupeAlert = function(alertenabled) { self.settings.dupealert = alertenabled; };
	
	this.getMaskAlert = function() { return self.settings.maskalert; };
	this.setMaskAlert = function(alertenabled) { self.settings.maskalert = alertenabled; };
	
	this.getEmptyAlert = function() { return self.settings.emptyalert; };
	this.setEmptyAlert = function(alertenabled) { self.settings.emptyalert = alertenabled; };
	
	this.getKeyCode = function() { return self.settings.keycode; };
	this.setKeyCode = function(keycode) { self.settings.keycode = keycode; };
	
	this.getCancelEvent = function() { return self.settings.cancelevent; };
	this.setCancelEvent = function(cancelenabled) { self.settings.cancelevent = cancelenabled; };
	
	this.getMaskTemplate = function() { return self.settings.template; };
	this.setMaskTemplate = function(mask) { self.settings.template = mask; };
	
	this.doEmptyError = function(fieldname) {
		self.playSound(self.getEmptySound());
		self.lockFields();
		self.markField(fieldname, self.settings.styles.error);
		var msg = "<span style=\"color:red;font-weight:bold;\">This field contains no data.</span><br/>";
		msg += "Please choose one of the following actions:<br/>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.clearError('"+fieldname+"')\">Clear the field and re-scan</a></li>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.correctError('"+fieldname+"')\">Manually correct the error</a></li>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.restartError()\">Restart scan from beginning</a></li>";
		self.showPopup(fieldname, msg);
	};
	
	this.doMaskError = function(fieldname) {
		self.playSound(self.getMaskSound());
		self.lockFields();
		self.markField(fieldname, self.settings.styles.error);
		var msg = "<span style=\"color:red;font-weight:bold;\">This serial number has an invalid mask.</span><br/>";
		msg += "Please choose one of the following actions:<br/>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.clearError('"+fieldname+"')\">Clear the field and re-scan</a></li>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.correctError('"+fieldname+"')\">Manually correct the error</a></li>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.ignoreError('"+fieldname+"')\">Ignore and continue</a></li>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.restartError()\">Restart scan from beginning</a></li>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.ignoreAll('"+fieldname+"')\">Ignore All</a></li>";
		self.showPopup(fieldname, msg);
	};
	
	this.doDupeError = function(fieldname) {
		self.playSound(self.getDupeSound());
		self.lockFields();
		self.markField(fieldname, self.settings.styles.error);
		self.markField(self.getFieldDuplicate(fieldname), self.settings.styles.duplicate);
		var msg = "<span style=\"color:red;font-weight:bold;\">This serial number has already been scanned.</span><br/>";
		msg += "Please choose one of the following actions:<br/>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.clearError('"+fieldname+"')\">Clear the field and re-scan</a></li>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.correctError('"+fieldname+"')\">Manually correct the error</a></li>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.ignoreError('"+fieldname+"')\">Ignore and continue</a></li>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.restartError()\">Restart scan from beginning</a></li>";
		msg += "<li style=\"list-style-type:none;padding-top:5px;\"><a href=\"javascript:void(0)\" onclick=\"window.scanner.clearForward('"+fieldname+"')\">Clear from the duplicate field forward</a></li>";
		self.showPopup(fieldname, msg);
	};
	
	this.validateForm = function() {
		var cansubmit = true;
		var fields = self.getFields();
		for(i=0; i<fields.length; i++) {
			var field = fields[i];
			if(field.value.length == 0) { 
				cansubmit = false;
				break;
			}
		}
		return cansubmit;
	};
	
	this.init = function() {
		var dt = self.getSettings();
		var raw = eval('(' + dt.innerText + ')');
		
		if(raw.keycode == undefined) { self.setKeyCode(13); }
		else { self.setKeyCode(raw.keycode); }
		
		if(raw.cancelkey == undefined) { self.setCancelEvent(true); }
		else { self.setCancelEvent(raw.cancelkey); }
		
		if(raw.finalsound == undefined) { self.setFinalSound("Final.wav"); }
		else { self.setFinalSound(raw.finalsound); }
		
		if(raw.dupesound == undefined) { self.setDupeSound("Dupe.wav"); }
		else { self.setDupeSound(raw.dupesound); }
		
		if(raw.masksound == undefined) { self.setMaskSound("Mask.wav"); }
		else { self.setMaskSound(raw.masksound); }
		
		if(raw.emptysound == undefined) { self.setEmptySound("Empty.wav"); }
		else { self.setEmptySound(raw.emptysound); }
		
		if(raw.inputprefix == undefined) { self.setPrefix("SN"); }
		else { self.setPrefix(raw.inputprefix); }
		
		if(raw.inputseparator == undefined) { self.setSeparator("_"); }
		else { self.setSeparator(raw.inputseparator); }
		
		if(raw.inputnumbered == undefined) { self.setNumbered(true); }
		else { self.setNumbered(raw.inputnumbered); }
		
		if(raw.formname == undefined) { self.setFormID("detailform"); }
		else { self.setFormID(raw.formname); }
		
		if(raw.datafield == undefined) { self.setSettingsID("settings"); }
		else { self.setSettingsID(raw.datafield); }
		
		if(raw.errorfield == undefined) { self.setErrorID("error"); }
		else { self.setErrorID(raw.errorfield); }
		
		if(raw.soundfield == undefined) { self.setSoundID("soundconsole"); }
		else { self.setSoundID(raw.soundfield); }
		
		if(raw.alertdupes == undefined) { self.setDupeAlert(true); }
		else { self.setDupeAlert(raw.alertdupes); }
		
		if(raw.alertmask == undefined) { self.setMaskAlert(true); }
		else { self.setMaskAlert(raw.alertmask); }
		
		if(raw.alertempty == undefined) { self.setEmptyAlert(true); }
		else { self.setEmptyAlert(raw.alertempty); }
		
		self.setIgnoreAll(false);
		
		self.settings.styles = new Object();
		self.settings.styles.duplicate = new Object();
		self.settings.styles.duplicate.border = "1px solid blue";
		self.settings.styles.duplicate.backgroundColor = "white";
		self.settings.styles.duplicate.color = "blue";
		self.settings.styles.duplicate.fontFamily = "arial";
		self.settings.styles.duplicate.fontWeight = "normal";
		self.settings.styles.duplicate.fontSize = "11px";
		
		self.settings.styles.error = new Object();
		self.settings.styles.error.border = "1px solid red";
		self.settings.styles.error.backgroundColor = "white";
		self.settings.styles.error.color = "red";
		self.settings.styles.error.fontFamily = "arial";
		self.settings.styles.error.fontWeight = "normal";
		self.settings.styles.error.fontSize = "11px";
		
		self.settings.styles.complete = new Object();
		self.settings.styles.complete.border = "1px solid green";
		self.settings.styles.complete.backgroundColor = "white";
		self.settings.styles.complete.color = "green";
		self.settings.styles.complete.fontFamily = "arial";
		self.settings.styles.complete.fontWeight = "normal";
		self.settings.styles.complete.fontSize = "11px";
		
		self.settings.styles.incomplete = new Object();
		self.settings.styles.incomplete.border = "1px solid lightgrey";
		self.settings.styles.incomplete.backgroundColor = "white";
		self.settings.styles.incomplete.color = "black";
		self.settings.styles.incomplete.fontFamily = "arial";
		self.settings.styles.incomplete.fontWeight = "normal";
		self.settings.styles.incomplete.fontSize = "11px";
		
		self.unlockFields();
		// self.resetFields();
		// self.markFields(self.settings.styles.incomplete);
		self.checkMaskTemplate();
		self.determineCursor();
	};
	
	this.checkMaskTemplate = function() {
		var pos = self.getStartBoxNumber();
		var firstname = self.getFieldName(pos);
		var field = self.getField(firstname);
		if(field.value != "") {
			var mask = self.getFieldMask(firstname);
			self.setMaskTemplate(mask);
		}
	};
	
	this.determineCursor = function() {
		var pos = self.getStartBoxNumber();
		var fields = self.getFields();
		for(i=0; i<fields.length; i++) {
			var field = fields[i];
			if(field.style.color == "red") { 
				pos = self.getFieldNumber(field.name);
				break;
			}
			else if(field.style.color == "black") {
				pos = self.getFieldNumber(field.name);
				break;
			}
		}
		self.placeCursor(pos);
	};
	
	this.doKeyUp = function() {
		var allowkey = true;
		if(event.keyCode == self.getKeyCode()) { 
			self.doKeyEvent(); 
			allowkey = false;
		}
		else if(event.keyCode == 9) { 
			self.cancelKeyEvent(); 
			allowkey = false;
		}
		return allowkey;
	};
	
	this.doKeyPress = function() {
		var allowkey = true;
		if(event.keyCode == self.getKeyCode()) { 
			self.cancelKeyEvent(); 
			allowkey = false;
		}
		else if(event.keyCode == 9) { 
			self.cancelKeyEvent(); 
			allowkey = false;
		}
		return allowkey;
	};
	
	this.doKeyDown = function() {
		var allowkey = true;
		if(event.keyCode == self.getKeyCode()) { 
			self.cancelKeyEvent(); 
			allowkey = false;
		}
		else if(event.keyCode == 9) { 
			self.doKeyEvent(); 
			allowkey = false;
		}
		return allowkey;
	};
	
	
	this.doKeyEvent = function() {
		if(self.isEmpty(event.srcElement.name) == true && self.getEmptyAlert() == true) { 
			self.doEmptyError(event.srcElement.name); 
		}
		else if(self.isValidMask(event.srcElement.name) == false && self.getMaskAlert() == true && self.getIgnoreAll() == false) { 
			self.doMaskError(event.srcElement.name); 
		}
		else if(self.isDuplicate(event.srcElement.name) == true && self.getDupeAlert() == true) { 
			self.doDupeError(event.srcElement.name); 
		}
		else { self.nextField(event.srcElement.name); }
	};
	
	this.cancelKeyEvent = function() {
		event.cancelBubble = true;
	};
};