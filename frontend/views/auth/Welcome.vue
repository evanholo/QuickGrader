<script setup>
import { useRouter } from 'vue-router';
const router = useRouter();


</script>

<template>
  <div class="grey-background">
    <div class="c0">

        <h1>Reform Your Home Flipping Experience!</h1>
        <p>
          We make it easy to walk into a home, estimate the cost of
          rehabilitating it, and manage all your properties, rooms, and
          materials in one place.
        </p>

    </div>
  </div>
</template>

<style scoped>
@media screen and (min-width: 429px) {
  .img {
    margin-top: 30px;
    margin-bottom: 45px;
  }
}

@media screen and (max-width: 429px) {
  .img {
    width: 75%;
    margin-top: 30px;
    margin-bottom: 45px;
  }
}

.grey-background {
  display: flex;
  flex-flow: column;
  align-items: center;
  justify-content: flex-start;
  background-color: #f3f4f3;
  height: 100dvh;
  width: 100vw;
  overflow: scroll;
  padding: 0px;
}

.c0 {
  display: flex;
  flex-flow: column nowrap;
  flex: 0 0 auto;
  align-items: center;
  justify-content: flex-start;
}

h1 {
  font-family: 'Outfit';
  font-style: normal;
  font-weight: 700;
  font-size: 24px;
  line-height: 34px;
  letter-spacing: 0.02em;
  color: #ff6f48;
  margin-top: 25px;
  margin-bottom: 0px;
  text-align: center;
  width: 300px;
}

p {
  font-family: 'Outfit';
  font-style: normal;
  font-weight: 300;
  font-size: 12px;
  line-height: 25px;
  letter-spacing: 0.03em;
  color: #08182f;
  margin-top: 40px;
  margin-bottom: 0px;
  text-align: center;
  width: 320px;
}
</style>
