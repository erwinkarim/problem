
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
			}
		});

		usernames.initialize();

		$('#affected-user').tagsinput({
			itemValue:'displayname',
			itemText:'displayname',
			confirmKeys: [13,188,9],
			typeaheadjs:[{
					highlight:true,
					autoselect: true
				},{
					display: function(suggestion){
						return suggestion.displayname + " <" + suggestion.mail + ">";
					},
					templates:{
							pending: function(){return '<div class="tt-suggestion"><i class="fa fa-spinner fa-spin"></i> Loading...</div>' }
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

		$(document).ready(function(){
				$('.bootstrap-tagsinput').addClass('col-xs-12');
				$('.bootstrap-tagsinput').find('tt-input').focus(function(e){
						console.log('focused');
				})
				$('#submit-report').click( function(e){
						$('#issue-form').submit();
				})
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
