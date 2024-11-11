/* add field */
var _fieldCount = 1;
function addField(_num){
	var _numNew = _num + 1;
	if(!$("field" + _numNew)){
		var _fieldDiv = document.createElement('div');
		_fieldDiv.setAttribute("id", "field" + _numNew);
		$("fields").appendChild(_fieldDiv);
		$("field" + _numNew).innerHTML = '<textarea cols="90" rows="2" name="field_' + _numNew + '" onkeydown="addField(' + _numNew + ')" ></textarea>';
		_fieldCount++;
		$("fieldcount").value = _fieldCount;
	}
}

var _classType = "off";
function addField2(_num){
	var _numNew = _num + 1;
	if(!$("field" + _numNew)){
		var _fieldDiv = document.createElement('div');
		_fieldDiv.setAttribute("id", "field" + _numNew);
		$("fields2").appendChild(_fieldDiv);
		_classType = (_classType == "off")? "on" : "off";
		_html = '<table border="0" cellpadding="0" cellspacing="0" class="voteNum2" style="width:100%"><tr><th class="'+_classType+'">';
		_html += '<div align="center" style="width:160px">';
		_html += '<div id="num'+_numNew+'" class="voteNum0" onmouseover="openSort('+_numNew+')"><spacer /></div>';
		_html += '<div id="num'+_numNew+'sel" class="voteNumNone" onmouseover="openSortDiv()" onmouseout="hideSortTimeout()"><spacer /></div>';
		_html += '</div>';
		_html += '</th>';
		_html += '<td class="'+_classType+'" width="100%"><input type="text" id="num'+_numNew+'text" name="field_'+_numNew+'" value="" onkeydown="addField2('+_numNew+')" style="width:100%" /></td>';
		_html += '</tr></table>';
		$("field" + _numNew).innerHTML = _html;
		_fieldCount++;
		_sortMax++;
		$("fieldcount").value = _fieldCount;
	}
}

function addField3(_num){
	var _cnt = $("fieldcount").value;
	var _numNew = _num + 1;
	if(!$("field" + _numNew)){
		var _fieldDiv = document.createElement('div');
		_fieldDiv.setAttribute("id", "field" + _numNew);
		$("fields3").appendChild(_fieldDiv);
		_classType = (_classType == "off")? "on" : "off";
		_html = '<table border="0" cellpadding="0" cellspacing="0" class="voteNumTbl" style="width:100%">';
		_html += '<td class="'+_classType+'" width="100%"><input type="text" id="num_new_'+_numNew+'text" name="field_'+_numNew+'" value="" onkeydown="addField3('+_numNew+')" style="width:100%" /></td>';
		_html += '</tr></table>';
		$("field" + _numNew).innerHTML = _html;
		_cnt++;
		$("fieldcount").value = _cnt; 
	}
}


/* set radio */
function setRadio(_obj){
	var _radioId = String(_obj.getAttribute('rel'));
	var _radioType = String(_obj.getAttribute('type'));
	var _radioValue = String(_obj.getAttribute('value'));
	if(_radioType == "on") return;

	if($(_radioId + "_group").innerHTML){
		var _spanArr = $(_radioId + "_group").getElementsByTagName('span');
		for(var i = 0; i < _spanArr.length; i++){
			_spanArr[i].setAttribute("type", "off");
			_spanArr[i].childNodes[0].src = "img/radio_off.gif";
		}
		_obj.setAttribute("type", "on");
		_obj.childNodes[0].src = "img/radio_on.gif";
		$(_radioId).value = _radioValue;
	}
}

/* info step */
var _stepTimeout = null;
var _infoTimeout = null;
var _stepPause = 500;
var _infoPause = 300;
function infoStep(_obj, _param){
	if(_param){
		clearTimeout(_infoTimeout);
		clearTimeout(_stepTimeout);
		hideInfo();
		//hideVote2();

		$("infohead").innerHTML = '&#1042;&#1086;&#1087;&#1088;&#1086;&#1089; &#8470;' + _param;
		$("infotext").innerHTML = _voteText[_param - 1];
		$("info").style.top = (143 - $("info").offsetHeight) + "px";
		$("info").style.left = (_obj.offsetLeft - 120) + "px";
		$("info").style.visibility = "visible";
		//if(_param == 2) openVote2();
	}else{
		_infoTimeout = setTimeout('hideInfo()', _infoPause);
		//hideVote2Timeout();
	}
}

/* hide */
function hideVote2Timeout(){
	_stepTimeout = setTimeout('hideVote2()', _stepPause);
}
function hideVote2(){
	$("vote2div").style.visibility = "hidden";
}
function hideInfo(){
	$("info").style.visibility = "hidden";
}

/* open vote 2 */
function openVote2(){
	clearTimeout(_stepTimeout);

	$("vote2div").style.top = 203 + "px";
	$("vote2div").style.left = $("vote2").offsetLeft + "px";
	$("vote2div").style.visibility = "visible";

	return false;
}

/* open sort */
var _sortTimeout = null;
var _sortPause = 300;
var _sortOpen = 0;
function openSort(_num){
	clearTimeout(_sortTimeout);
	hideSort();

	$("num" + _num).style.display = "none";
	$("num" + _num + "sel").innerHTML = $("sort").innerHTML;
	$("num" + _num + "sel").className = "voteNumBlock";
	_sortOpen = _num;
	return false;
}
function openSortDiv(){
	clearTimeout(_sortTimeout);

	$("num" + _sortOpen + "sel").className = "voteNumBlock";
	return false;
}

/* hide sort */
function hideSortTimeout(){
	_sortTimeout = setTimeout('hideSort()', _sortPause);
	return false;
}
function hideSort(){
	if(_sortOpen){
		$("num" + _sortOpen).style.display = "block";
		$("num" + _sortOpen + "sel").className = "voteNumNone";
	}
	return false;
}

/* set sort */
function setSort(_num){
	for(i = 1; i < _sortColor.length; i++){
		if(_sortColor[i] == _sortOpen){
			$("sort" + i + "text").innerHTML = "...";
			$("sort" + i).value = "";
			_sortColor[i] = 0;
		}
	}

	if(_sortOpen > _sortCount){
		$("sort" + _num + "text").innerHTML = $("num" + _sortOpen + "text").value;
	}else{
		$("sort" + _num + "text").innerHTML = $("num" + _sortOpen + "text").innerHTML;	
	}
	//alert($("sort" + _num + "text").innerHTML);
	$("sort" + _num).value = _sortOpen;
	
	$("num" + _sortOpen + "sel").className = "voteNumNone";
	$("num" + _sortOpen).className = "voteNum" + _num;
	$("num" + _sortOpen).style.display = "block";

	_sortColor[_num] = _sortOpen;
	_sortOpen = 0;
	setSortColor();

	return false;
}

/* set checkbox */
function setCbox(_obj){
 var _cboxId = String(_obj.getAttribute('rel'));
 var _cboxType = String(_obj.getAttribute('type'));
 var _cboxValue = String(_obj.getAttribute('value'));
 if(_cboxType == "on"){
  _obj.setAttribute("type", "off");
  _obj.childNodes[0].src = "img/cbox_off.gif";
  $(_cboxId).value = "";
 }else{
  _obj.setAttribute("type", "on");
  _obj.childNodes[0].src = "img/cbox_on.gif";
  $(_cboxId).value = _cboxValue;
 }
}
