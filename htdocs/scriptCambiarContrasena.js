var idUsuario = localStorage.getItem('idUser');
var selectElement;
var selectedNumber;
var newPassword;

document.addEventListener('DOMContentLoaded', function () {
    opciones();
    document.getElementById('actual-password').addEventListener('input', function () {
        var currentPassword = this.value;
        verificarContrasena(currentPassword);
    });
    document.getElementById('new-password').addEventListener('input', function () {
        validarCoincidenciaContrasenas();
    });

    document.getElementById('new-confirmed-password').addEventListener('input', function () {
        validarCoincidenciaContrasenas();
    });
});

function opciones() {
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '../cgi-bin/opciones_usuario.pl', true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            if (xhr.status == 200) {
                var response = JSON.parse(xhr.responseText);
                selectElement = document.getElementById("number-cuenta");

                if (selectElement) {
                    selectElement.innerHTML = "";
                    for (var i = 0; i < response.length; i++) {
                        var option = document.createElement("option");
                        option.value = response[i].numero;
                        option.text = response[i].numero; 
                        selectElement.add(option);
                    }

                    handleSelectChange();

                    selectElement.addEventListener('change', function () {
                        handleSelectChange();
                    });
                } else {
                    console.error('El elemento select no fue encontrado.');
                }
            } else {
                console.error('Error en la solicitud. Estado: ' + xhr.status);
            }
        }
    };
    var formData = 'idUser=' + encodeURIComponent(idUsuario);
    xhr.send(formData);
}

function handleSelectChange() {
    selectedNumber = selectElement.value;
}

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
                    console.log("color: green");
                } else {
                    document.getElementById('actual-password').style.color = 'red';
                    console.log("color: red");
                }
            } else {
                console.error('Error en la solicitud. Estado: ' + xhr.status);
            }
        }
    };
    var formData = 'currentPassword=' + encodeURIComponent(currentPassword) + '&number_cuenta=' + encodeURIComponent(selectedNumber);
    xhr.send(formData);
}

function validarCoincidenciaContrasenas() {
    newPassword = document.getElementById('new-password').value;
    var confirmedPassword = document.getElementById('new-confirmed-password').value;
    var mensajeError = document.getElementById('mensaje-error-contrasena');

    if (newPassword === confirmedPassword) {
        mensajeError.style.display = 'none';
    } else {
        mensajeError.style.display = 'block';
    }
}

function cambiarContrasena(event) {
    event.preventDefault();
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '../cgi-bin/cambiarContrasena.pl', true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            if (xhr.status == 200) {
                var response = JSON.parse(xhr.responseText);
                if(response.isCorrect){
                    console.log("realizado");
                    mostrarMensajeTarjeta();
                }
            } else {
                console.error('Error en la solicitud. Estado: ' + xhr.status);
            }
        }
    };
    var formData = 'number_cuenta=' + encodeURIComponent(selectedNumber) + '&new_password=' + encodeURIComponent(newPassword);
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
