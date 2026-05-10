// 动态排序折线图 option 封装
// names: 名称数组
// xAxis: x轴数组
// dynamicData: 数据数组，格式为 [[交付日期, 总价格, 商品名称], ...]
function getDynamicLineOption(names, xAxis, dynamicData) {
    // 按名称分组数据
    const seriesData = names.map((name, index) => {
        const data = dynamicData
            .filter(item => item[2] === name)
            .sort((a, b) => xAxis.indexOf(a[0]) - xAxis.indexOf(b[0]))
            .map(item => item[1]);

        return {
            name: name,
            type: 'line',
            smooth: true,
            data: data,
            itemStyle: { color: dynamicLineColors.colorList[index % dynamicLineColors.colorList.length] }
        };
    });

    return {
        title: {
            // text: '商品定制价格趋势',
            textStyle: { color: dynamicLineColors.text, fontSize: 20 }
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            },
            textStyle: { }
        },
        legend: {
            data: names,
            type: 'scroll',
            textStyle: { color: dynamicLineColors.legend },
            pageTextStyle: { color: dynamicLineColors.legend }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            data: xAxis,
            axisLabel: {
                color: dynamicLineColors.xAxis,
                formatter: function (value) {
                    if (value && value.length > 5) {
                        return value.substring(0, 4) + '...';
                    }
                    return value;
                }
            }
        },
        yAxis: {
            type: 'value',
            axisLabel: { color: dynamicLineColors.yAxis }
        },
        series: seriesData
    };
}
