
var AdminsController = Paloma.controller('Admins');

AdminsController.prototype.index = function(){
	console.log('loaded admin/index');
	
	var remove_admin = function(target){
			$(target).click( function(){
				$.ajax('/admins/' + $(this).attr('data-id') , 
					{ method:'DELETE' }
				).done( function(data){
					$(target).closest('tr').remove();
				}).fail( function(data){
					console.log('delete failed');
				});
			});
	};

	$(document).ready( function(){
		$.each( $('.remove-user'), function(index, value){
			remove_admin(value)
		});

		$('#new-admin-button').click( function(){
			$.post('/admins', { username:$('#new-admin').val() }, function(data){
				$('#admin-list').find('#no-one-is-here').remove();
				$('#admin-list').append(data);
			});
		});
	});
};
