<template>
  <div class="screen-container">
    <iframe :src="screenUrl" frameborder="0" style="width: 100%; height: 100vh;"></iframe>
  </div>
</template>

<script>
export default {
  data() {
    return {
      screenUrl: '/screen/screen.html'  // 指向public目录下的文件
    }
  }
}
</script>

<style scoped>
.screen-container {
  width: 100%;
  height: 100vh;
  overflow: hidden;
}
</style>
