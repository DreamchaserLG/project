// 柱状图 option 封装（支持双系列、工具箱、标记等）
// data: 数据数组，格式为 [[商家名称1, 注册资本, 员工数], [商家名称2, 注册资本, 员工数], ...]
// labels: 标签数组，对应data中每个子数组的第一个元素
// seriesNames: 系列名称数组，如 ['注册资本', '员工数']
function getBarOption(data, labels, seriesNames) {
    var values = [];
    data.forEach(o => {
        values.push(o.splice(1));
    });
    var series = [];
    for (let i = 0; i < seriesNames.length; i++) {
        series.push({
            name: seriesNames[i],
            type: 'bar',
            data: values.map(v => v[i]),
            markPoint: {
                data: [
                    { type: 'max', name: 'Max' },
                    { type: 'min', name: 'Min' }
                ],
                itemStyle: {
                    color: barColors.gradient[i % barColors.gradient.length]
                },
                label: {
                    formatter: function (params) {
                        return formatBarValue(params.value);
                    }
                }
            },
            markLine: {
                data: [{ type: 'average', name: 'Avg' }]
            },
            itemStyle: {
                ...barColors.itemStyle,
                color: {
                    type: 'linear',
                    x: 0,
                    y: 0,
                    x2: 0,
                    y2: 1,
                    colorStops: [
                        {
                            offset: 0,
                            color: barColors.gradient[i % barColors.gradient.length] // 顶部颜色
                        },
                        {
                            offset: 1,
                            color: hexToRGBA(barColors.gradient[i % barColors.gradient.length], barColors.bar_opacity) // 底部颜色变浅
                        }
                    ]
                }
                // barColors.gradient[i % barColors.gradient.length]
            },
            emphasis: barColors.emphasis
        });
    }
    var maxVal = 0;
    for (let i = 0; i < values.length; i++) {
        for (let j = 0; j < values[i].length; j++) {
            var n = values[i][j];
            if (typeof n === 'number' && !isNaN(n)) {
                if (n > maxVal) maxVal = n;
            }
        }
    }
    var targetTicks = 5;
    var interval = maxVal > 0 ? Math.ceil(maxVal / targetTicks) : 1;
    var yMax = interval * targetTicks;
    return {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            },
            textStyle: {
                color: barColors.tooltip.color,
            },
            valueFormatter: function (value) {
                return formatBarValue(value);
            }
        },
        legend: {
            data: seriesNames,
            textStyle: {
                color: barColors.text,
            }
        },
        grid: {
            left: '3%',
            right: '7%',
            bottom: '8%',
            top: '25%',
            containLabel: true
        },
        calculable: true,
        xAxis: [
            {
                type: 'category',
                data: labels,
                axisLine: {
                    lineStyle: {
                        color: barColors.axis.line
                    }
                },
                axisLabel: {
                    color: barColors.axis.label,
                    rotate: 45,
                    formatter: function(value) {
                        if (value.length > 5) {
                            return value.substring(0, 2) + '...';
                        }
                        return value;
                    }
                },
                splitLine: {
                    show: false
                }
            }
        ],
        yAxis: [
            {
                type: 'value',
                max: yMax,
                interval: interval,
                axisLine: {
                    lineStyle: {
                        color: barColors.axis.line
                    }
                },
                axisLabel: {
                    color: barColors.axis.label,
                    formatter: function (value) {
                        return formatBarValue(value);
                    }
                },
                splitLine: {
                    lineStyle: {
                        color: barColors.axis.splitLine
                    }
                }
            }
        ],
        dataZoom: [
            {
                type: 'slider',
                show: false,
                xAxisIndex: [0],
                start: 0,
                end: (6 / labels.length) * 100, // 默认显示6条
                height: 20,
                bottom: 0,
            },
            {
                type: 'inside',
                xAxisIndex: [0],
                start: 0,
                end: (6 / labels.length) * 100 // 同步内部缩放
            }
        ],
        series: series
    };
}
function formatBarValue(value) {
    if (value == null || value === '') return value;
    var num = Number(value);
    if (isNaN(num)) return value;
    return num.toFixed(1);
}
function initBarChartWithAutoScroll(domElement, data, labels, seriesNames) {
    const chart = echarts.init(domElement);
    const option = getBarOption(data, labels, seriesNames);
    chart.setOption(option);

    const showCount = 6; // 每次显示的条数
    const totalCount = labels.length;
    
    // 如果数据不足6条，则不启动自动滚动
    if (totalCount <= showCount) return { chart };

    let currentIndex = 0;
    const intervalId = setInterval(() => {
        // 计算当前显示的起始位置
        currentIndex = (currentIndex + 1) % totalCount;
        
        // 处理末尾情况（确保始终显示6条）
        let start, end;
        if (currentIndex + showCount > totalCount) {
            start = totalCount - showCount;
            end = totalCount - 1;
            currentIndex = 0; 
        } else {
            start = currentIndex;
            end = currentIndex + showCount - 1;
        }
        
        chart.dispatchAction({
            type: 'dataZoom',
            startValue: labels[start],
            endValue: labels[end],
            xAxisIndex: 0
        });
    }, 2500);

    return { chart, intervalId };
}
function hexToRGBA(hex, opacity) {
    let r = parseInt(hex.slice(1, 3), 16),
        g = parseInt(hex.slice(3, 5), 16),
        b = parseInt(hex.slice(5, 7), 16);
    return `rgba(${r}, ${g}, ${b}, ${opacity})`;
}
