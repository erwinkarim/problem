
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

		$('#affected-user').typeahead({
			delay: 300,
			afterSelect: function(selectedData){
				//get the current email and populate the data accordingly
				$.get('/users/search', { query:selectedData } , function(data){
					$('#affected-user-mail').val( data.emails[0] );
				}, 'json')
			},
			source: function(query, process){
				return $.get('/users/search', { query:query }, function(data){
					return process(data.options);
				}, 'json');
			}
		}).bind('keypress', function(e){
			var code = e.keyCode || e.which;
			if(code==13){
					e.preventDefault();
			};
		})
};

IssuesController.prototype.new = function(){
	console.log('loaded issue/new');
	
	newEditFunction();	
};

IssuesController.prototype.edit = function(){
	console.log('loaded issue/edit');

	newEditFunction();	
};

