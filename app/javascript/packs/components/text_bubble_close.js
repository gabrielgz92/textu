const bubble = document.querySelector('.welcome-entry');

if (bubble){
  const closeButton = bubble.querySelector('.close-welcome');
  closeButton.addEventListener('click', (event) => {
    bubble.classList.add('d-none');
  });
}
