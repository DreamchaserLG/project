// 玫瑰图 option 封装
// data: 数据数组
// labels: 标签数组
function getRoseOption(data, labels) {
    return {
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b} : {c}个',
            textStyle: {
                color: roseColors.tooltip.color
            }
        },
        legend: {
            type: 'scroll',
            left: 'left',
            orient: 'vertical',
            pageTextStyle: { color: roseColors.text },
            textStyle: {
                color: roseColors.text
            }
        },
        series: [
            {
				name: '数据分布',
                type: 'pie',
                radius: ['10%', '75%'],
                center: ['50%', '45%'],
                roseType: 'area',
                itemStyle: {
                    borderRadius: 5,
                    borderColor: roseColors.border,
                    borderWidth: 2
                },
                label: {
                    show: true,
                    color: roseColors.text,
                    formatter: '{b}: {c}个'
                },
                labelLine: {
                    show: true,
                    lineStyle: {
                        color: roseColors.labelLine
                    }
                },
                emphasis: roseColors.emphasis,
                areaStyle: roseColors.areaStyle,
                data: labels.map((label, index) => ({
                    value: data[index],
                    name: label,
                    itemStyle: {
                        color: roseColors.gradient[index % roseColors.gradient.length]
                    }
                }))
            }
        ]
    };
}
