const controllers = [...new Set([...document.querySelectorAll('[data-controller]')].map(el => el.getAttribute('data-controller')))];
