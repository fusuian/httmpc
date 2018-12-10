$(function () {
$('#playlist-tab').addClass("active");
$('#alllist-tab').removeClass("active");

$('.delete').on('click', function (eo) {
  var button = eo.target;
  if (button.tagName == "SPAN") {
    button = eo.target.parentElement;
  }

  var id = button.value;
  var url = "<%= url('/delete/') %>" + id;
  console.log(url);
  $.ajax({
  	type: 'DELETE',
  	url: url, 
  	// dataType: 'json',
  	success: function (json) {
  		console.log(json);
      button.parentElement.parentElement.remove();
  	},
  	error: function (error) {
  		console.log('error: '+error);
  	}
  });
});

$('.play').on('click', function (eo) {
  var id = eo.target.value || eo.target.parentElement.value;
  var url = '<%= url('/play/') %>' + id;
  console.log(url);
  $.ajax({
  	type: 'POST',
  	url: url, 
  	// dataType: 'json',
  	success: function (json) {
      playing = true;
  		console.log(json);
  	},
  	error: function (error) {
  		console.log('error: '+error);
  	}
  });
});
});
