<template>
  <b-carousel
    id="carousel"
    v-model="slide"
    :interval="4000"
    controls
    indicators
    background="#ababab"
    style="text-shadow: 1px 1px 2px #333"
    @sliding-start="onSlideStart"
    @sliding-end="onSlideEnd"
  >
    <b-carousel-slide
      v-for="(o, i) in list"
      :key="i"
    >
      <template #img>
        <a v-if="o[vm.url]" :href="o[vm.url]" target="_blank" rel="noopener noreferrer">
          <img
            class="swiper-imgs"
            :src="getImageSrc(o[vm.img])"
            :alt="o[vm.title] || 'slide image'"
            v-default-img="fallbackImage"
          >
        </a>
        <img
          v-else
          class="swiper-imgs"
          :src="getImageSrc(o[vm.img])"
          :alt="o[vm.title] || 'slide image'"
          v-default-img="fallbackImage"
        >
      </template>
    </b-carousel-slide>
  </b-carousel>
</template>

<script>
import mixin from "@/mixins/component.js";

export default {
  mixins: [mixin],
  props: {
    list: {
      type: Array,
      default: function () {
        return [];
      },
    },
    vm: {
      type: Object,
      default: function () {
        return {
          img: "img",
          title: "title",
          url: "url",
        };
      },
    },
  },
  data() {
    return {
      slide: 0,
      sliding: null,
      fallbackImage: "../../../public/img/default.png",
    };
  },
  methods: {
    getImageSrc(img) {
      return img ? this.$fullUrl(img) : this.fallbackImage;
    },
    onSlideStart() {
      this.sliding = true;
    },
    onSlideEnd() {
      this.sliding = false;
    },
  },
};
</script>

<style scoped>
.swiper-imgs {
  display: block;
  width: 100%;
  height: 18.75rem;
  object-fit: cover;
  background: #f5f5f5;
}

@media (max-width: 996px) {
  .swiper-imgs {
    height: 12.5rem;
  }
}
</style>
