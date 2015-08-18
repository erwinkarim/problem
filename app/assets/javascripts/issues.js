
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

		var usernames = new Bloodhound({
			datumTokenizer: Bloodhound.tokenizers.whitespace,
			queryTokenizer: Bloodhound.tokenizers.whitespace,
			remote:{
				url: '/users/search?query=%QUERY',
				wildcard:'%QUERY',
			},
			local: ["one", "two", "three"]
		});

		usernames.initialize();

		$('#affected-user').tagsinput({
			itemValue:'displayname',
			itemText:'displayname',
			typeaheadjs:[{
					highlight:true
				},{
					display: function(suggestion){
						return suggestion.displayname + " <" + suggestion.mail + ">";
					},
					source:usernames.ttAdapter()
				}
			],
			freeInput: false
		});

		$('#affected-user').on('itemAdded', function(event){
			$('#affected-user-mail').append(
				$('<option></option>').attr('value', event.item.mail).attr('selected', 'selected').text(event.item.mail)
			);
		}).on('itemRemoved', function(event){
			$('#affected-user-mail').find('option[value="'+ event.item.mail +'"]').remove();
		});

		/*
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
		*/
		$(document).ready(function(){
				$('.bootstrap-tagsinput').addClass('col-xs-12');
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
