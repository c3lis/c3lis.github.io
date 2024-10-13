document.addEventListener('DOMContentLoaded', function() {
  const images = document.querySelectorAll('section img');

  images.forEach(img => {
      img.addEventListener('click', function() {
          this.classList.toggle('zoom'); // Alterna la clase zoom
      });
  });
});