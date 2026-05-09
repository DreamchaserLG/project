<template>
  <div class="bar_chart" :id="idName">条形图</div>
</template>
<script>
import * as echarts from "@/assets/js/echarts.min.js";

export default {
  props: {
    idName: {
      type: String,
      default: "barChart"
    },
    title: {
      type: String,
      default: "XXX条形图"
    },
    vm: {
      type: Object,
      default: function() {
        return {
          yAxis: "yAxis",
          names: "names",
          values: "values"
        };
      }
    }
  },
  data() {
    return {
      option: {
        title: {
          text: "XXX条形图",
          left: "center"
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        legend: {
          data: [],
          type: 'scroll',
          orient: 'horizontal',
          y: 'bottom'
        },
        xAxis: [{
          type: 'value'
        }],
        yAxis: [{
          type: 'category',
          data: []
        }],
        series: [
          {
            name: 'Forest',
            type: 'bar',
            barGap: 0,
            emphasis: {
              focus: 'series'
            },
            data: [320, 332, 301, 334, 390]
          }
        ]
      }
    };
  },
  computed: {
    series() {
      // 保留原计算属性逻辑，直接访问this.vm
      let values = this.vm.values;
      return values;
    }
  },
  mounted() {
    // Vue3 onMounted 转换为 Vue2 mounted 生命周期
    setTimeout(() => {
      this.init_chart();
    }, 200);
  },
  methods: {
    init_chart() {
      let optionObj = this.option;
      let titleObj = this.title;
      
      // 设置标题
      if (titleObj) {
        optionObj.title.text = titleObj;
      }

      // 更新系列数据和名称
      optionObj.series[0].data = this.series;
      optionObj.series[0].name = this.vm.names[0];

      // 设置y轴数据
      let yAxis = optionObj.yAxis[0];
      yAxis.data = this.vm.xAxis;

      // y轴标签换行处理（当数据长度超过4时）
      if (yAxis.data.length > 4) {
        optionObj.axisLabel = {
          interval: 0,
          formatter: function(params) {
            let newParamsName = '';
            const paramsNameNumber = params.length;
            const provideNumber = 4;
            const rowNumber = Math.ceil(paramsNameNumber / provideNumber);
            
            if (paramsNameNumber > provideNumber) {
              for (let p = 0; p < rowNumber; p++) {
                const start = p * provideNumber;
                const end = start + provideNumber;
                const tempStr = p === rowNumber - 1 
                  ? params.substring(start, paramsNameNumber) 
                  : params.substring(start, end) + '\n';
                newParamsName += tempStr;
              }
            } else {
              newParamsName = params;
            }
            return newParamsName;
          }
        };
      }

      // 初始化图表
      let myChart = echarts.init(document.getElementById(this.idName));
      myChart.setOption(optionObj);
    }
  }
};
</script>
