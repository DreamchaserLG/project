const devProxyTarget = process.env.VUE_APP_DEV_PROXY_TARGET || "http://127.0.0.1:5000";

module.exports = {
    devServer: {
        port: 8081,
        proxy: {
            '/api': {
                target: devProxyTarget,
                changeOrigin: true
            }
        }
    },
    publicPath: './',
    outputDir: '../../src/main/resources/static/home/dist', // build时构建文件的目录
    assetsDir: 'assets', // build时放置生成的静态资源 (js、css、img、fonts) 的 (相对于 outputDir 的) 目录
    filenameHashing: true, // 默认在生成的静态资源文件名中包含hash以控制缓存
    parallel: false,
    runtimeCompiler: false, // 是否使用包含运行时编译器的 Vue 构建版本
    productionSourceMap: false, // 如果你不需要生产环境的 source map，可以将其设置为 false 以加速生产环境构建
    transpileDependencies: ['aieditor']
}
