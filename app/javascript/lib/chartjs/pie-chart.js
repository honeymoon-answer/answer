import { Pie, mixins } from 'vue-chartjs'
const { reactiveProp } = mixins

/*
this.renderChart({
  labels: ['VueJs', 'EmberJs', 'ReactJs', 'AngularJs'],
  datasets: [
    {
      backgroundColor: [
        '#41B883',
        '#E46651',
        '#00D8FF',
        '#DD1B16'
      ],
      data: [40, 20, 80, 10]
    }
  ]
}, {responsive: true, maintainAspectRatio: false})
*/

export default Pie.extend({
  mixins: [reactiveProp],
  props: ['chartData'],
  mounted () {
    this.renderChart(this.chartData, {responsive: true, maintainAspectRatio: false})
  }
})
