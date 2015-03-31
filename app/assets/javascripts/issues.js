
var IssuesController = Paloma.controller('Issues');

var newEditFunction = function(){
};

IssuesController.prototype.new = function(){
	$(document).ready( function(){
			$('#extra-detail-btn').click( function(){
				$.get('/issue_extra_infos/new.template', null, function(data){
					$('#extra-info-list').append(data).ready( function(){
						$('.delete-row:last').click( function(){
							$(this).closest('.row').remove();
						});
					});
				});
			});
	});
};

IssuesController.prototype.edit = function(){
};
