import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

const router = new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => {
        return import('./views/Login.vue')
      }
    },
    {
      path: '/signup',
      name: 'signup',
      component: () => {
        return import('./views/Signup.vue')
      }
    },
    {
      path: '/arena',
      name: 'arena',
      component: () => {
        return import('./views/Arena.vue')
      },
      meta: { requiresAuth: true }
    },
    {
      path: '/game',
      name: 'game',
      component: () => {
        return import('./views/Game.vue')
      },
      meta: { requiresAuth: true }
    }
  ]
})

router.beforeEach((to, from, next) => {
  const authenticated = localStorage.getItem('authenticated');

  if (to.matched.some(record => record.meta.requiresAuth) && !authenticated) {
      return next({
          path: '/',
          query: { ...to.query }
      });
  }

  next();
});

export default router