import Chart from 'chart.js'

document.addEventListener('DOMContentLoaded', () => {
  window.chartColors = {
    red: 'rgb(255, 99, 132)',
    orange: 'rgb(255, 159, 64)',
    yellow: 'rgb(255, 205, 86)',
    green: 'rgb(75, 192, 192)',
    blue: 'rgb(54, 162, 235)',
    purple: 'rgb(153, 102, 255)',
    grey: 'rgb(201, 203, 207)'
  };
  var ctx = document.getElementById("result_report");
  new Chart(ctx,{
    type: 'pie',
    data: {
      datasets: [{
        data: [5, 10, 15, 20, 50],
        backgroundColor: [
          window.chartColors.red,
          window.chartColors.orange,
          window.chartColors.yellow,
          window.chartColors.green,
          window.chartColors.blue,
        ],
      }],
      // These labels appear in the legend and in the tooltips when hovering different arcs
      labels: [
        '回答A',
        '回答B',
        '回答C',
        '回答D',
        '回答E',
      ]
    },
    options: {}
  });
})