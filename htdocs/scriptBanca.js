function login(event) {
    event.preventDefault();
    var username = document.getElementById('username').value;
    var password = document.getElementById('password').value;
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/cgi-bin/banca.pl', true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            if (xhr.status == 200) {
                var response = JSON.parse(xhr.responseText);
                if (response.isLoggedIn) {
                    alert('¡Bienvenido!');
                } else {
                    mostrarMensajeTarjeta();
                }
            } else {
                alert('Error en la solicitud. Estado: ' + xhr.status);
            }
        }
    };
    var formData = 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password);
    xhr.send(formData);
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
