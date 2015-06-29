
var ImportController = Paloma.controller('Import');

ImportController.prototype.index = function(){
	console.log('loaded issue/import');

	$('.droppable').droppable({
		drop: function(event, ui){
			$(this).empty().append($(ui.draggable[0]).find('a').clone() );
			//if all the field has been selected, show import button
			$('#step3').removeClass('hide');

			//check if the all the fields has been selected, then 
			$(this).removeClass('not-set');
			if( $('#select-header-table').find('.not-set').length == 0 ) {
				$('#start-import-btn').removeAttr('disabled');
			};
		}
	});

	$('#drop-file').fileupload({
		url:'/issues/import/drop_file',
		acceptFileTypes: /(\.|\/)(cvs)$/i
	}).bind('fileuploaddone', function(e,data){
		result = JSON.parse(data.result);

		//reset the tables
		$('#select-header-table').find('.droppable').empty().append('Drop Here');
		
		//display step2 and preview
		$('#csv-content').removeClass('hide');
		$('#step2').removeClass('hide');

		//update #target field
		$('#target').val(result.files[0].name);

		//display preview
		$.get("import/preview.template", { target: result.files[0].name  }, function(data){
			$('#file-contents').empty().append(data).ready( function(){
				$('.draggable').draggable({ revert: true } );
			});
		});
	});

	$('#start-import-btn').click( function(){
		var fireOrder = [];
		$.each( $('#select-header-table').find('.droppable').find('a'), function(index,value){
			fireOrder.push( $(value).attr('ref-index') );
		});
		$('#fire-order').val( fireOrder) ;

		//get the header info and start procesing
		$('#process-import-form').submit();
	});
};

ImportController.prototype.process_file = function(){
};
