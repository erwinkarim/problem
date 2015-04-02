
var IssuesController = Paloma.controller('Issues');

var newEditFunction = function(){
		console.log('loaded newEditFucntion()');
		//check if the delete row button is already there
		//
		$.each( $('.delete-row'), function( key, value) {
			$(value).click( function(){
				$(this).closest('.row').remove();
			});
		});
		$('#extra-detail-btn').click( function(){
			$.get('/issue_extra_infos/new.template', null, function(data){
				$('#extra-info-list').append(data).ready( function(){
					$('.delete-row:last').click( function(){ 
						$(this).closest('.row').remove();
					});
				});
			});
		});
};

IssuesController.prototype.new = function(){
	console.log('loaded issue/new');
	
	newEditFunction();	
};

IssuesController.prototype.edit = function(){
	console.log('loaded issue/edit');

	newEditFunction();	
};

