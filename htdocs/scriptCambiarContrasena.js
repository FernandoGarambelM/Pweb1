//Aun falta completar 
document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('actual-password').addEventListener('input', function () {
        var currentPassword = this.value;
        verificarContrasena(currentPassword);
    });
});

function verificarContrasena(currentPassword) {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '../cgi-bin/verificar_contrasena.pl', true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            if (xhr.status == 200) {
                var response = JSON.parse(xhr.responseText);;
                if (response.isCorrect) {
                    document.getElementById('actual-password').style.color = 'green';
                } else {
                    document.getElementById('actual-password').style.color = 'red';
                }
            } else {
                console.error('Error en la solicitud. Estado: ' + xhr.status);
            }
        }
    };
    var formData = 'currentPassword=' + encodeURIComponent(currentPassword);
    xhr.send(formData);
}

function cambiarContrasena() {
    var idUsuario = localStorage.getItem('idUser');
    var password = document.getElementById('actual-password').value;
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '../cgi-bin/cambiarContrasena.pl', true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            if (xhr.status == 200) {
                var response = JSON.parse(xhr.responseText);
                if(response.responseText){
                    mostrarMensajeTarjeta();
                }
            } else {
                console.error('Error en la solicitud. Estado: ' + xhr.status);
            }
        }
    };
    var formData = 'idUser=' + encodeURIComponent(idUsuario) + '&password=' + encodeURIComponent(password);
    xhr.send(formData);
}

function mostrarMensajeTarjeta() {
    document.getElementById('popup-content').innerHTML = `
        <p>Se actualizo la contraseña con éxito</p>
        <button onclick="redirectToInicio()">Regresar</button>
        <button onclick="cerrarPopup()">Hacer otro cambio de contraseña</button>
    `;
    document.getElementById('mensajeTarjeta').style.display = 'block';
}
function ocultarMensajeTarjeta() {
    document.getElementById('mensajeTarjeta').style.display = 'none';
}
function redirectToInicio() {
    window.location.href = 'admin.html';
}

function mostrarPopup() {
    document.getElementById('mensajeTarjeta').style.display = 'flex';
}

function cerrarPopup() {
    document.getElementById('mensajeTarjeta').style.display = 'none';
}
