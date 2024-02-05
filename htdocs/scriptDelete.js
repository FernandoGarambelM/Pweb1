var idUsuario = localStorage.getItem('idUser');
var nombreUsuario = localStorage.getItem('nameUser');

console.log('dato idUser:', idUsuario); 
console.log('dato nombre:', nombreUsuario); 

var url = "../cgi-bin/delete1.pl?user_id=" + encodeURIComponent(idUsuario);
console.log("form data: " + url);
fetch(url, {
    method: "GET",
    headers: {
        "Content-Type": "application/x-www-form-urlencoded"
    }
})
.then(response => {
    if (response.ok) {
        return response.json();
    } else {
        throw new Error('Error en la solicitud. Estado: ' + response.status);
    }
})
.then(usuarios => {
    mostrarTabla(usuarios);
})
.catch(error => {
    alert(error.message);
});



function mostrarTabla(usuarios) {
    var table = document.getElementById("table-container");
    var html = "<table>";
    html += "<tr><th>DNI</th><th>Nombres</th><th>Apellido paterno</th><th>Apellido materno</th><th>Nacimiento</th><th>Creado</th><th>Cuentas</th></tr>";
    
    usuarios.forEach(function(usuario) {
        html += "<tr>";
        html += "<td>" + usuario.cliente.dni + "</td>";
        html += "<td>" + usuario.cliente.nombres + "</td>";
        html += "<td>" + usuario.cliente.paterno + "</td>";
        html += "<td>" + usuario.cliente.materno + "</td>";
        html += "<td>" + usuario.cliente.nacimiento + "</td>";
        html += "<td>" + usuario.cliente.creado + "</td>";
        html += "<td><button class='delete' onclick='eliminarCliente("+usuario.cliente.id+")'>Eliminar Cliente </button></td>"; // Corrección aquí

        html += "<td><table>";
        usuario.cuentas.forEach(function(cuenta) {
            html += "<tr>";
            html += "<td>Cuenta ID: " + cuenta.id + "</td>";
            html += "<td>Saldo: " + cuenta.numero + "</td>";
            html += "<td>Tipo: " + cuenta.moneda + "</td>";
            html += "<td><button class='delete' onclick='eliminarCuenta("+cuenta.id+")'>Eliminar</button></td>"; // Corrección aquí
            html += "</tr>";
        });
        
        html += "</table></td>";
        
        html += "</tr>";
    });

    html += "</table>";
    table.innerHTML = html;
}
function eliminarCuenta(cuentaId) {
    var url1 = "https://localhost/cgi-bin/delete2.pl?cuenta_id=" + encodeURIComponent(cuentaId);
    console.log("El enlace es: " + url1);
    fetch(url1, {
        method: "GET",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        }
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        } else {
            console.log("error: " + url1); 
            throw new Error('Error en la solicitud. Estado: ' + response.status);
        }
    })
    .then(data => {
        console.log(data); 
        alert("Se eliminaron los registros correctamente");
        location.reload();

    })
    .catch(error => {
        alert(error.message);
    });
}

function eliminarCliente(clienteId) {
    var url1 = "https://localhost/cgi-bin/delete3.pl?cliente_id=" + encodeURIComponent(clienteId);
    console.log("El enlace es: " + url1);
    fetch(url1, {
        method: "GET",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        }
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        } else {
            console.log("error: " + url1); 
            throw new Error('Error en la solicitud. Estado: ' + response.status);
        }
    })
    .then(data => {
        console.log(data);
        alert("Se eliminaron los registros correctamente");
        location.reload();

    })
    .catch(error => {
        alert(error.message);
    });
}
