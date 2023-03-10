'use strict';

function component() {
  const element = document.createElement('div');
  element.innerHTML = 'Hello world 2';
  return element;
}

document.body.appendChild(component());
