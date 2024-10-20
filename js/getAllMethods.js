Object.restrictedProps = new Set(['caller', 'callee', 'arguments']);
Object.prototype.getAllMethods = function (shallow = false) {
  const properties = new Set();
  const methods = new Set();

  let currentObj = this;
  while (currentObj) {
    for (const prop of Object.getOwnPropertyNames(currentObj)) {
      if (Object.restrictedProps.has(prop)) continue;

      const set = typeof currentObj[prop] === 'function' ? methods : properties;
      set.add(prop);
    }
    currentObj = shallow === false ? Object.getPrototypeOf(currentObj) : null;
  }

  return {
    properties: [...properties],
    methods: [...methods],
  };
};
