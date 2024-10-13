const container = document.getElementById('pointContainer');

function createPoint() {
    const point = document.createElement('div');
    point.className = 'point';
    
    // Posiciona el punto en una posición aleatoria dentro del contenedor
    point.style.left = Math.random() * 100 + '%'; 
    point.style.top = Math.random() * 100 + '%';

    container.appendChild(point);
    
    // Elimina el punto después de un tiempo para evitar que el DOM crezca indefinidamente
    setTimeout(() => {
        point.remove();
    }, 2000); // Tiempo que el punto estará visible
}

// Crea un nuevo punto cada 500ms
setInterval(createPoint, 500);
