$(function () {
$('#alllist-tab').addClass("active");
$('#playlist-tab').removeClass("active");
	$('#sorter').tablesorter();

	$('.add').on('click', function (eo) {
		var file = eo.target.value || eo.target.parentElement.value;
		var url = '<%= url('/add/') %>' + file;
		console.log(url);
		$.ajax({
			type: 'POST',
			url: url, 
			success: function (json) {
				console.log(json);
				alert(json.file + 'を登録');
			},
			error: function (error) {
				console.log('error: '+error);
			}
		});
	});

	$('.kill-file').on('click', function (eo) {
		var target = eo.target;
		if (target.tagName == "SPAN") {
			target = eo.target.parentElement;
		}
		var file = target.value;
		var ok = confirm(file + 'を削除します。本当によろしいですか？');
		if (!ok) {
			return;
		}
		var url = '<%= url('/kill_file/') %>' + file;
		console.log(url);
		$.ajax({
			type: 'DELETE',
			url: url, 
			success: function (json) {
				console.log(json);
				target.parentElement.parentElement.remove();
				alert(json.file + 'を削除しました');
			},
			error: function (error) {
				console.log('error: '+error);
				alert('削除できません: ' + error.status + ': ' + error.statusText);
			}
		});
	});


});
