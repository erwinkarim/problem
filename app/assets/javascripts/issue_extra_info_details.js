
var IssueExtraInfoDetailsController = Paloma.controller('IssueExtraInfoDetails');

var remove_this_row = function(target){
		target.closest('tr').remove();
};

IssueExtraInfoDetailsController.prototype.index = function(){
	console.log ('loaded issue_extra_info_details/index');

	$(document).ready( function(){
		$.each($('.delete-row-btn'), function(index, value){
			$(value).bind('click', function(){
					remove_this_row($(this))
			});
		});
		$('#new-detail').click( function(){
			$.get('/issue_extra_info_details/new.template', null, function(data){
				$('#empty-list').remove();
				$('#details-list').append(data).find('.delete-row-btn:last').bind('click', function(){
					remove_this_row($(this));
					$(this).closest('tr').remove();
				});
			});
		});
	});

};
