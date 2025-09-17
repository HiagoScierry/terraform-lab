let count = 0;

function updateCounter() {
  const counterElement = document.getElementById('counter');
  if (counterElement) {
    counterElement.textContent = count;
  }
}

function incrementCounter() {
  count++;
  updateCounter();
}

function decrementCounter() {
  count--;
  updateCounter();
}

// Inicializa o contador na página ao carregar
const incrementButton = document.getElementById('increment');
const decrementButton = document.getElementById('decrement');

if (incrementButton) {
  incrementButton.addEventListener('click', incrementCounter);
}

if (decrementButton) {
  decrementButton.addEventListener('click', decrementCounter);
}