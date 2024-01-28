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
            mostrarMensajeTarjetaExito();
        } else {
            mostrarMensajeTarjeta();
        }
    })
    .catch(error => {
        alert(error.message);
    });
}
function mostrarMensajeTarjetaExito() {
    document.getElementById('popup-content').innerHTML = `
        <p>Se ha logueado exitosamente!!!.</p>
    `;
    document.getElementById('mensajeTarjeta').style.display = 'block';
    setTimeout(function() {
        document.getElementById('user').value = '';
        document.getElementById('password').value = '';
        window.location.href = 'admin.html'; //cambiar el url para recibir el id_user (supongo que el grupo de backend se encargara de esto)
        document.getElementById('mensajeTarjeta').style.display = 'none';
    }, 1000);
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
