import { createRouter, createWebHashHistory } from 'vue-router';
import Welcome from '@/views/auth/Welcome.vue';
const router = createRouter({
    history: createWebHashHistory(),
    routes: [
        {
            path: '/',
            component: Welcome,
        },
    ],
});  