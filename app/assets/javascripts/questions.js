
var QuestionsController = new Paloma.controller('Questions');

QuestionsController.prototype.index = function(){
	$(document).ready(function(){
		console.log('question loaded');

		//load the questions
		$.get('/questions.template', null, function(data, textStatus, jqXHR){
			$('#question-list').empty().append( data );
		});

		$('#submit-question').click( function(){
			console.log('question submited');

			//sanity check, question cannot be empty
			if ( $('#the-question').val() == "" ){
				$('#ask-modal-status').text('Question cannot be empty!');
				return;
			}

			//everything ok, submit
			$('#ask-modal-status').text($.parseHTML('<i class="fa fa-spinner fa-spin"></i> Sending question...'));
			$.post('/questions', $('#the-question-form').serialize(), function(){
				console.log('question submited');
			});

			//reset the modal box and dismiss
			$('#the-question').val('');
			$('#comments-to-the-question').val('');
			$('#ask-modal-status').empty();
			$('#close-question-box').click();

		});
	});
};

QuestionsController.prototype.show = function(){
	$(document).ready(function(){
		$.get('/questions/' + $('#question-body').attr('data-id') + '.template', null, function(data){
			$('#question-body').empty().append(data);
		});
	});
};
