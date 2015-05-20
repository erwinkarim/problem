var WelcomeController = Paloma.controller('Welcome');

WelcomeController.prototype.index = function(){
	console.log('loaded welcome/index');
};

WelcomeController.prototype.test = function(){
		//put typeahead here
		$('#search-user').typeahead({
			delay: 300,
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
