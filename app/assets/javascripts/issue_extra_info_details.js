
var IssueExtraInfoDetailsController = Paloma.controller('IssueExtraInfoDetails');

IssueExtraInfoDetailsController.prototype.index = function(){
	console.log ('loaded issue_extra_info_details/index');

	$(document).ready( function(){
		$('#new-detail').click( function(){
			$.get('/issue_extra_info_details/new.template', null, function(data){
				$('#empty-list').remove();
				$('#details-list').append(data).find('.delete-row-btn:last').bind('click', function(){
					$(this).closest('tr').remove();
				});
			});
		});
	});

};
