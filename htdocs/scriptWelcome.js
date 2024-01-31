var datoRecibido = localStorage.getItem('numero');
var nombres;
var paterno;
var creado;
var xhr = new XMLHttpRequest();
xhr.open('POST', '../cgi-bin/welcome.pl', true);
xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
xhr.onreadystatechange = function () {
    if (xhr.readyState == 4) {
        if (xhr.status == 200) {
            var response = JSON.parse(xhr.responseText);
            nombres = response.nombres;
            paterno = response.paterno;
            creado  = response.creado;
            actualizarElementosHTML();
        } else {
            alert('Error en la solicitud. Estado: ' + xhr.status);
        }
    }
};
var formData = 'numero=' + encodeURIComponent(datoRecibido);
console.log('Form Data:', formData); 
xhr.send(formData);

function actualizarElementosHTML() {
    var elementosNumero = document.getElementsByClassName('number');
    var elementosNombre = document.getElementsByClassName('name');
    var elementosCreado = document.getElementsByClassName('date');
    
    inicial.innerHTML = nombres.charAt(0)+"";
    
    for (var i = 0; i < elementosNumero.length; i++) {
        elementosNumero[i].textContent = datoRecibido;
    }

    for (var i = 0; i < elementosNombre.length; i++) {
        var nombreCompleto = (nombres && paterno) ? nombres + " " + paterno : '';
        elementosNombre[i].textContent = nombreCompleto;
    }

    for (var i = 0; i < elementosCreado.length; i++) {
        elementosCreado[i].textContent = creado;
    }
}
