document.addEventListener('DOMContentLoaded', function() {
  const overlay = document.querySelector('.overlay');
  document.querySelectorAll('section img').forEach(img => {
    img.addEventListener('click', function() {
      this.classList.toggle('zoom'); // Alterna el zoom en la imagen
      overlay.classList.toggle('active'); // Alterna la visibilidad del fondo
    });
  });

  // Cerrar el zoom y el fondo desvanecido si se hace clic fuera de la imagen
  overlay.addEventListener('click', function() {
    document.querySelectorAll('section img.zoom').forEach(img => {
      img.classList.remove('zoom');
    });
    overlay.classList.remove('active');
  });
});
