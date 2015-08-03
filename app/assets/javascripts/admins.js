
var AdminsController = Paloma.controller('Admins');

AdminsController.prototype.index = function(){
	console.log('loaded admin/index');

	var remove_admin = function(target){
			$(target).click( function(){
				$.ajax('/admins/' + $(this).attr('data-id') ,
					{ method:'DELETE', data: $(this).closest('form').serialize() }
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
			$.post('/admins', $('#new-admin-form').serialize() ,function(data){
				$('#admin-list').find('#no-one-is-here').remove();
				$('#admin-list').append(data);
			});
		});
	});
};

AdminsController.prototype.setup = function(){
	console.log('loaded admin/setup')
	$(document).ready(function(){
		$('[data-toggle="popover"]').popover();
	});
};


AdminsController.prototype.reports_show = function(){
	console.log('loaded admin/reports_show');

	//setup the chart
	var issueChartOptions = {
		title: {text:'Issues' },
		chart: { renderTo: 'issues-chart', type:'column' },
		series:[],
		xAxis: { categories:[] }
	};


	var xtraInfoOptions = {
		title: {text:'Extra Infos' },
		chart: { renderTo: 'xtra-info-chart', type:'column' },
		series:[],
		xAxis: { categories:[] }
	};

	//get the data from current address
	$.getJSON(window.location.href, function(data){
		//load chart data
		issueChartOptions.xAxis.categories = data.chart1.categories;
		issueChartOptions.series =  [
			{ name: data.chart1.series[0].name, data: data.chart1.series[0].data },
			{ name: data.chart1.series[1].name, data: data.chart1.series[1].data },
			{ name: data.chart1.series[2].name, data: data.chart1.series[2].data }
		 ];

		//draw the issue chart
		var issueChart = new Highcharts.Chart(issueChartOptions);

		xtraInfoOptions.xAxis.categories = data.chart2.caissueChartOptionstegories;
		xtraInfoOptions.series = [
			{ name: data.chart2.series[0].name, data: data.chart2.series[0].data }
		];

		var xtraInfoChart = new Highcharts.Chart(xtraInfoOptions);
	});

};
