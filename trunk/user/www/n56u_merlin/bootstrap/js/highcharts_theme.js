/**
 * Created with JetBrains PhpStorm.
 * User: eagle23
 * Date: 30.06.12
 * Time: 16:54
 * To change this template use File | Settings | File Templates.
 */
Highcharts.theme = {
    colors: ['#2d9bd1', '#72c267', '#f06f3d', '#d8d63d', '#57c7d8', '#8ad76f', '#ff9b4a', '#dfe88d', '#79e0c2'],
    chart: {
        backgroundColor: {
            linearGradient: [0, 0, 500, 500],
            stops: [
                [0, '#506166'],
                [1, '#3f5054']
            ]
        },
        borderRadius: 5,
        borderWidth: 1,
        borderColor: '#6b8fa3',
        plotBackgroundColor: '#26363b',
        plotBorderColor: '#6b8fa3',
        plotShadow: false,
        plotBorderWidth: 1
    },
    title: {
        style: {
            color: '#ffffff',
            fontFamily: '"Trebuchet MS", Verdana, sans-serif',
            fontWeight: 'bold',
            fontSize: '16px'
        }
    },
    subtitle: {
        style: {
            color: '#c8d7dc',
            fontFamily: '"Trebuchet MS", Verdana, sans-serif',
            fontWeight: 'bold',
            fontSize: '12px'
        }
    },
    xAxis: {
        gridLineWidth: 0,
        gridLineColor: '#4f6268',
        lineWidth: 1,
        lineColor: '#6b8fa3',
        tickWidth: 1,
        tickLength: 4,
        tickColor: '#6b8fa3',
        labels: {
            y: 15,
            autoRotation: false,
            style: {
                color: '#c8d7dc',
                fontFamily: '"Trebuchet MS", Verdana, sans-serif',
                fontSize: '11px'
            }
        },
        title: {
            style: {
                color: '#9ed3ea',
                fontFamily: '"Trebuchet MS", Verdana, sans-serif',
                fontWeight: 'bold',
                fontSize: '12px'
            }
        }
    },
    yAxis: {
        gridLineWidth: 1,
        gridLineColor: '#4f6268',
        minorGridLineWidth: 0,
        minorGridLineColor: '#35484d',
        minorTickInterval: 'auto',
        lineWidth: 0,
        lineColor: '#6b8fa3',
        tickWidth: 0,
        tickColor: '#6b8fa3',
        labels: {
            x: 2,
            align: 'left',
            style: {
                color: '#c8d7dc',
                fontFamily: '"Trebuchet MS", Verdana, sans-serif',
                fontSize: '11px'
            }
        },
        title: {
            style: {
                color: '#9ed3ea',
                fontFamily: '"Trebuchet MS", Verdana, sans-serif',
                fontWeight: 'bold',
                fontSize: '12px'
            }
        }
    },
    plotOptions: {
        series: {
            shadow: false
        }
    },
    tooltip: {
        backgroundColor: '#1f2d35',
        borderColor: '#6b8fa3',
        borderWidth: 1,
        borderRadius: 3,
        shadow: false,
        style: {
            color: '#ffffff',
            fontSize: '12px',
            padding: '8px'
        }
    },
    legend: {
        backgroundColor: 'rgba(31, 45, 53, 0.88)',
        borderColor: '#6b8fa3',
        borderWidth: 1,
        borderRadius: 3,
        itemStyle: {
            color: '#e7f2f5',
            fontFamily: '"Trebuchet MS", Verdana, sans-serif',
            fontWeight: 'normal',
            fontSize: '12px'
        },
        itemHoverStyle: {
            color: '#ffffff'
        },
        itemHiddenStyle: {
            color: '#7f9299'
        }
    },
    rangeSelector: {
        buttonTheme: {
            fill: '#2f3d42',
            stroke: '#6b8fa3',
            'stroke-width': 1,
            r: 0,
            style: {
                color: '#d7e7ee',
                fontWeight: 'normal'
            },
            states: {
                hover: {
                    fill: '#596e74',
                    style: {
                        color: '#ffffff'
                    }
                },
                select: {
                    fill: '#6f8792',
                    style: {
                        color: '#ffffff',
                        fontWeight: 'bold'
                    }
                }
            }
        },
        labelStyle: {
            color: '#d7e7ee'
        },
        inputStyle: {
            color: '#d7e7ee'
        }
    },
    navigator: {
        margin: 10,
        maskFill: 'rgba(106, 143, 163, 0.28)',
        outlineColor: '#6b8fa3',
        series: {
            color: '#7fb4d1',
            lineColor: '#7fb4d1'
        },
        xAxis: {
            gridLineColor: '#4f6268',
            labels: {
                style: {
                    color: '#c8d7dc'
                }
            }
        }
    },
    scrollbar: {
        barBackgroundColor: '#596e74',
        barBorderColor: '#6b8fa3',
        buttonBackgroundColor: '#2f3d42',
        buttonBorderColor: '#6b8fa3',
        rifleColor: '#d7e7ee',
        trackBackgroundColor: '#1f2d35',
        trackBorderColor: '#4f6268'
    },
    credits: {
        style: {
            color: '#a7b8be'
        }
    },
    labels: {
        style: {
            color: '#c8d7dc'
        }
    }
};

// Apply the theme
var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
