function loginUser(event) {
    event.preventDefault();

    var username = document.getElementById('user').value;
    var password = document.getElementById('password').value;

    fetch('/cgi-bin/login.pl', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'user=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password),
    })
    
    .then(response => {
        if (!response.ok) {
            throw new Error('Error en la solicitud. Estado: ' + response.status);
        }
        return response.json();
    })
    .then(data => {
        if (data.isUser) {
            alert('¡Bienvenido!');
        } else {
            mostrarMensajeTarjeta();
        }
    })
    .catch(error => {
        alert(error.message);
    });
}

function mostrarMensajeTarjeta() {
    document.getElementById('popup-content').innerHTML = `
        <p>Parece que aún no eres un cliente de este banco.</p>
        <button onclick="redirectToInicio()">Regresar al inicio</button>
        <button onclick="cerrarPopup()">Cerrar</button>
    `;
    document.getElementById('mensajeTarjeta').style.display = 'block';
}
function ocultarMensajeTarjeta() {
    document.getElementById('mensajeTarjeta').style.display = 'none';
}
function redirectToInicio() {
    window.location.href = 'index.html';
}
function mostrarPopup() {
    document.getElementById('mensajeTarjeta').style.display = 'flex';
}

function cerrarPopup() {
    document.getElementById('mensajeTarjeta').style.display = 'none';
}
