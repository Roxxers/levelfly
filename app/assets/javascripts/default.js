function showDialog(visible) {
  if (visible) {
    $("#dialog").css("visibility", "visible");
  } else {
    $("#dialog").css("visibility", "hidden");
  }
}

function showSpinner(visible) {
  if (visible) {
    $("#waiting").css("visibility", "visible");
  } else {
    $("#waiting").css("visibility", "hidden");
  }
}

//Set temp storage
function setStorage(key,value){
  //alert(key +"==="+ value);//debug
  if(value!=""){
    jStorage.set(key, value);
  }
}
//Get temp storage
function getStorage(key) {
  var val
  if(jStorage.get(key)!=""){
    val = jStorage.get(key);
  }
  return val;
}
//Delete temp storage key
function deleteStorage(key) {
  jStorage.deleteKey(key);
}

//show / hide comment divs
function toggle_comments(all) {
	if (all) {
		$('#show_all_cmnts_div').show();
		$('#show_only_cmnts_div').hide();
	} else {
		$('#show_all_cmnts_div').hide();
		$('#show_only_cmnts_div').show();
	}
}

function arrange_comments(msg_id_array,show) {
	if(show==true) {
		$(msg_id_array).each(function(index,item){
			view_all_comment(item);
		});
		toggle_comments(false);
	} else {
		$(msg_id_array).each(function(index,item){
			hide_all_comment(item);
		});
		toggle_comments(true);
	}
}
