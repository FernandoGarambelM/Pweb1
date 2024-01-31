var idUsuario = localStorage.getItem('idUser');
var nombreUsuario = localStorage.getItem('nameUser');

console.log('dato idUser:', idUsuario); 
console.log('dato nombre:', nombreUsuario); 


var inicial = document.getElementById('inicial');
var nombre = document.getElementById('name');
var id = document.getElementById('number');

inicial.innerHTML = nombreUsuario.charAt(0)+"";
nombre.innerHTML = nombreUsuario;
id.innnerHTML = idUsuario;

var url = "../cgi-bin/admin.pl?user_id=" + encodeURIComponent(idUsuario);
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
    html += "<tr><th>DNI</th><th>Nombres</th><th>Apellido paterno</th><th>Apellido materno</th><th>Nacimiento</th><th>Creado</th></tr>";
    
    usuarios.forEach(function(usuario) {
            html += "<tr>";
            html += "<td>" + usuario.dni + "</td>";
            html += "<td>" + usuario.nombres + "</td>";
            html += "<td>" + usuario.paterno + "</td>";
            html += "<td>" + usuario.materno + "</td>";
            html += "<td>" + usuario.nacimiento + "</td>";
            html += "<td>" + usuario.creado + "</td>";
            html += "</tr>";
        
    });

    html += "</table>";
    table.innerHTML = html;
}
